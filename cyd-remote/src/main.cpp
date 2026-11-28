// SPDX-License-Identifier: GPL-3.0-or-later
// Copyright (C) 2026 Rev. J. Money
// Orphan Remote: generic Linux scene terminal + RGB565 rectangle transport + game stream (TCP 8092).
#include <Arduino.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <esp_task_wdt.h>
#include <Preferences.h>
#include <ArduinoJson.h>
#include <ESPmDNS.h>
#include <WiFiUdp.h>
#include "board.h"

WiFiServer control(80);
WiFiServer graphics(8091);
WiFiServer gameServer(8092);
#include "lwip/sockets.h"
int udpSock=-1,udpTxSock=-1;   // replies go out on their own socket: the receive task sits in recvfrom on udpSock
uint32_t udpBytes=0,udpPackets=0,udpLost=0,udpDropped=0;   // game stream over UDP 8093 (TCP on this ESP32 tops out ~480 KB/s)
constexpr int GameLanes=4;              // parallel connections: each has its own small lwIP receive window
WiFiClient gameLane[GameLanes];
WiFiClient* gameClient=&gameLane[0];   // the lane being read
String target="http://orphan.local:8090";
extern uint32_t selIp,selSeen;                       // the picked board (see "several boards" below)
// The views always ask an IP: a name like orphan.local looked up on the loop blocked it for seconds while the
// board finder asked mDNS too (the loop watchdog restarted the CYD). The finder turns a saved name into its IP.
static bool targetHost(String& host){int a=target.indexOf("://");a=a<0?0:a+3;int b=target.indexOf(':',a);int c=target.indexOf('/',a);
 int e=b>=0?b:(c>=0?c:target.length());host=target.substring(a,e);IPAddress ip;return ip.fromString(host);}
