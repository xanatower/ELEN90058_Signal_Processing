clc
clear all
close all

load('projsignal0.mat');
fs1 = 32.768e3;
%fs2 = 4.8;
N=292452;
X1_mags = abs(fft(rs));
%X2_mags = abs(fft(x2));
%Y1_mags = abs(fft(y1));
%Y2_mags = abs(fft(y2));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2));
legend('x1');

title('Frequency domain');