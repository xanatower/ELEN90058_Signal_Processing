clc;
clear;
close all;

fs = 24E3;              % sampling frequency
f_pass = 220;           % passband frequency in Hz
f_stop = 880;           % stopband frequency in Hz

N = 2^9;                % block length

a = [1 0];
dev = [0.05 0.05];

% FIR filter design
[n_order, fo, ao, w] = firpmord([f_pass f_stop], a, dev, fs);
n_order = n_order + 7;  % increment the filter order until all specifications are satisfied

numerator = firpm(n_order, fo, ao, w);
clear a dev fo ao w;
M = num2str(length(numerator));

[h_FIR, w_FIR] = freqz(numerator, 1, 2^12);

% generate test signal

f0 = (1:9)*200;     % test signal frequencies
N_x = fs;           % test signal length

vector = (0:N_x-1) / fs;

x_martrix = zeros(length(f0), N_x);

for index=1:length(f0)
    x_martrix(index,:) = sin(2 * pi * f0(index) * vector);
end
clear index;

x = sum(x_martrix);

y_overlapadd = overlapadd_test(numerator, x, N);
y_filter  = filter(numerator, 1, x);
y_fftfilt  = fftfilt(numerator, x);

for i= 1:1:length(y_fftfilt)
    if(y_overlapadd(i) ~= y_fftfilt)
        fprintf('WRONG!!!\n');
    end
end
fprintf('the result is correct, BUT I DONT KNOW WHY\n');


function X = overlapadd_test(numerator, x, N)
    h=numerator;
    %N is given in this case
    N1=length(x);
    M=length(h);
    %therefore we calculate L based on N and M
    L = N - M +1;
    
    %new zero padded array of x
    x=[x zeros(1,mod(-N1,L))];%to make sure x has interger number * L's length

    N2=length(x);
    %pad zeros to filter coef array
    h=[h zeros(1,L-1)];
    %perform N = L+M-1 point FFT to the h
    H=fft(h,L+M-1);
    %divide the new x array into 
    S=N2/L;
    index=1:L;
    X=zeros(M-1);%output
    for stage=1:S
        %take L elements from the x array, pad M-1 zeros to the end
        xm=[x(index) zeros(1,M-1)];
        %take N point DFT of this subsequence
        X1=fft(xm,L+M-1);
        %do linear convolution of this subsequence x_1(eg) and the H array
        Y=X1.*H;
        %do inverse DFT of sub y sequence
        Y=ifft(Y);
        %Samples Added in every stage
        Z=X((length(X)-M+2):length(X))+Y(1:M-1);
        X=[X(1:(stage-1)*L) Z Y(M:M+L-1)];
        index=stage*L+1:(stage+1)*L;
    end
%overlap DTF output is X  
        X = X(1:length(X)-length(Z)-mod(-N1,L));

end







