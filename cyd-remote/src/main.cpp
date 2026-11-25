// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Rev. J. Money
// Orphan Remote: generic Linux scene terminal + RGB565 rectangle transport + game stream (TCP 8092).
#include <Arduino.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <Preferences.h>
#include <ArduinoJson.h>
#include <ESPmDNS.h>
#include <WiFiUdp.h>
#include "board.h"

WiFiServer control(80);
WiFiServer graphics(8091);
WiFiServer gameServer(8092);
WiFiUDP gameUdp;uint32_t udpBytes=0,udpPackets=0,udpLost=0;   // game stream over UDP 8093 (TCP on this ESP32 tops out ~480 KB/s)
constexpr int GameLanes=4;              // parallel connections: each has its own small lwIP receive window
WiFiClient gameLane[GameLanes];
WiFiClient* gameClient=&gameLane[0];   // the lane being read
String target="http://orphan.local:8090";
const char* views[]={"system","mining","projects","radio","synth"};
int view=0;
uint32_t lastPoll=0,lastTouch=0,lastFrame=0;
uint32_t frameCount=0,frameTransferMs=0;
float frameFps=0;
bool hudOn=true;     // last frame's hud= flag: hud=0 keeps the temp/FPS box off, also on the 5 s timer
float chipTemperature=NAN;
uint32_t lastTemperaturePoll=0;
bool online=false;
constexpr int TileWidth=320, TileHeight=64, MaxTiles=8;
constexpr uint32_t SceneIntervalMs=450, GraphicsHoldMs=10000;
lgfx::LGFX_Sprite tileSprite(&tft);
uint32_t tileRevision[MaxTiles]={};
bool tileValid[MaxTiles]={};
bool redrawScene=true;
uint32_t scenePolls=0,sceneTilesDrawn=0,sceneDrawMs=0;
void temperaturePoll(){
 if(WiFi.status()!=WL_CONNECTED)return;
 HTTPClient h;h.setConnectTimeout(300);h.setTimeout(500);h.begin(target+"/api/temperature");
 if(h.GET()==200){JsonDocument d;if(!deserializeJson(d,h.getString()) && d["temperature"].is<float>())chipTemperature=d["temperature"].as<float>();}
 h.end();lastTemperaturePoll=millis();
}
void graphicsHud(){
 tft.fillRect(170,2,148,13,0x0000);tft.setTextColor(0xfdaa);tft.setTextSize(1);tft.setCursor(174,5);
 if(!isnan(chipTemperature))tft.printf("%.1fC  ",chipTemperature);
 tft.printf("%4.1f FPS",frameFps);
}
uint16_t color(const char* s) {uint32_t v=strtoul(s[0]=='#'?s+1:s,nullptr,16);return tft.color565(v>>16,v>>8,v);}
void title(const char* msg){tft.fillScreen(0x0862);tft.setTextColor(0xfdaa);tft.setTextSize(3);tft.setCursor(12,18);tft.print("ORPHAN");tft.setTextSize(1);tft.setCursor(12,55);tft.print("by JMSCNC, makers of RotatoCAM");tft.setCursor(12,100);tft.setTextColor(0xffff);tft.print(msg);}
bool connectSaved(){
 WiFi.mode(WIFI_STA);WiFi.setHostname("orphan-remote");WiFi.setAutoReconnect(true);WiFi.setSleep(false);
 Preferences p;p.begin("net",true);
 for(int i=0;i<5;i++){
  String ssid=p.getString(("s"+String(i)).c_str(),"");
  if(!ssid.length())continue;
  String pw=p.getString(("p"+String(i)).c_str(),"");
  WiFi.begin(ssid.c_str(),pw.c_str());
  uint32_t begin=millis();while(WiFi.status()!=WL_CONNECTED && millis()-begin<12000)delay(50);
  if(WiFi.status()==WL_CONNECTED){p.end();return true;}
 }
 p.end();
 // ESP32 Arduino also remembers the last station connection in its Wi-Fi NVS.
 WiFi.begin();uint32_t begin=millis();while(WiFi.status()!=WL_CONNECTED && millis()-begin<12000)delay(50);
 return WiFi.status()==WL_CONNECTED;
}
void drawItems(lgfx::LovyanGFX& canvas,JsonArray items,int offsetY=0){
 canvas.setTextWrap(false,false);
 for(JsonObject item:items){
  String type=item["type"]|"text";int x=item["x"]|0,y=(item["y"]|0)+offsetY;
  if(type=="text"){
   canvas.setTextColor(color(item["color"]|"#ffffff"));canvas.setTextSize(constrain(item["size"]|1,1,4));canvas.setCursor(x,y);canvas.print(item["text"]|"");
  }else if(type=="rect")canvas.fillRect(x,y,item["w"]|1,item["h"]|1,color(item["color"]|"#ffffff"));
  else if(type=="graph"){
   int w=constrain(item["w"]|1,1,320),h=constrain(item["h"]|1,1,240);
   JsonArray points=item["points"].as<JsonArray>();
   uint16_t stroke=color(item["color"]|"#61dbc4"),grid=color("#283d4c");
   for(int i=0;i<3;i++)canvas.drawFastHLine(x,y+(h-1)*i/2,w,grid);
   int lastX=-1,lastY=0,idx=0,count=points.size();
   if(count<2 || count>120)continue;
   for(JsonVariant value:points){
    int px=x+idx++*(w-1)/(count-1);
    if(value.isNull()){lastX=-1;continue;}
    int py=y+(h-1)*(100-constrain(value.as<int>(),0,100))/100;
    if(lastX>=0)canvas.drawLine(lastX,lastY,px,py,stroke);
    else canvas.drawPixel(px,py,stroke);
    lastX=px;lastY=py;
   }
  }
 }
}
void sceneError(const char* message){
 if(online || redrawScene){title(message);redrawScene=false;}
 online=false;
 for(bool& valid:tileValid)valid=false;
}
void scene(){
 if(WiFi.status()!=WL_CONNECTED){sceneError("WiFi disconnected. Reconnecting...");return;}
 HTTPClient h;h.setConnectTimeout(400);h.setTimeout(550);
 h.begin(target+"/api/display?tiles=1&view="+views[view]);int status=h.GET();
 if(status!=200){h.end();sceneError("Waiting for S9 display service...");return;}
 JsonDocument doc;auto error=deserializeJson(doc,h.getStream());h.end();
 if(error){sceneError("Display scene parse error");return;}
 if((int)doc["version"]!=1)return;
 const auto began=millis();
 JsonArray tiles=doc["tiles"].as<JsonArray>();
 if(!online || redrawScene){
  tft.fillScreen(color(doc["background"]|"#0c1014"));
  for(bool& valid:tileValid)valid=false;
 }
 if(!tiles.isNull()){
  int index=0;
  for(JsonObject tile:tiles){
   if(index>=MaxTiles)break;
   int i=index++,y=tile["y"]|-1,height=tile["h"]|0;
   if(y<0 || height<1 || height>TileHeight || y+height>240)continue;
   uint32_t revision=tile["revision"].as<uint32_t>();
   if(tileValid[i] && tileRevision[i]==revision)continue;
   if(tileSprite.getBuffer()){
    tileSprite.fillScreen(color(tile["background"]|"#0c1014"));
    drawItems(tileSprite,tile["items"].as<JsonArray>());
    tft.setClipRect(0,y,TileWidth,height);tileSprite.pushSprite(0,y);tft.clearClipRect();
   }else{
    tft.startWrite();tft.setClipRect(0,y,TileWidth,height);
    tft.fillRect(0,y,TileWidth,height,color(tile["background"]|"#0c1014"));
    drawItems(tft,tile["items"].as<JsonArray>(),y);
    tft.clearClipRect();tft.endWrite();
   }
   sceneTilesDrawn++;tileRevision[i]=revision;tileValid[i]=true;
  }
 }else{
  tft.startWrite();tft.fillScreen(color(doc["background"]|"#0c1014"));
  drawItems(tft,doc["items"].as<JsonArray>());tft.endWrite();
 }
 sceneDrawMs=millis()-began;scenePolls++;online=true;redrawScene=false;
}
// Rectangle packets: POST /rect?x=N&y=N&w=N&h=N HTTP/1.1, little-endian RGB565 rows.
// Scale 2 expands source pixels on the CYD. Small strips keep memory bounded.
// WiFiClient::readBytes falls back to Stream's byte-at-a-time reads (about 300 KB/s); read in bulk instead.
bool readFull(WiFiClient& c,void* dst,size_t n,uint32_t timeoutMs=1000){
 uint8_t* p=(uint8_t*)dst;uint32_t last=millis();
 while(n){
  int a=c.available();
  if(a>0){int got=c.read(p,min((size_t)a,n));if(got>0){p+=got;n-=got;last=millis();continue;}}
  if(!c.connected() && c.available()<=0)return false;
  if(millis()-last>timeoutMs)return false;
  delayMicroseconds(200);
 }
 return true;
}
int queryInt(String query,const char* key,int fallback){String needle=String(key)+"=";int p=query.indexOf(needle);return p<0?fallback:query.substring(p+needle.length()).toInt();}
bool drawNative(WiFiClient& c,int x,int y,int w,int h){
 static uint16_t strip[320*8];
 for(int row=0;row<h;row+=8){
  int rows=min(8,h-row);size_t bytes=w*rows*2;
  if(!readFull(c,strip,bytes))return false;
  tft.pushImage(x,y+row,w,rows,strip);
 }
 return true;
}
bool drawDoubled(WiFiClient& c,int x,int y,int w,int h,bool smooth){
 static uint16_t input[3][160];
 static uint16_t strip[320*8];
 uint16_t *above=input[0],*current=input[1],*below=input[2];
 const size_t bytes=w*2;
 if(!readFull(c,current,bytes))return false;
 memcpy(above,current,bytes);
 for(int row=0;row<h;row++){
  if(row+1<h){if(!readFull(c,below,bytes))return false;}
  else memcpy(below,current,bytes);
  uint16_t* top=strip+(row%4)*4*w;
  uint16_t* bottom=top+2*w;
  for(int col=0;col<w;col++){
   uint16_t pixel=current[col],up=above[col],down=below[col];
   uint16_t left=current[max(0,col-1)],right=current[min(w-1,col+1)];
   bool edge=smooth && up!=down && left!=right;
   top[2*col]=edge && left==up ? left : pixel;
   top[2*col+1]=edge && up==right ? right : pixel;
   bottom[2*col]=edge && left==down ? left : pixel;
   bottom[2*col+1]=edge && down==right ? right : pixel;
  }
  if(row%4==3 || row+1==h){int rows=row%4+1;tft.pushImage(x,y+2*(row-rows+1),2*w,2*rows,strip);}
  uint16_t* old=above;above=current;current=below;below=old;
 }
 return true;
}
void frame(){
 WiFiClient c=graphics.available();if(c.fd()<0)return;c.setTimeout(1); // WiFiClient takes seconds
 uint32_t begin=millis();
 String line=c.readStringUntil('\n');int x=queryInt(line,"x",0),y=queryInt(line,"y",0),w=queryInt(line,"w",320),h=queryInt(line,"h",240),scale=queryInt(line,"scale",1);
 size_t length=0;
 while(c.fd()>=0 && millis()-begin<1500){String header=c.readStringUntil('\n');header.trim();if(!header.length())break;header.toLowerCase();if(header.startsWith("content-length:"))length=header.substring(15).toInt();}
 if(!line.startsWith("POST /rect") || (scale!=1 && scale!=2) || x<0 || x>=320 || y<0 || y>=240 || w<1 || h<1 || w>(320-x)/scale || h>(240-y)/scale || length!=(size_t)w*h*2){c.print("HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\nConnection: close\r\n\r\n");c.stop();return;}
 bool ok=scale==2?drawDoubled(c,x,y,w,h,queryInt(line,"smooth",0)):drawNative(c,x,y,w,h);
 if(ok){
  uint32_t now=millis();float fps=lastFrame?1000.0f/(now-lastFrame):0;
  frameFps=frameFps>0?frameFps*.7f+fps*.3f:fps;
  lastFrame=now;frameCount++;frameTransferMs=now-begin;online=true;redrawScene=true;
  hudOn=queryInt(line,"hud",1);
  if(hudOn)graphicsHud();
 }
 c.print(ok?"HTTP/1.1 200 OK\r\nContent-Length: 0\r\nConnection: close\r\n\r\n":"HTTP/1.1 408 Request Timeout\r\nContent-Length: 0\r\nConnection: close\r\n\r\n");c.stop();
}