static bool targetIsIp(){String h;return targetHost(h);}
volatile uint32_t resolvedTargetIp=0;                // set by the finder, applied by the loop
const char* views[]={"system","mining","projects","radio","synth"};
int view=0;
uint32_t lastPoll=0,lastTouch=0,lastFrame=0;
uint32_t acceptAt[3]={0,0,0},loopCount=0,heartbeatAt=0;   // last connection taken on 80 / 8091 / 8092; serial heartbeat
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
 if(WiFi.status()!=WL_CONNECTED || !targetIsIp())return;
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
 if(!targetIsIp()){sceneError("Looking for the Orphan board...");return;}
 HTTPClient h;h.setConnectTimeout(online?400:250);h.setTimeout(550);
 h.begin(target+"/api/display?tiles=1&view="+views[view]);int status=h.GET();
 if(status!=200){h.end();sceneError("Waiting for S9 display service...");return;}
 if(selIp)selSeen=millis();                          // the views ask the picked board: it is alive
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
uint32_t rectDeadline=0;     // a whole /rect picture must arrive in 2.5 s: a sender trickling bytes held the loop 10 s+
bool readFull(WiFiClient& c,void* dst,size_t n,uint32_t timeoutMs=1000){
 uint8_t* p=(uint8_t*)dst;uint32_t last=millis();
 while(n){
  if(rectDeadline && (int32_t)(millis()-rectDeadline)>0)return false;
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
bool otherBoard(WiFiClient& c);
void frame(){
 WiFiClient c=graphics.available();if(c.fd()<0)return;c.setTimeout(1); // WiFiClient takes seconds
 if(otherBoard(c)){c.print("HTTP/1.1 503 Busy\r\nContent-Length: 0\r\nConnection: close\r\n\r\n");c.stop();return;}
 acceptAt[1]=millis();
 uint32_t begin=millis();
 String line=c.readStringUntil('\n');int x=queryInt(line,"x",0),y=queryInt(line,"y",0),w=queryInt(line,"w",320),h=queryInt(line,"h",240),scale=queryInt(line,"scale",1);
 size_t length=0;
 while(c.fd()>=0 && millis()-begin<1500){String header=c.readStringUntil('\n');header.trim();if(!header.length())break;header.toLowerCase();if(header.startsWith("content-length:"))length=header.substring(15).toInt();}
 if(!line.startsWith("POST /rect") || (scale!=1 && scale!=2) || x<0 || x>=320 || y<0 || y>=240 || w<1 || h<1 || w>(320-x)/scale || h>(240-y)/scale || length!=(size_t)w*h*2){c.print("HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\nConnection: close\r\n\r\n");c.stop();return;}
 rectDeadline=begin+2500;
 bool ok=scale==2?drawDoubled(c,x,y,w,h,queryInt(line,"smooth",0)):drawNative(c,x,y,w,h);
 rectDeadline=0;
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
//  1 MODE  u8 pixel bytes (1 = palette index, 2 = RGB565), u8 scale (0 = 1x, 1 = 1.5x blended, 2 = 2x wide 1x tall:
//          the Atari 2600's 160 x 240 fills the screen), u8 flags (bit 0 hud),
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
// 2x wide, 1x tall (scale 2): each source pixel becomes two (the 2600's pixels are about twice as wide as tall)
static void gameDraw2w(int r0,int r1){
 int ow=gameW*2;
 for(int r=r0;r<r1;r+=8){
  int n=min(8,r1-r);uint16_t* b=gameStrip();
  for(int k=0;k<n;k++){
   uint16_t* o=b+k*ow;
   if(gamePb==1){const uint8_t* src=gameFb+(r+k)*gameW;for(int c=0;c<gameW;c++){uint16_t v=gamePalSw[src[c]];*o++=v;*o++=v;}}
   else{const uint16_t* src=(const uint16_t*)gameFb+(r+k)*gameW;for(int c=0;c<gameW;c++){uint16_t v=sw16(src[c]);*o++=v;*o++=v;}}
  }
  gamePush(gameX,gameY+r,ow,n,b);
 }
}
static const uint8_t* gameMem=nullptr;static size_t gameMemLeft=0;   // set while a UDP packet is being parsed
static bool gameRead(void* d,size_t n){
 if(gameMem){if(n>gameMemLeft)return false;memcpy(d,gameMem,n);gameMem+=n;gameMemLeft-=n;gameBytes+=n;return true;}
 bool ok=readFull(*gameClient,d,n,1500);if(ok)gameBytes+=n;return ok;
}
static bool gameRows(uint32_t len){
 uint16_t hdr[2];if(len<4 || !gameRead(hdr,4))return false;len-=4;
 int r0=hdr[0],n=hdr[1];if(!gameMode || n<1 || r0+n>gameH || (gameScale==1 && ((r0|n)&1)))return false;
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
 if(gameScale==1)gameDraw15(r0,r0+n);else if(gameScale==2)gameDraw2w(r0,r0+n);else gameDraw1x(r0,r0+n);
 gameDrawUs+=micros()-t0;
 return true;
}
static bool gameModeMsg(uint32_t len){
 uint8_t h[14];if(len<14 || !gameRead(h,14))return false;
 int pb=h[0],sc=h[1],npal=h[12]|(h[13]<<8);
 int w=h[4]|(h[5]<<8),hh=h[6]|(h[7]<<8),x=h[8]|(h[9]<<8),y=h[10]|(h[11]<<8);
 int ow=sc==1?w*3/2:sc==2?w*2:w,oh=sc==1?hh*3/2:hh;
 if((pb!=1 && pb!=2) || sc>2 || w<2 || w>256 || hh<2 || w*hh*pb>GameMaxBytes || (sc==1 && ((w|hh)&1)) || x+ow>320 || y+oh>240
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
// The game picture (60 KB in one piece) and the two DMA strips are taken once, at boot before WiFi breaks the heap
// into pieces. (They used to be asked for in every loop pass: once the heap was in pieces the 60 KB never came, and
// each try kept the two strips it did get: the heap ran out and TCP stopped answering, the "ping but no HTTP" fault.)
bool gameAlloc(){
 static uint32_t triedAt=0;static bool told=false;
 if(gameFb && gameLine[0] && gameLine[1])return true;
 if(triedAt && millis()-triedAt<10000)return false;                    // after a failure: try again in 10 s
 triedAt=millis();
 if(!gameFb)gameFb=(uint8_t*)heap_caps_malloc(GameMaxBytes,MALLOC_CAP_8BIT);
 for(auto& b:gameLine)if(!b)b=(uint16_t*)heap_caps_malloc(320*8*2,MALLOC_CAP_DMA);
 if(gameFb && gameLine[0] && gameLine[1])return true;
 if(gameFb){heap_caps_free(gameFb);gameFb=nullptr;}                      // nothing kept from a failed try
 for(auto& b:gameLine)if(b){heap_caps_free(b);b=nullptr;}
 if(!told){Serial.printf("game stream: no memory (largest free block %u)\n",(unsigned)heap_caps_get_largest_free_block(MALLOC_CAP_8BIT));told=true;}
 return false;
}
void gameStream(){
 if(!gameAlloc())return;
 WiFiClient n=gameServer.available();
 if(n){
  acceptAt[2]=millis();
  int slot=-1;for(int i=0;i<GameLanes;i++)if(!gameLane[i].connected()){slot=i;break;}
  if(slot<0 || otherBoard(n))n.stop();
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
// UDP 8093 is read by its own task on core 0 (next to the WiFi stack) into a ring of packets, so packets keep being
// taken off the network while core 1 is busy drawing (lwIP only queues a few, the rest were dropped).
constexpr int UdpSlots=24,UdpSlotBytes=1472;
uint8_t* udpRing=nullptr;uint16_t udpLen[UdpSlots];volatile uint32_t udpHead=0,udpTail=0;
struct sockaddr_in udpFrom,udpFromRing[UdpSlots];volatile bool udpFromSet=false;   // reply to who sent that packet
// A video (priority 1 in MODE) holds the screen: a game's MODE (priority 0) is answered 'B' (busy) while the video
// has sent anything in the last 2 s, so the games wait instead of taking turns with it.
uint8_t ownerPri=0;uint32_t ownerSeen=0;struct sockaddr_in owner={};   // the sender that has the screen
static bool fromOwner(){return udpFrom.sin_addr.s_addr==owner.sin_addr.s_addr && udpFrom.sin_port==owner.sin_port;}
static void udpTask(void*){
 for(;;){
  // always take packets out of lwIP (its buffers are shared with TCP: left full, /status and /screen stall);
  // when the ring is full (core 1 busy elsewhere) the packet is dropped and the board resends what is missing
  static uint8_t spill[UdpSlotBytes];
  bool full=udpHead-udpTail>=UdpSlots;
  struct sockaddr_in from;socklen_t fl=sizeof(from);
  int n=recvfrom(udpSock,full?spill:udpRing+(udpHead%UdpSlots)*UdpSlotBytes,UdpSlotBytes,0,(struct sockaddr*)&from,&fl);
  if(n<=0){vTaskDelay(1);continue;}
  if(full){udpDropped++;continue;}
  udpFromRing[udpHead%UdpSlots]=from;udpFromSet=true;udpLen[udpHead%UdpSlots]=n;__sync_synchronize();udpHead=udpHead+1;
 }
}
void udpStart(){
 udpRing=(uint8_t*)heap_caps_malloc(UdpSlots*UdpSlotBytes,MALLOC_CAP_8BIT);
 udpSock=socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);udpTxSock=socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);
 struct sockaddr_in a={};a.sin_family=AF_INET;a.sin_port=htons(8093);a.sin_addr.s_addr=htonl(INADDR_ANY);
 if(!udpRing || udpSock<0 || bind(udpSock,(struct sockaddr*)&a,sizeof(a))<0){Serial.println("game udp: start failed");return;}
 xTaskCreatePinnedToCore(udpTask,"udp8093",3072,nullptr,5,nullptr,1);  // core 1: on core 0 it slowed the WiFi driver (more packets lost)
}
static void udpReply(const uint8_t* d,size_t n){if(udpFromSet)sendto(udpTxSock,d,n,0,(struct sockaddr*)&udpFrom,sizeof(udpFrom));}
void sendTouch(int x,int y);
// ---------------------------------------------------------------- several boards: double tap to switch
// The CYD keeps a list of the Orphan boards it has seen: names orphan.local, orphan-2.local .. orphan-9.local found
// by mDNS (a task on core 0 asks for one name every 1.5 s), plus every board that sends a game. A DOUBLE TAP anywhere
// above the bottom bar picks the next board (POST /select "next" or an IP does the same; GET /boards lists them).
// The picked board is the one the views ask (target = http://<ip>:8090) and the only one whose game gets the
// screen: another board's game is answered 'B' (busy) and its sender waits and asks again each second, so it shows
// as soon as it is picked. If the picked board has not been heard for 10 s, any board's game may show (as before).
// A video (priority 1, from a PC) still takes the screen from any board.
struct OrphanBoard{uint32_t ip;char name[20];uint32_t seen;};
constexpr int MaxBoards=8;
OrphanBoard boards[MaxBoards];int nBoards=0;
uint32_t selIp=0,selSeen=0;                 // the picked board (network byte order), last heard
uint32_t busySent=0,modesTaken=0;            // MODEs answered 'B' because another board is picked / MODEs taken
portMUX_TYPE boardsMux=portMUX_INITIALIZER_UNLOCKED;
String toastText;uint32_t toastUntil=0;bool toastShown=false,forceFullPicture=false;
volatile bool boardsDirty=false;             // the list changed: saved to flash by the boards task (not under the lock)
static void boardSeen(uint32_t ip,const char* name){
 if(!ip || ip==(uint32_t)WiFi.localIP())return;
 portENTER_CRITICAL(&boardsMux);
 int i=0;while(i<nBoards && boards[i].ip!=ip)i++;
 if(i==nBoards && nBoards<MaxBoards){boards[i].ip=ip;boards[i].name[0]=0;nBoards++;boardsDirty=true;}
 if(i<nBoards){if(name && *name && strcmp(boards[i].name,name)){strlcpy(boards[i].name,name,sizeof(boards[i].name));boardsDirty=true;}
  boards[i].seen=millis();}
 if(ip==selIp)selSeen=millis();
 portEXIT_CRITICAL(&boardsMux);
}
// every board ever seen is kept in flash, so a restart knows them all before mDNS (which can miss a board) answers
static void saveBoards(){
 OrphanBoard copy[MaxBoards];int n;
 portENTER_CRITICAL(&boardsMux);n=nBoards;memcpy(copy,boards,sizeof(copy));boardsDirty=false;portEXIT_CRITICAL(&boardsMux);
 for(int i=0;i<n;i++)copy[i].seen=0;
 Preferences p;p.begin("orphanremote");p.putBytes("boards",copy,n*sizeof(OrphanBoard));p.end();
}
static void loadBoards(){
 OrphanBoard copy[MaxBoards];Preferences p;p.begin("orphanremote",true);
 size_t len=p.getBytesLength("boards");if(len>sizeof(copy))len=0;if(len)p.getBytes("boards",copy,len);p.end();
 for(size_t i=0;i<len/sizeof(OrphanBoard);i++){copy[i].name[sizeof(copy[i].name)-1]=0;boardSeen(copy[i].ip,copy[i].name);}
 boardsDirty=false;
}
static bool selAlive(){return selIp && millis()-selSeen<10000;}
bool otherBoard(WiFiClient& c){return selAlive() && (uint32_t)c.remoteIP()!=selIp;}   // a picked board is alive, c is not it
// One mDNS sweep at boot and one each time a double tap finds fewer than two boards: never a steady stream of
// queries (with the game picture in memory the heap is tight; an mDNS packet that could not be allocated crashed
// the CYD, and the network stopped answering after it).
TaskHandle_t discoverHandle=nullptr;
volatile bool discovering=false;
static void discoverTask(void*){
 static const char* names[]={"orphan","orphan-1","orphan-2","orphan-3","orphan-4","orphan-5","orphan-6","orphan-7","orphan-8","orphan-9"};
 for(;;){
  discovering=true;
  String host;
  if(WiFi.status()==WL_CONNECTED && !targetHost(host)){                    // a saved name: find its IP first
   if(host.endsWith(".local"))host=host.substring(0,host.length()-6);
   IPAddress a=MDNS.queryHost(host,1500);if((uint32_t)a){boardSeen((uint32_t)a,host.c_str());resolvedTargetIp=(uint32_t)a;}
  }
  for(int k=0;k<10;k++){
   if(WiFi.status()!=WL_CONNECTED || heap_caps_get_largest_free_block(MALLOC_CAP_8BIT)<8192)break;   // never when memory is short
   IPAddress a=MDNS.queryHost(names[k],600);if((uint32_t)a)boardSeen((uint32_t)a,names[k]);
   vTaskDelay(pdMS_TO_TICKS(200));
  }
  discovering=false;
  // until the next sweep request: every 3 s see whether the picked board's display service answers (a plain TCP
  // connect, here on core 0: the picked board counts as alive whatever the screen shows)
  while(!ulTaskNotifyTake(pdTRUE,pdMS_TO_TICKS(3000))){
   if(boardsDirty)saveBoards();
   uint32_t ip=selIp;if(!ip || WiFi.status()!=WL_CONNECTED)continue;
   int fd=socket(AF_INET,SOCK_STREAM,0);if(fd<0)continue;
   struct timeval tv={0,600000};setsockopt(fd,SOL_SOCKET,SO_SNDTIMEO,&tv,sizeof(tv));
   struct sockaddr_in a={};a.sin_family=AF_INET;a.sin_port=htons(8090);a.sin_addr.s_addr=ip;
   if(connect(fd,(struct sockaddr*)&a,sizeof(a))==0 && ip==selIp)selSeen=millis();
   close(fd);
  }
 }
}
static void showToast(const String& t){toastText=t;toastUntil=millis()+2500;toastShown=false;}
static void drawToast(){
 if(!toastUntil)return;
 if(millis()>toastUntil){toastUntil=0;redrawScene=true;forceFullPicture=true;return;}   // the next picture paints over it
 if(toastShown || gameWriting)return;
 tft.fillRect(0,0,320,22,0x0000);tft.drawFastHLine(0,21,320,0xfdaa);
 tft.setTextColor(0xfdaa);tft.setTextSize(1);tft.setCursor(6,7);tft.print(toastText);toastShown=true;
}
void selectBoard(uint32_t ip){
 if(gameWriting)gameEndWrite();
 selIp=ip;selSeen=millis();
 IPAddress a(ip);target="http://"+a.toString()+":8090";
 {Preferences p;p.begin("orphanremote");p.putString("target",target);p.putUInt("sel",ip);p.end();}
 owner={};ownerPri=0;ownerSeen=0;gameMode=false;        // the old board's picture stops here; the picked one takes over
 lastFrame=0;lastPoll=0;redrawScene=true;online=false;
 char name[20]="";int idx=0,n=0;
 portENTER_CRITICAL(&boardsMux);
 n=nBoards;for(int i=0;i<nBoards;i++){if(ntohl(boards[i].ip)<ntohl(ip))idx++;if(boards[i].ip==ip)strlcpy(name,boards[i].name,sizeof(name));}
 portEXIT_CRITICAL(&boardsMux);
 showToast("BOARD "+String(idx+1)+" OF "+String(n)+"   "+(name[0]?String(name)+"   ":String(""))+a.toString());
 Serial.printf("board picked: %s %s\n",name,a.toString().c_str());
}
void nextBoard(){
 if(nBoards<2 && discoverHandle && !discovering)xTaskNotifyGive(discoverHandle);   // look for more boards too
 uint32_t best=0,first=0,cur=selIp?ntohl(selIp):0;
 portENTER_CRITICAL(&boardsMux);
 for(int i=0;i<nBoards;i++){uint32_t h=ntohl(boards[i].ip);
  if(!first || h<ntohl(first))first=boards[i].ip;
  if(h>cur && (!best || h<ntohl(best)))best=boards[i].ip;}
 portEXIT_CRITICAL(&boardsMux);
 if(!best)best=first;
 if(!best){showToast("NO ORPHAN BOARDS FOUND YET, LOOKING...");if(discoverHandle && !discovering)xTaskNotifyGive(discoverHandle);return;}
 if(best==selIp){showToast("ONLY THIS BOARD FOUND, LOOKING FOR MORE...");if(discoverHandle && !discovering)xTaskNotifyGive(discoverHandle);return;}
 selectBoard(best);
}
String boardsJson(){
 JsonDocument d;d["selected"]=selIp?IPAddress(selIp).toString():"";d["selected_alive"]=selAlive();
 JsonArray a=d["boards"].to<JsonArray>();
 portENTER_CRITICAL(&boardsMux);OrphanBoard copy[MaxBoards];int n=nBoards;memcpy(copy,boards,sizeof(copy));portEXIT_CRITICAL(&boardsMux);
 for(int i=0;i<n;i++){JsonObject o=a.add<JsonObject>();o["ip"]=IPAddress(copy[i].ip).toString();o["name"]=copy[i].name;o["age_s"]=(millis()-copy[i].seen)/1000;}
 String s;serializeJson(d,s);return s;
}
// touch: a tap is a press shorter than 600 ms; two taps less than 700 ms apart (above the bottom bar) = next board.
// (A tap also still goes to the board as a touch event, and the bottom bar still changes views, as before.)
void touchStep(){
 static bool wasDown=false;static uint32_t downAt=0,upAt=0,pollAt=0,lastTapUp=0;static int px=0,py=0,upCount=0;
 if(millis()-pollAt<15)return;
 pollAt=millis();
 int x,y;bool down=boardTouch(x,y);
 if(down){
  upCount=0;
  if(!wasDown){downAt=millis();px=x;py=y;}
  if(millis()-lastTouch>300){
   lastTouch=millis();sendTouch(x,y);
   if(y>=212){view=(view+(x<100?4:1))%5;lastFrame=0;lastPoll=0;redrawScene=true;}
  }
  wasDown=true;return;
 }
 if(!wasDown)return;
 if(++upCount<2)return;                                 // two quiet polls in a row = really let go
 wasDown=false;upAt=millis();
 if(py>=212 || upAt-downAt>600){lastTapUp=0;return;}
 if(lastTapUp && downAt-lastTapUp<700){lastTapUp=0;nextBoard();}
 else lastTapUp=upAt;
}
void gameUdpStep(){
 if(!gameFb)return;
 static uint32_t lastPkt=0;if(!udpRing)return;
 if(gameWriting && millis()-lastPkt>100)gameEndWrite();   // END lost: let the rest of the firmware draw again
 for(int i=0;i<48;i++){
  if(udpTail==udpHead)break;
  uint8_t* pk=udpRing+(udpTail%UdpSlots)*UdpSlotBytes;int len=udpLen[udpTail%UdpSlots];
  udpFrom=udpFromRing[udpTail%UdpSlots];
  if(selIp && udpFrom.sin_addr.s_addr==selIp)selSeen=millis();
  struct Done{~Done(){__sync_synchronize();udpTail=udpTail+1;}} done;   // the slot is free again after this pass
  udpBytes+=len;udpPackets++;lastPkt=millis();
  if(len<4)continue;
  uint8_t type=pk[0],gen=pk[1];uint16_t pic=pk[2]|(pk[3]<<8);
  if(type==1){
   uint8_t pri=len>7?pk[7]:0;
   if(pri==0)boardSeen(udpFrom.sin_addr.s_addr,nullptr);
   // a game from a board that is not the picked one waits (its sender asks again every second)
   if(pri==0 && selAlive() && udpFrom.sin_addr.s_addr!=selIp){busySent++;uint8_t r[2]={'B',gen};udpReply(r,2);continue;}
   if(pri<ownerPri && millis()-ownerSeen<2000){uint8_t r[2]={'B',gen};udpReply(r,2);continue;}
   gameMem=pk+4;gameMemLeft=len-4;bool ok=gameModeMsg(len-4);gameMem=nullptr;
   if(ok){modesTaken++;gameGen=gen;udpPic=pic;udpGot=0;ownerPri=pri;ownerSeen=millis();owner=udpFrom;uint8_t r[2]={'M',gen};udpReply(r,2);}
  }else if(type==2 && len>=5){
   if(gen!=gameGen || !gameMode || !fromOwner())continue;
   ownerSeen=millis();
   if(pic!=udpPic){udpPic=pic;udpGot=0;}
   if(!gameFrameStart)gameFrameStart=millis();
   gameMem=pk+5;gameMemLeft=len-5;bool ok=gameRows(len-5);gameMem=nullptr;
   if(ok)udpGot|=1ULL<<(pk[4]&63);
  }else if(type==3 && len>=5){
   if(gen!=gameGen || !fromOwner())continue;        // an END from a sender that no longer has the screen
   ownerSeen=millis();
   // the last few pictures' answers: an END sent again (the board does when an answer is late) gets the same
   // answer and changes nothing else (the board may already be sending the next picture)
   static uint16_t endPic[4]={0xFFFF,0xFFFF,0xFFFF,0xFFFF};static uint8_t endGen[4];static uint64_t endGot[4];static int endN=0;
   bool again=false;
   for(int k=0;k<4;k++)if(endPic[k]==pic && endGen[k]==gen){uint8_t r[12]={'K',gameGen,(uint8_t)pic,(uint8_t)(pic>>8)};memcpy(r+4,&endGot[k],8);udpReply(r,12);again=true;break;}
   if(again)continue;
   if(pic!=udpPic){udpPic=pic;udpGot=0;}
   endPic[endN]=pic;endGen[endN]=gen;endGot[endN]=udpGot;endN=(endN+1)&3;
   int sent=pk[4];for(int k=0;k<sent && k<64;k++)if(!(udpGot>>k&1))udpLost++;
   gameEndWrite();
   uint32_t now=millis();float fps=lastFrame?1000.0f/(now-lastFrame):0;
   frameFps=frameFps>0?frameFps*.8f+fps*.2f:fps;
   lastFrame=now;frameCount++;frameTransferMs=gameFrameStart?now-gameFrameStart:0;gameFrameStart=0;online=true;redrawScene=true;
   hudOn=gameHud;if(hudOn)graphicsHud();
   if(forceFullPicture){udpGot=0;forceFullPicture=false;}   // (after a message box: "nothing arrived" = every row again)
   uint8_t r[12]={'K',gameGen,(uint8_t)pic,(uint8_t)(pic>>8)};memcpy(r+4,&udpGot,8);udpReply(r,12);
   return;                                          // one picture per loop pass
  }
 }
}
bool gameActive(){for(auto& c:gameLane)if(c.connected())return true;return false;}
void sendTouch(int x,int y){
 if(!targetIsIp())return;
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
uint8_t spiMhz=40;                      // panel SPI clock: 40 (safe) or 80 MHz, POST /spi to change (restarts)
void controlRequest(){
 WiFiClient c=control.available();if(c.fd()<0)return;c.setTimeout(1); // WiFiClient takes seconds
 // a connection that brings nothing within 150 ms is dropped: its sender gave up while the loop was busy, and waiting
 // a whole second on each of those kept the loop busy enough that the next ones gave up too
 {uint32_t t=millis();while(c.available()<=0 && c.connected() && millis()-t<150)delay(1);if(c.available()<=0){c.stop();return;}}
 acceptAt[0]=millis();
 String request=c.readStringUntil('\n');int length=0;
 for(int n=0;n<30;n++){String header=c.readStringUntil('\n');header.trim();if(!header.length())break;header.toLowerCase();if(header.startsWith("content-length:"))length=header.substring(15).toInt();}
 String body,type="text/plain";int status=200;
 if(request.startsWith("GET /status ")){
  JsonDocument d;d["online"]=online;d["target"]=target;d["view"]=views[view];d["ip"]=WiFi.localIP().toString();d["heap"]=ESP.getFreeHeap();d["graphics_port"]=8091;d["game_port"]=8092;d["game_bytes"]=gameBytes;d["rssi"]=WiFi.RSSI();d["game_udp"]=8093;d["udp_bytes"]=udpBytes;d["udp_packets"]=udpPackets;d["udp_lost"]=udpLost;d["udp_dropped"]=udpDropped;d["draw_ms"]=(uint32_t)(gameDrawUs/1000);d["dma_wait_ms"]=(uint32_t)(gameWaitUs/1000);d["channel"]=WiFi.channel();d["scale2"]=true;d["wide2"]=true;d["spi_mhz"]=spiMhz;d["frames"]=frameCount;d["fps"]=frameFps;d["transfer_ms"]=frameTransferMs;if(!isnan(chipTemperature))d["temperature"]=chipTemperature;
  d["selected"]=selIp?IPAddress(selIp).toString():"";d["boards"]=nBoards;d["busy_sent"]=busySent;d["modes_taken"]=modesTaken;
  d["selected_age_ms"]=selIp?millis()-selSeen:0;d["owner"]=IPAddress(owner.sin_addr.s_addr).toString();
  d["scene_polls"]=scenePolls;d["scene_tiles_drawn"]=sceneTilesDrawn;d["scene_draw_ms"]=sceneDrawMs;
  serializeJson(d,body);type="application/json";
 }else if(request.startsWith("POST /target ") && length>0 && length<300){
  char data[300];size_t count=c.readBytes(data,length);data[count]=0;String encoded=data;
  String url=decodeForm(encoded.substring(encoded.indexOf('=')+1));
  if(count==(size_t)length && url.startsWith("http://") && url.length()<120){target=url;Preferences p;p.begin("orphanremote");p.putString("target",target);p.end();lastPoll=0;redrawScene=true;body="Target saved";}
  else {status=400;body="Use http://host:8090";}
 }else if(request.startsWith("GET /hello")){            // a board announces itself: GET /hello?name=orphan-2
  char name[20]="";int q=request.indexOf("name=");
  if(q>0){int k=0;for(int i=q+5;i<(int)request.length() && k<19;i++){char ch=request[i];
   if(isalnum((unsigned char)ch)||ch=='-'||ch=='_')name[k++]=ch;else break;}name[k]=0;}
  boardSeen((uint32_t)c.remoteIP(),name);body="{\"ok\":true}";type="application/json";
 }else if(request.startsWith("GET /boards ")){
  body=boardsJson();type="application/json";
 }else if(request.startsWith("POST /select ") && length>0 && length<40){   // body "next" or a board's IP
  char data[40];size_t count=c.readBytes(data,length);data[count]=0;String v=data;v.trim();IPAddress a;
  if(v.startsWith("next")){nextBoard();body=boardsJson();type="application/json";}
  else if(a.fromString(v)){boardSeen((uint32_t)a,nullptr);selectBoard((uint32_t)a);body=boardsJson();type="application/json";}
  else{status=400;body="Use next or an IP";}
 }else if(request.startsWith("POST /view ") && length>0 && length<64){
  char data[64];size_t count=c.readBytes(data,length);data[count]=0;String name=data;name.trim();
  if(count==(size_t)length){for(int i=0;i<5;i++)if(name==views[i])view=i;lastFrame=0;lastPoll=0;redrawScene=true;body="View selected";}
  else{status=400;body="Incomplete body";}
 }else if(request.startsWith("POST /spi ") && length>0 && length<16){   // body "40" or "80": saved, then restart
  char data[16];size_t count=c.readBytes(data,length);data[count]=0;int mhz=atoi(data);
  if(mhz==40||mhz==80){Preferences q;q.begin("orphanremote");q.putUChar("spi",(uint8_t)mhz);q.end();
   c.print("HTTP/1.1 200 OK\r\nContent-Length: 10\r\nConnection: close\r\n\r\nrestarting");delay(50);c.stop();delay(200);ESP.restart();}
  status=400;body="Use 40 or 80";
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
    int ow=gameScale==1?gameW*3/2:gameScale==2?gameW*2:gameW,oh=gameScale==1?gameH*3/2:gameH,oy=y-gameY;
    if(oy>=0 && oy<oh){
     if(gameScale!=1){
      int k=gameScale==2?2:1;
      for(int c=0;c<ow;c++)line[gameX+c]=gamePb==1?gamePal[gameFb[oy*gameW+c/k]]:((uint16_t*)gameFb)[oy*gameW+c/k];
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
  type="text/html";body="<h1>ORPHAN Remote</h1><p>[orphan] · by <a href='https://jmscnc.com'>JMSCNC</a>, makers of RotatoCAM · <a href='https://buymeacoffee.com/revjmoney'>Buy me a coffee</a></p><p>[Rev. J. Money - 2026] · Orphan · FPGA Dev Linux for the S9 Control Board</p><form method='post' action='/target'>S9 URL <input name='url' placeholder='http://orphan.local:8090'><button>Save</button></form><p>Scene terminal, RGB565 rectangle receiver on TCP 8091 and game stream on TCP 8092.</p><p>Several boards: double tap the screen (above the bottom bar) to switch. <a href='/boards'>Boards seen</a></p><form method='post' action='/select' enctype='text/plain'><button name='next' value=''>Next board</button></form>";
 }else {status=404;body="Not found";}
 String response="HTTP/1.1 "+String(status)+(status==200?" OK\r\n":" Error\r\n")+"Content-Type: "+type+"\r\nContent-Length: "+String(body.length())+"\r\nConnection: close\r\n\r\n"+body;
 c.setNoDelay(true);c.print(response);delay(2);c.stop();
 Serial.printf("control: %s body=%d response=%d\n",request.c_str(),length,status);
}
void setup(){
 {Preferences q;q.begin("orphanremote",true);spiMhz=q.getUChar("spi",40);q.end();if(spiMhz!=80)spiMhz=40;}
 Serial.begin(115200);delay(200);gameAlloc();boardInit(1,spiMhz*1000000u);title("Connecting with saved WiFi...");
 // (no 40 KB tile sprite: the views draw straight to the panel. With the 60 KB game picture in memory, game
 // traffic bursts emptied the heap and mDNS crashed the CYD when it could not get memory for a packet.)
 Preferences p;p.begin("orphanremote",true);target=p.getString("target",target);selIp=p.getUInt("sel",0);p.end();
 loadBoards();
 if(selIp)boardSeen(selIp,nullptr);
 bool connected=connectSaved();
 Serial.printf("Orphan Remote: WiFi %s; IP %s\n",connected?"connected":"not connected",WiFi.localIP().toString().c_str());
 if(connected){MDNS.begin("orphan-remote");xTaskCreatePinnedToCore(discoverTask,"boards",4096,nullptr,1,&discoverHandle,0);}
 control.begin();control.setNoDelay(true);graphics.begin();graphics.setNoDelay(true);gameServer.begin();gameServer.setNoDelay(true);udpStart();scene();lastPoll=millis();
 // a loop that stops for 20 s restarts the CYD (it once kept answering ping but no TCP); the reason prints at boot
 esp_task_wdt_init(20,true);enableLoopWDT();
 Serial.printf("boot: reset reason %d (1 power on, 3 software, 4 panic, 5 interrupt wdt, 6 task wdt)\n",(int)esp_reset_reason());
}
// every 5 s on the USB serial line: if the CYD ever stops answering TCP again, this shows whether the loop still ran
void heartbeat(){
 uint32_t now=millis();loopCount++;
 if(now-heartbeatAt<5000)return;
 auto age=[&](uint32_t t){return t?(long)((now-t)/1000):-1L;};
 Serial.printf("HB up=%lus heap=%u min=%u loops=%lu frames=%lu age80=%lds age8091=%lds age8092=%lds udp=%lu wifi=%d rssi=%d\n",
  (unsigned long)(now/1000),(unsigned)ESP.getFreeHeap(),(unsigned)ESP.getMinFreeHeap(),(unsigned long)loopCount,(unsigned long)frameCount,
  age(acceptAt[0]),age(acceptAt[1]),age(acceptAt[2]),(unsigned long)udpPackets,(int)WiFi.status(),(int)WiFi.RSSI());
 heartbeatAt=now;loopCount=0;
}
void loop(){
 heartbeat();
 if(resolvedTargetIp){                                  // the finder found the saved name's IP: ask that from now on
  String host;targetHost(host);int a=target.indexOf(host);
  target=target.substring(0,a)+IPAddress(resolvedTargetIp).toString()+target.substring(a+host.length());
  resolvedTargetIp=0;lastPoll=0;redrawScene=true;Serial.printf("target: %s\n",target.c_str());
 }
 controlRequest();frame();gameStream();
 gameUdpStep();
 int x,y;
 if(lastFrame && millis()-lastFrame<GraphicsHoldMs && millis()-lastTemperaturePoll>5000){temperaturePoll();if(hudOn)graphicsHud();}
 touchStep();drawToast();
 if((!lastPoll || millis()-lastPoll>(online?SceneIntervalMs:5000)) && (!lastFrame || millis()-lastFrame>GraphicsHoldMs)){scene();lastPoll=millis();}
 if(!gameActive() && !(lastFrame && millis()-lastFrame<200))delay(2);
}
