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

alpha1 = 0.593;
alpha2 = 0.464;

%x(1) = exp(-a*0*T2)*cos(omega1*0*T2) + 0.1*sin(omega2*0*T2);
x2(1)= 0.1*sin(omega2*0*T2);
y1(1) = ((1-alpha1)/2)*x2(1);
y2(1) = ((1-alpha2)/2)*y1(1);
for n = 2:1:256
    %only use fs=4.8Hz
	%x(n) = exp(-a*i*T2)*cos(omega1*i*T2) + 0.1*sin(omega2*i*T2);
    x2(n) = 0.1*sin(omega2*i*T2);
    y1(n) = ((1-alpha1)/2)*x2(n)+((1-alpha1)/2)*x2(n-1)+alpha1*y1(n-1);
    y2(n) = ((1-alpha2)/2)*y1(n)+((1-alpha2)/2)*y1(n-1)+alpha2*y2(n-1);
    i = i+1;
end

sample = 0:1:255;
plot(T2*sample, x2);
hold on
plot(T2*sample, y1);
plot(T2*sample, y2);


figure;
fs1 = 1.2;
fs2 = 4.8;
N=255;
X_mags = abs(fft(x2))
Y1_mags = abs(fft(y1));
Y2_mags = abs(fft(y2));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs2/N, X_mags(1:N_2))
hold on;
plot(fax_bins(1:N_2)*fs2/N, Y1_mags(1:N_2))
plot(fax_bins(1:N_2)*fs2/N, Y2_mags(1:N_2))
xlabel('Frequency')
ylabel('Magnitude');
