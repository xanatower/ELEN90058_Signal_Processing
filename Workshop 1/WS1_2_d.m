clc
clear all


a = 0.12; 
OMG = 0.25*pi;
T = 1/4.8;
w = -pi:0.01:pi;


%NOW plot the sampled DTFT 
A = [1 -exp(-a*T)*cos(OMG*T) 0];
B = [1 -2*exp(-a*T)*cos(OMG*T) exp(-2*a*T)];
[f w] = freqz (A , B , w);
hold on;
%w/T=continuous time frequency
%abs(f)*T
plot ( w, abs(f), 'o');



%solve (abs(1-x)/sqrt(2))*(sqrt(1+0.986)/sqrt(1+x^2-2*x*0.986)) = 0.95 over the reals
