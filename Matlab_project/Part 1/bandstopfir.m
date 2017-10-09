clc
close all
clear all


fsamp = 32768;
fcuts = [4300 4360 4415 4450];
mags = [13670 0 13670];
devs = [0.01 0.01 0.01];

[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hbs = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
[H,f] = freqz(hbs,1,16384,fsamp);
plot(f,abs(H))
grid