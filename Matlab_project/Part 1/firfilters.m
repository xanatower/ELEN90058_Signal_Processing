clc
clear all
close all

fsamp = 32768;

fcuts = [4850 4900 4950 5000];
mags = [13670 0 13670];
devs = [0.01 0.01 0.01];

[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hbs = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');

load projsignal0.mat;

fvtool(rs);

Ybs = filter(hbs,1,rs);

fvtool(Ybs);

fcuts = [6553 8192];
mags = [2000 0];
devs = [0.01 0.01];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hlp = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');

Ylp = filter(hlp,1,Ybs);

fvtool(Ylp);

fcuts = [6553 8192];
mags = [0 2000];
devs = [0.01 0.01];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hhp = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');

Yhp = filter(hhp,1,Ybs);
fvtool(Yhp);


sound(real(double(Ylp)), fsamp);