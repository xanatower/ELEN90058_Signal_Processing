%XC after sampling is 
clear all
clc
close all

a = 0.12; 
OMG = 0.25*pi;
T = 1/4.8;
%fundamental frequency range
w = -pi:0.01:pi;
XC = (a+1i*w)./((a+1i*w).^2+ OMG.^2);%continues time FT
%abs(xc) only plot the magnetude 
%plot(w, abs(XC));


%NOW plot the sampled DTFT 
A = [1 -exp(-a*T)*cos(OMG*T) 0];
B = [1 -2*exp(-a*T)*cos(OMG*T) exp(-2*a*T)];
[f w] = freqz (A , B , w);
hold on;
%w/T=continuous time frequency
%abs(f)*T
plot ( w, abs(f)*T, 'o');
