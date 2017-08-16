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
%-(exp(-w*1i)*exp(-T*a)*cos(OMG*T) - 1)/(exp(-w*2i)*exp(-2*T*a) - 2*exp(-w*1i)*exp(-T*a)*cos(OMG*T) + 1)
%-1/(10*(exp(-w*1i) - 1))

%X(w)=- (exp(-w*1i)*exp(-T*a)*cos(OMG*T) - 1)/(exp(-w*2i)*exp(-2*T*a) - 2*exp(-w*1i)*exp(-T*a)*cos(OMG*T) + 1) - 1/(10*(exp(-w*1i) - 1))
a = 0.12; 
OMG = 0.25*pi;
T = 1/4.8;
i=1;
for w=-pi:0.01:pi
    %X(i) = - (exp(-w*1i)*exp(-T*a)*cos(OMG*T) - 1)/(exp(-w*2i)*exp(-2*T*a) - 2*exp(-w*1i)*exp(-T*a)*cos(OMG*T) + 1) - 1/(10*(exp(-w*1i) - 1));
    X(i) = exp(-a*T)
    i=i+1;
end
figure;
plot(-pi:0.01:pi, X);



% figure;
% NFFT = 256;
% X1 = fft(x1, NFFT);
% nVals = (0:NFFT-1)/NFFT;
% plot(nVals, abs(X1));
