%second order notch filter, block A
clc
clear all
close all

load('projsignal1.mat');
%this is the input
rs = rs(1:25E3);%only take the first 25000 data point
fs1 = 32.768e3;
%beta = cos(2*pi*(4915/fs1));
beta = cos(2*pi*(7372.8/fs1));
notch_bw = 0.01*pi;%changed to a wider bandwidth
alpha = (1/cos(notch_bw)) - sqrt((1)/((cos(notch_bw))^2)-1);



num_A  = ((1+alpha)/2).*[1 -2*beta 1];
dem_A = [1 -beta*(1+alpha) alpha];

%filter characteristic
[hA, wA] = freqz(num_A, dem_A, 1E2);
%magnitude plot
plot(wA/pi, abs(hA));



r1r2 = filter(num_A, dem_A, rs);

figure;
N=25000;
X1_mags = abs(fft(r1r2));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
legend('signal in single side FFT');
title('Frequency domain');

%%now we want a lowpass filter to filter out high frequency
%%to get r1


figure;
%We want to filter the 
dp=0.01; ds=0.01;
%peak passband ripple and minimum stopband attenuation in dB
ap=-20*log10(1-dp); as=-20*log10(ds);


ws = (2* 8192/fs1)-0.05;
wp = 2* 8192/fs1;%passband

[ordD, ~] = cheb2ord(wp, ws, ap, as);
[num_D, dem_D] = cheby2(ordD, as, ws, 'high');
[hD, wD] = freqz(num_D, dem_D);
plot(wD/pi, abs(hD));


r2 = filter(num_D, dem_D, r1r2);

figure;
N=25000;
X1_mags = abs(fft(r2));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
legend('signal in single side FFT');
title('Frequency domain');
sound(r2, fs1);


%H1 analysis
figure;
num_H1 = conv(num_A, num_D);
dem_H1 = conv(dem_A, dem_D);
[hH1, wH1] = freqz(num_H1, dem_H1);
plot(wH1/pi, abs(hH1));






