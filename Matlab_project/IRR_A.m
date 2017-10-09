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



y = filter(num_A, dem_A, rs);

figure;

fs1 = 32.768e3;
%fs2 = 4.8;
N=25000;
X1_mags = abs(fft(y));
%X2_mags = abs(fft(x2));
%Y1_mags = abs(fft(y1));
%Y2_mags = abs(fft(y2));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
legend('x1');

title('Frequency domain');
