%second order notch filter, block A
clc
clear all
close all

load('projsignal0.mat');
%this is the input
rs = rs(1:25E3);%only take the first 25000 data point
fs1 = 32.768e3;
beta = cos(2*pi*(4915.2/fs1));
%beta = cos(2*pi*(7372.8/fs1));
notch_bw = 0.015*pi;%changed to a wider bandwidth
alpha = (1/cos(notch_bw)) - sqrt((1)/((cos(notch_bw))^2)-1)

num_A  = ((1+alpha)/2).*[1 -2*beta 1];
dem_A = [1 -beta*(1+alpha) alpha];

%filter characteristic
[hA, wA] = freqz(num_A, dem_A, 1E2);


%magnitude plot
plot(wA/pi, abs(hA));
title('Magnitude response of Block A');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Magnitude(linear scale)');


%plot phase
figure;
plot(wA/pi, phase(hA));
title('Phase response of Block A');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Phase(rad)');

%now
r1r2 = filter(num_A, dem_A, rs);

figure;
N=25000;
X1_mags = abs(fft(r1r2));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
title('Single Side FFT of r[n](r1r2)');
xlabel('frequency(Hz)');
ylabel('Magnitude(linear scale)');


%BLOCK D implementaion
figure;
%the only requirement here is the passband of r1
dp=4E-4; ds=0.001;
%peak passband ripple and minimum stopband attenuation in dB
ap=-20*log10(1-dp); as=-20*log10(ds);
wp = 2* 4096/fs1;
ws = wp +0.05;%right after passband

[ordD, ~] = cheb2ord(wp, ws, ap, as);
[num_D, dem_D] = cheby2(ordD, as, ws, 'low');
[hD, wD] = freqz(num_D, dem_D);
%MAG
plot(wD/pi, abs(hD));
title('Magnitude response of Block D');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Magnitude(linear scale)');
%PHASE

figure;
plot(wD/pi, phase(hD));
title('Phase response of Block D');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Phase(rad)');


r1 = filter(num_D, dem_D, r1r2);

figure;
N=25000;
X1_mags = abs(fft(r1));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
title('s1[n] Frequency domain');
xlabel('frequency(Hz)');
ylabel('Magnitude(linear scale)');
sound(r1, fs1);


%H1 analysis
figure;
num_H1 = conv(num_A, num_D);
dem_H1 = conv(dem_A, dem_D);
[hH1, wH1] = freqz(num_H1, dem_H1);
%MAG
plot(wH1/pi, abs(hH1));
title('Magnitude response of cascading Block A&D');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Magnitude(linear scale)');
%PHASE
figure;
plot(wH1/pi, phase(hH1));
title('Phase response of Block D');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Phase(rad)');

fprintf('The order of Block D is %d\n', ordD);