// ---------------------------------------------------------------- game stream (TCP 8092, one connection kept open)
// Messages: u8 type, u32 length (little endian), payload.
//  1 MODE  u8 pixel bytes (1 = palette index, 2 = RGB565), u8 scale (0 = 1x, 1 = 1.5x blended), u8 flags (bit 0 hud),
//          u8 0, u16 src w, u16 src h, u16 x, u16 y, u16 palette count, palette (u16 RGB565 each). Clears the screen.
//  2 ROWS  u16 first row, u16 count, then per row: u8 encoding (0 raw, 1 runs), u16 bytes, data.
//          runs = (u8 count-1, value) pairs. With scale 1.5x the board sends whole row pairs (first row even).
//  3 END   end of a picture: the CYD answers one byte 'K' once it is drawn.
constexpr int GameMaxBytes=256*240;
static uint8_t* gameFb=nullptr;                    // the source picture (heap): bytes or u16 per pixel
static uint16_t gamePal[256];                     // RGB565 as sent
static uint16_t gamePalSw[256];                   // the same, byte-swapped = the panel's own order (no conversion on push)
static uint16_t* gameLine[2]={nullptr,nullptr};    // two DMA strips (320 x 8): one fills while the other goes out
static int gameBuf=0;
static bool gameWriting=false;
static void gameEndWrite(){if(gameWriting){tft.waitDMA();tft.endWrite();gameWriting=false;}}
int gamePb=1,gameScale=0,gameW=0,gameH=0,gameX=0,gameY=0;bool gameMode=false,gameHud=false;
uint32_t gameFrameStart=0,gameBytes=0;uint64_t gameDecodeUs=0,gameDrawUs=0,gameWaitUs=0;
static inline uint16_t gamePixel(int row,int col){
 if(gamePb==2)return ((uint16_t*)gameFb)[row*gameW+col];
 return gamePal[gameFb[row*gameW+col]];
}
static inline uint16_t blend565(uint16_t a,uint16_t b){return ((a&0xF7DE)>>1)+((b&0xF7DE)>>1);}
static uint16_t* gameStrip(){uint16_t* b=gameLine[gameBuf];gameBuf^=1;return b;}
static inline uint16_t sw16(uint16_t v){return (v>>8)|(v<<8);}
static void gamePush(int x,int y,int w,int h,uint16_t* b){uint32_t t=micros();tft.waitDMA();gameWaitUs+=micros()-t;tft.pushImageDMA(x,y,w,h,(const lgfx::swap565_t*)b);}
// 1x: rows r0..r1-1 straight out, 8 rows per DMA strip, already in the panel's byte order
static void gameDraw1x(int r0,int r1){
 for(int r=r0;r<r1;r+=8){
  int n=min(8,r1-r);uint16_t* b=gameStrip();
  if(gamePb==1){const uint8_t* src=gameFb+r*gameW;for(int i=0,e=n*gameW;i<e;i++)b[i]=gamePalSw[src[i]];}
  else{const uint16_t* src=(const uint16_t*)gameFb+r*gameW;for(int i=0,e=n*gameW;i<e;i++)b[i]=sw16(src[i]);}
  gamePush(gameX,gameY+r,gameW,n,b);
 }
}
// 1.5x: each source row pair (2p, 2p+1) becomes 3 lines (a, a/b blend, b); each pixel pair becomes 3 pixels too.
// Blends are done in RGB565, then swapped into the panel's order.
static void gameScaleRow(int row,uint16_t* o){        // native RGB565 out
 if(gamePb==1){const uint8_t* s=gameFb+row*gameW;for(int c=0;c+1<gameW;c+=2){uint16_t a=gamePal[s[c]],b=gamePal[s[c+1]];*o++=a;*o++=blend565(a,b);*o++=b;}}
 else{const uint16_t* s=(const uint16_t*)gameFb+row*gameW;for(int c=0;c+1<gameW;c+=2){uint16_t a=s[c],b=s[c+1];*o++=a;*o++=blend565(a,b);*o++=b;}}
}
static void gameDraw15(int r0,int r1){             // r0 even, r1 even
 int ow=gameW*3/2;
 for(int p=r0/2;p<r1/2;p+=2){                     // 2 pairs = 6 lines per strip
  int pairs=min(2,r1/2-p);uint16_t* b=gameStrip();
  for(int k=0;k<pairs;k++){
   uint16_t* l0=b+(k*3)*ow,*l1=l0+ow,*l2=l1+ow;
   gameScaleRow(2*(p+k),l0);gameScaleRow(2*(p+k)+1,l2);
   for(int c=0;c<ow;c++){l1[c]=sw16(blend565(l0[c],l2[c]));l0[c]=sw16(l0[c]);l2[c]=sw16(l2[c]);}
  }
  gamePush(gameX,gameY+p*3,ow,pairs*3,b);
 }
}
static const uint8_t* gameMem=nullptr;static size_t gameMemLeft=0;   // set while a UDP packet is being parsed
static bool gameRead(void* d,size_t n){
 if(gameMem){if(n>gameMemLeft)return false;memcpy(d,gameMem,n);gameMem+=n;gameMemLeft-=n;gameBytes+=n;return true;}
 bool ok=readFull(*gameClient,d,n,1500);if(ok)gameBytes+=n;return ok;
}
static bool gameRows(uint32_t len){
 uint16_t hdr[2];if(len<4 || !gameRead(hdr,4))return false;len-=4;
 int r0=hdr[0],n=hdr[1];if(!gameMode || n<1 || r0+n>gameH || (gameScale && ((r0|n)&1)))return false;
 const int rowBytes=gameW*gamePb;
 for(int r=r0;r<r0+n;r++){
  uint8_t enc;uint16_t nb;if(len<3 || !gameRead(&enc,1) || !gameRead(&nb,2))return false;len-=3;
  if(nb>len || nb>256*3)return false;
  uint8_t* dst=gameFb+r*rowBytes;
  if(enc==0){if(nb!=rowBytes || !gameRead(dst,nb))return false;}
  else{
   static uint8_t runs[256*3];if(!gameRead(runs,nb))return false;
   int rec=1+gamePb,pos=0;
   for(int i=0;i+rec<=nb;i+=rec){
    int count=runs[i]+1;if(pos+count>gameW)return false;
    if(gamePb==1){memset(dst+pos,runs[i+1],count);}
    else{uint16_t v=runs[i+1]|(runs[i+2]<<8);uint16_t* d16=(uint16_t*)dst;for(int k=0;k<count;k++)d16[pos+k]=v;}
    pos+=count;
   }
   if(pos!=gameW)return false;
  }
  len-=nb;
 }
 if(len)return false;
 uint32_t t0=micros();
 if(!gameWriting){tft.startWrite();gameWriting=true;}  // held until END: strips go out by DMA while packets arrive
 if(gameScale==1)gameDraw15(r0,r0+n);else gameDraw1x(r0,r0+n);
 gameDrawUs+=micros()-t0;
 return true;
}
static bool gameModeMsg(uint32_t len){
 uint8_t h[14];if(len<14 || !gameRead(h,14))return false;
 int pb=h[0],sc=h[1],npal=h[12]|(h[13]<<8);
 int w=h[4]|(h[5]<<8),hh=h[6]|(h[7]<<8),x=h[8]|(h[9]<<8),y=h[10]|(h[11]<<8);
 int ow=sc?w*3/2:w,oh=sc?hh*3/2:hh;
 if((pb!=1 && pb!=2) || sc>1 || w<2 || w>256 || hh<2 || w*hh*pb>GameMaxBytes || (sc && ((w|hh)&1)) || x+ow>320 || y+oh>240
    || npal>256 || len!=(uint32_t)14+npal*2)return false;
 if(npal && !gameRead(gamePal,npal*2))return false;
 for(int i=0;i<npal;i++)gamePalSw[i]=sw16(gamePal[i]);
 gameEndWrite();
 gamePb=pb;gameScale=sc;gameW=w;gameH=hh;gameX=x;gameY=y;gameHud=h[2]&1;gameMode=true;
 tft.waitDMA();tft.fillScreen(0x0000);
 return true;
}
// One lane's waiting messages. ROWS can come on any lane in any order (each names its rows); every lane ends a
// picture with END and gets its own 'K' back, so the sender knows the whole picture is on the screen.
static void gameLaneStep(int lane){
 gameClient=&gameLane[lane];
 for(int budget=0;budget<32 && gameClient->available()>=5;budget++){
  uint8_t h[5];if(!gameRead(h,5)){gameClient->stop();return;}
  uint32_t len=h[1]|(h[2]<<8)|(h[3]<<16)|((uint32_t)h[4]<<24);
  bool ok=false;
  if(!gameFrameStart)gameFrameStart=millis();
  if(h[0]==1)ok=gameModeMsg(len);
  else if(h[0]==2)ok=gameRows(len);
  else if(h[0]==4){                                // SINK: read and drop (network speed test)
   static uint8_t junk[1460];ok=true;
   while(len && ok){uint32_t n=min((uint32_t)sizeof(junk),len);ok=gameRead(junk,n);len-=n;}
   if(ok){gameClient->write((uint8_t)'K');return;}
  }
  else if(h[0]==3 && len==0){
   gameEndWrite();
   if(lane==0){
    uint32_t now=millis();float fps=lastFrame?1000.0f/(now-lastFrame):0;
    frameFps=frameFps>0?frameFps*.8f+fps*.2f:fps;
    lastFrame=now;frameCount++;frameTransferMs=now-gameFrameStart;gameFrameStart=0;online=true;redrawScene=true;
    hudOn=gameHud;if(hudOn)graphicsHud();
   }
   gameClient->write((uint8_t)'K');
   return;
  }
  if(!ok){Serial.println("game stream: bad message, closing lane");gameClient->stop();gameMode=false;return;}
 }
}
void gameStream(){
 if(!gameFb){
  gameFb=(uint8_t*)heap_caps_malloc(GameMaxBytes,MALLOC_CAP_8BIT);
  for(auto& b:gameLine)b=(uint16_t*)heap_caps_malloc(320*8*2,MALLOC_CAP_DMA);
  if(!gameFb || !gameLine[0] || !gameLine[1]){Serial.println("game stream: no memory");return;}
 }
 WiFiClient n=gameServer.available();
 if(n){
  int slot=-1;for(int i=0;i<GameLanes;i++)if(!gameLane[i].connected()){slot=i;break;}
  if(slot<0)n.stop();
  else{gameLane[slot].stop();gameLane[slot]=n;gameLane[slot].setNoDelay(true);}
 }
 for(int i=0;i<GameLanes;i++)if(gameLane[i].connected())gameLaneStep(i);
}

