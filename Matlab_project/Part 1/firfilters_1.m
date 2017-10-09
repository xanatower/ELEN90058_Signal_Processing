clear;
close all;
load projsignal0.mat;


rs = rs(1:25E3);%only take the first 25000 data point
fvtool(rs);

fsamp = 32768;
% block A notch filter
fcuts = [4415 4914 4916 5415];
mags = [13670 0 13670];
devs = [0.01 0.01 0.01];

[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hbs = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');

Ybs = filter(hbs,1,rs);

fvtool(Ybs);

%block D lowpass filter

fcuts = [4096 4596];
mags = [1 0];
devs = [0.001 0.001];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hlp = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
Ylp = filter(hlp,1,Ybs);

fvtool(Ylp);



%Ylp is the output signal of block D, s1[n];

%block B highpass filter
fcuts = [8192 12288];
mags = [0 1];
devs = [0.001 0.001];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hhp = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');

Yhp = filter(hhp,1,Ybs);
fvtool(Yhp);
% Yhp is the output signal of block B, use Yhp to demodulation

fs1 = fsamp;
t = (0:1:24999).* (1/fs1);
demod = zeros(1, 25000);
for i = 1:1:25000
    demod(i) = Yhp(i).*cos(2*pi*12288*t(i)+ 0.3*pi );
end

figure;

N=25000;
X1_mags = abs(fft(demod));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
legend('signal in single side FFT');
title('Frequency domain');


%block C lowpass filter

fcuts = [4096 4596];
mags = [1 0];
devs = [0.001 0.001];
[n,Wn,beta,ftype] = kaiserord(fcuts,mags,devs,fsamp);
n = n + rem(n,2);
hlp = fir1(n,Wn,ftype,kaiser(n+1,beta),'noscale');
Ylp_1 = filter(hlp,1,demod);
sound(Ylp_1, fsamp);

figure;

N=25000;
X1_mags = abs(fft(Ylp_1));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
legend('signal in single side FFT');
title('Frequency domain');


