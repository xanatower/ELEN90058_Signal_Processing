clc
clear all
close all

T1 = 1/1.2; 
T2 = 1/4.8; 
omega1 = 0.25 * pi;
omega2 = 1.9 * pi;
T = 1.0;
i = 0;
a = 0.12;
for n = 1:1:256
	x1(n) = exp(-a*i*T1)*cos(omega1*i*T1) + 0.1*sin(omega2*i*T1);
    x2(n) = exp(-a*i*T2)*cos(omega1*i*T2) + 0.1*sin(omega2*i*T2);
    i = i+1;
end


sample = 0:1:255;
plot(T1*sample, x1);
hold on
plot(T2*sample, x2);

figure;
fs1 = 1.2;
fs2 = 4.8;
N=255;
X1_mags = abs(fft(x1));
X2_mags = abs(fft(x2));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs1/N, X1_mags(1:N_2))
hold on;
plot(fax_bins(1:N_2)*fs2/N, X2_mags(1:N_2))
xlabel('Frequency')
ylabel('Magnitude');

%axis tight

% X1 = abs(fft(x2, 256));
% X1 = fftshift(X1);
% fVals = (1:1:256)*fs2/256;
% plot(fVals, X1);