// ---------------------------------------------------------------- game stream over UDP 8093
// Packet: u8 type, u8 layout generation, u16 picture number, then
//  1 MODE  the MODE payload above; answered 'M' + generation
//  2 ROWS  u8 packet index in this picture (0..63), then the ROWS payload above (whole rows, whole pairs at 1.5x)
//  3 END   u8 packets sent; answered 'K', generation, u16 picture, u64 bitmap of the ROWS packets that arrived
//  4 SINK  dropped (link speed test)
// A lost ROWS packet only leaves old rows on the screen: the sender sees it in the bitmap and sends them again.
static uint8_t gameGen=0;static uint16_t udpPic=0;static uint64_t udpGot=0;
static void udpReply(const uint8_t* d,size_t n){gameUdp.beginPacket(gameUdp.remoteIP(),gameUdp.remotePort());gameUdp.write(d,n);gameUdp.endPacket();}
void gameUdpStep(){
 if(!gameFb)return;
 static uint8_t pk[1500];static uint32_t lastPkt=0;
 if(gameWriting && millis()-lastPkt>100)gameEndWrite();   // END lost: let the rest of the firmware draw again
 for(int i=0;i<48;i++){
  int n=gameUdp.parsePacket();if(n<=0)break;
  int len=gameUdp.read(pk,sizeof(pk));udpBytes+=len;udpPackets++;lastPkt=millis();
  if(len<4)continue;
  uint8_t type=pk[0],gen=pk[1];uint16_t pic=pk[2]|(pk[3]<<8);
  if(type==1){
   gameMem=pk+4;gameMemLeft=len-4;bool ok=gameModeMsg(len-4);gameMem=nullptr;
   if(ok){gameGen=gen;udpPic=pic;udpGot=0;uint8_t r[2]={'M',gen};udpReply(r,2);}
  }else if(type==2 && len>=5){
   if(gen!=gameGen || !gameMode)continue;
   if(pic!=udpPic){udpPic=pic;udpGot=0;}
   if(!gameFrameStart)gameFrameStart=millis();
   gameMem=pk+5;gameMemLeft=len-5;bool ok=gameRows(len-5);gameMem=nullptr;
   if(ok)udpGot|=1ULL<<(pk[4]&63);
  }else if(type==3 && len>=5){
   if(pic!=udpPic){udpPic=pic;udpGot=0;}
   int sent=pk[4];for(int k=0;k<sent && k<64;k++)if(!(udpGot>>k&1))udpLost++;
   gameEndWrite();
   uint32_t now=millis();float fps=lastFrame?1000.0f/(now-lastFrame):0;
   frameFps=frameFps>0?frameFps*.8f+fps*.2f:fps;
   lastFrame=now;frameCount++;frameTransferMs=gameFrameStart?now-gameFrameStart:0;gameFrameStart=0;online=true;redrawScene=true;
   hudOn=gameHud;if(hudOn)graphicsHud();
   uint8_t r[12]={'K',gameGen,(uint8_t)pic,(uint8_t)(pic>>8)};memcpy(r+4,&udpGot,8);udpReply(r,12);
   return;                                          // one picture per loop pass
  }
 }
}
bool gameActive(){for(auto& c:gameLane)if(c.connected())return true;return false;}
void sendTouch(int x,int y){
 HTTPClient h;h.setConnectTimeout(300);h.setTimeout(300);h.begin(target+"/api/input");h.addHeader("Content-Type","application/json");
 JsonDocument d;d["type"]="touch";d["device"]=WiFi.macAddress();d["x"]=x;d["y"]=y;d["view"]=views[view];String data;serializeJson(d,data);h.POST(data);h.end();
}
String decodeForm(String value){
 String out;
 for(size_t i=0;i<value.length();i++){
  if(value[i]=='+')out+=' ';
  else if(value[i]=='%' && i+2<value.length()){char code[3]={value[i+1],value[i+2],0};out+=(char)strtoul(code,nullptr,16);i+=2;}
  else out+=value[i];
 }
 return out;
}
void controlRequest(){
 WiFiClient c=control.available();if(c.fd()<0)return;c.setTimeout(1); // WiFiClient takes seconds
 String request=c.readStringUntil('\n');int length=0;
 for(int n=0;n<30;n++){String header=c.readStringUntil('\n');header.trim();if(!header.length())break;header.toLowerCase();if(header.startsWith("content-length:"))length=header.substring(15).toInt();}
 String body,type="text/plain";int status=200;
 if(request.startsWith("GET /status ")){
  JsonDocument d;d["online"]=online;d["target"]=target;d["view"]=views[view];d["ip"]=WiFi.localIP().toString();d["heap"]=ESP.getFreeHeap();d["graphics_port"]=8091;d["game_port"]=8092;d["game_bytes"]=gameBytes;d["rssi"]=WiFi.RSSI();d["game_udp"]=8093;d["udp_bytes"]=udpBytes;d["udp_packets"]=udpPackets;d["udp_lost"]=udpLost;d["draw_ms"]=(uint32_t)(gameDrawUs/1000);d["dma_wait_ms"]=(uint32_t)(gameWaitUs/1000);d["channel"]=WiFi.channel();d["scale2"]=true;d["frames"]=frameCount;d["fps"]=frameFps;d["transfer_ms"]=frameTransferMs;if(!isnan(chipTemperature))d["temperature"]=chipTemperature;
  d["scene_polls"]=scenePolls;d["scene_tiles_drawn"]=sceneTilesDrawn;d["scene_draw_ms"]=sceneDrawMs;
  serializeJson(d,body);type="application/json";
 }else if(request.startsWith("POST /target ") && length>0 && length<300){
  char data[300];size_t count=c.readBytes(data,length);data[count]=0;String encoded=data;
  String url=decodeForm(encoded.substring(encoded.indexOf('=')+1));
  if(count==(size_t)length && url.startsWith("http://") && url.length()<120){target=url;Preferences p;p.begin("orphanremote");p.putString("target",target);p.end();lastPoll=0;redrawScene=true;body="Target saved";}
  else {status=400;body="Use http://host:8090";}
 }else if(request.startsWith("POST /view ") && length>0 && length<64){
  char data[64];size_t count=c.readBytes(data,length);data[count]=0;String name=data;name.trim();
  if(count==(size_t)length){for(int i=0;i<5;i++)if(name==views[i])view=i;lastFrame=0;lastPoll=0;redrawScene=true;body="View selected";}
  else{status=400;body="Incomplete body";}
 }else if(request.startsWith("GET /screen ")){       // screenshot: 320 x 240 RGB565, little endian, row by row
  gameEndWrite();
  c.setNoDelay(false);
  c.print("HTTP/1.1 200 OK\r\nContent-Type: application/octet-stream\r\nContent-Length: 153600\r\nConnection: close\r\n\r\n");
  // The panel can't be read back on this CYD, so the picture is rebuilt from the game picture in memory: exactly what
  // the game stream drew (black outside it). Old /rect pictures and the scene views are not kept, so they show black.
  static uint16_t line[320],t0[384],t2[384];
  for(int y=0;y<240;y++){
   memset(line,0,sizeof(line));
   if(gameMode && gameFb){
    int ow=gameScale?gameW*3/2:gameW,oh=gameScale?gameH*3/2:gameH,oy=y-gameY;
    if(oy>=0 && oy<oh){
     if(!gameScale){
      for(int c=0;c<gameW;c++)line[gameX+c]=gamePb==1?gamePal[gameFb[oy*gameW+c]]:((uint16_t*)gameFb)[oy*gameW+c];
     }else{
      int p=oy/3,k=oy%3;gameScaleRow(2*p,t0);gameScaleRow(2*p+1,t2);
      for(int c=0;c<ow;c++)line[gameX+c]=k==0?t0[c]:k==2?t2[c]:blend565(t0[c],t2[c]);
     }
    }
   }
   c.write((const uint8_t*)line,sizeof(line));
  }
  delay(2);c.stop();return;
 }else if(request.startsWith("GET / ")){
  type="text/html";body="<h1>ORPHAN Remote</h1><p>[orphan] · by <a href='https://jmscnc.com'>JMSCNC</a>, makers of RotatoCAM · <a href='https://buymeacoffee.com/revjmoney'>Buy me a coffee</a></p><p>[Rev. J. Money - 2026] · Orphan · FPGA Dev Linux for the S9 Control Board</p><form method='post' action='/target'>S9 URL <input name='url' placeholder='http://orphan.local:8090'><button>Save</button></form><p>Scene terminal, RGB565 rectangle receiver on TCP 8091 and game stream on TCP 8092.</p>";
 }else {status=404;body="Not found";}
 String response="HTTP/1.1 "+String(status)+(status==200?" OK\r\n":" Error\r\n")+"Content-Type: "+type+"\r\nContent-Length: "+String(body.length())+"\r\nConnection: close\r\n\r\n"+body;
 c.setNoDelay(true);c.print(response);delay(2);c.stop();
 Serial.printf("control: %s body=%d response=%d\n",request.c_str(),length,status);
}
void setup(){
 Serial.begin(115200);delay(200);boardInit(1,40000000);title("Connecting with saved WiFi...");
 tileSprite.setColorDepth(16);tileSprite.createSprite(TileWidth,TileHeight);
 Preferences p;p.begin("orphanremote",true);target=p.getString("target",target);p.end();
 bool connected=connectSaved();
 Serial.printf("Orphan Remote: WiFi %s; IP %s\n",connected?"connected":"not connected",WiFi.localIP().toString().c_str());
 if(connected)MDNS.begin("orphan-remote");
 control.begin();control.setNoDelay(true);graphics.begin();graphics.setNoDelay(true);gameServer.begin();gameServer.setNoDelay(true);gameUdp.begin(8093);scene();lastPoll=millis();
}
void loop(){
 controlRequest();frame();gameStream();
 gameUdpStep();
 int x,y;
 if(lastFrame && millis()-lastFrame<GraphicsHoldMs && millis()-lastTemperaturePoll>5000){temperaturePoll();if(hudOn)graphicsHud();}
 if(millis()-lastTouch>300 && boardTouch(x,y)){
  lastTouch=millis();sendTouch(x,y);
  if(y>=212){view=(view+(x<100?4:1))%5;lastFrame=0;lastPoll=0;redrawScene=true;}
 }
 if((!lastPoll || millis()-lastPoll>(online?SceneIntervalMs:1500)) && (!lastFrame || millis()-lastFrame>GraphicsHoldMs)){scene();lastPoll=millis();}
 if(!gameActive() && !(lastFrame && millis()-lastFrame<200))delay(2);
}
