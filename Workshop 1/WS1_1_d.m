clear all
clc

%H = (1 - a) / 2 * (1 + 1/z) / (1 - a/z)
%where z = e^jw=exp(i*w), where w = -pi :0.01: pi
%and a should vary 

%a = 0.8;

for a = -1:0.1:1 
    H = zeros(0, 629);
    i = 1;
    for w = -pi :0.01: pi
        z = exp(j*w);
        H(i) = (1 - a) / 2 * (1 + 1/z) / (1 - a/z);
        i = i+1;
    end
    figure(1);
    plot(-pi :0.01: pi, abs(H));
    hold on;
    
    figure(2);
    plot(-pi :0.01: pi, angle(H));
    hold on;
    
    
end

