fsamp = 32768;
fcuts = [6553 8192];
mags = [2000 0];
devs = [0.01 0.01];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hlp = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');


[H,f] = freqz(hlp,1,16384,fsamp);
plot(f,abs(H))
grid
