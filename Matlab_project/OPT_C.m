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

%now
r1r2 = filter(num_A, dem_A, rs);

figure;
N=25000;
X1_mags = abs(fft(r1r2));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
title('s1[n] Frequency domain');
xlabel('frequency(Hz)');
ylabel('Magnitude(linear scale)');



figure;
%%%highpass filter, block B
dp_B=9E-3; ds_B=0.001;
%peak passband ripple and minimum stopband attenuation in dB
ap_B=-20*log10(1-dp_B); as_B=-20*log10(ds_B);


ws_B = (2* 8192/fs1)-0.05;
wp_B = 2* 8192/fs1;%passband

[ordB, ~] = ellipord(wp_B, ws_B, ap_B, as_B);
[num_B, dem_B] = ellip(ordB, ap_B, as_B, wp_B,'high');
[hB, wB] = freqz(num_B, dem_B);

%MAG
plot(wB/pi, abs(hB));
title('Magnitude response of Block B');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Magnitude(linear scale)');

%PHASE
figure;
plot(wB/pi, phase(hB));
title('Phase response of Block B');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Phase(rad)');



%apply the filter
r2 = filter(num_B, dem_B, r1r2);


figure;
N=25000;
X1_mags = abs(fft(r2));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
title('s~ 2[n] in Frequency domain');
xlabel('frequency(Hz)');
ylabel('Magnitude(linear scale)');


%demodulation

t = (0:1:24999).* (1/fs1);
demod = zeros(1, 25000);
for i = 1:1:25000
    demod(i) = r2(i).*cos(2*pi*12288*t(i)+ pi/3);
end

figure;
N=25000;
X1_mags = abs(fft(demod));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
title('Demodulated signal in Frequency domain');
xlabel('frequency(Hz)');
ylabel('Magnitude(linear scale)');


%the only requirement here is the passband of r1
dp_C=9E-3; ds_C=0.001;
%peak passband ripple and minimum stopband attenuation in dB
ap_C=-20*log10(1-dp_C); as_C=-20*log10(ds_C);

wp_C = 2* 4096/fs1;
ws_C = wp_C +0.05;%right after passband

[ordC, ~] = ellipord(wp_C, ws_C, ap_C, as_C);
[num_C, dem_C] = ellip(ordC, ap_C, as_C, wp_C,  'low');
[hC, wC] = freqz(num_C, dem_C);
%MAG
figure;
plot(wC/pi, abs(hC));
title('Magnitude response of Block C');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Magnitude(linear scale)');

%PHASE
figure;
plot(wC/pi, phase(hC));
title('Phase response of Block C');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Phase(rad)');



%DEMOD AND LPFILTERED
r1 = filter(num_C, dem_C, demod);


figure;
N=25000;
X1_mags = abs(fft(r1));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
title('s2[n] in Frequency domain');
xlabel('frequency(Hz)');
ylabel('Magnitude(linear scale)');

sound(r1, fs1);

fprintf('The order of Block B is %d\n', ordB);
fprintf('The order of Block C is %d\n', ordC);




