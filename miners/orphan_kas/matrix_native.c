/* Orphan KAS native job preparation. GPL-3.0-or-later.
 * Copyright (C) 2026 Rev. J. Money / JMSCNC.
 * xoshiro256++ and rank rejection follow the Kaspa reference algorithm.
 */
#include <stdint.h>
#include <math.h>
static uint64_t rol(uint64_t v,int n){return (v<<n)|(v>>(64-n));}
static uint64_t next(uint64_t s[4]){
    uint64_t r=s[0]+rol(s[0]+s[3],23),t=s[1]<<17;
    s[2]^=s[0];s[3]^=s[1];s[1]^=s[2];s[0]^=s[3];s[2]^=t;s[3]=rol(s[3],45);return r;
}
static int rank64(uint16_t m[64][64]){
    double a[64][64];unsigned char selected[64]={0};int rank=0;
    for(int i=0;i<64;i++)for(int j=0;j<64;j++)a[i][j]=m[i][j];
    for(int i=0;i<64;i++){
        int j;for(j=0;j<64;j++)if(!selected[j]&&fabs(a[j][i])>1e-9)break;
        if(j==64)continue;
        selected[j]=1;rank++;double pivot=a[j][i];
        for(int p=i+1;p<64;p++)a[j][p]/=pivot;
        /* Selected rows never participate in a future pivot search. Skipping
         * their updates preserves every future candidate exactly. */
        for(int k=0;k<64;k++)if(!selected[k]&&fabs(a[k][i])>1e-9){
            double v=a[k][i];for(int p=i+1;p<64;p++)a[k][p]-=a[j][p]*v;
        }
    }
    return rank;
}
int kaspa_matrix(const uint8_t seed[32],uint32_t out[512]){
    uint64_t s[4]={0};uint16_t m[64][64];
    for(int i=0;i<32;i++)s[i/8]|=(uint64_t)seed[i]<<(8*(i%8));
    if(!(s[0]|s[1]|s[2]|s[3]))return -1;
    for(int attempt=1;attempt<=1024;attempt++){
        for(int row=0;row<64;row++)for(int group=0;group<4;group++){
            uint64_t v=next(s);for(int n=0;n<16;n++)m[row][group*16+n]=(v>>(4*n))&15;
        }
        if(rank64(m)!=64)continue;
        for(int row=0;row<64;row++)for(int word=0;word<8;word++){
            uint32_t v=0;for(int n=0;n<8;n++)v|=(uint32_t)m[row][word*8+n]<<(4*n);
            out[row*8+word]=v;
        }
        return attempt;
    }
    return -2;
}
