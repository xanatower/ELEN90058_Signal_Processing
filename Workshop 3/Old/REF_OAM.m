% Theory:
%
% Overlap Add Method:
% The overlap–add method is an efficient way to evaluate the discrete convolution of a very long signal with a finite impulse response
% (FIR) filter where h[m] = 0 for m outside the region [1, M].The concept here is to divide the problem into multiple convolutions of h[n]
% with short segments of x[n], where L is an arbitrary segment length. Because of this y[n] can be written as a sum of short convolutions.
%
% Algorithm:
%
% The signal is first partitioned into non-overlapping sequences, then the discrete Fourier transforms of the sequences are evaluated by
% multiplying the FFT xk[n] of with the FFT of h[n]. After recovering of yk[n] by inverse FFT, the resulting output signal is reconstructed by
% overlapping and adding the yk[n]. The overlap arises from the fact that a linear convolution is always longer than the original sequences. In
% the early days of development of the fast Fourier transform, L was often chosen to be a power of 2 for efficiency, but further development has
% revealed efficient transforms for larger prime factorizations of L, reducing computational sensitivity to this parameter.
% A pseudo-code of the algorithm is the following:
%
% Algorithm 1 (OA for linear convolution)
%  Evaluate the best value of N and L
%    H = FFT(h,N)       (zero-padded FFT)
%    i = 1
%    while i <= Nx
%        il = min(i+L-1,Nx)
%        yt = IFFT( FFT(x(i:il),N) * H, N)
%        k  = min(i+N-1,Nx)
%        y(i:k) = y(i:k) + yt    (add the overlapped output blocks)
%        i = i+L
%    end
%
% Note: The following method uses the block convolution algorithm to compute the convolution
%

clc;
clear all;
x = input('Enter the sequence X(n) = ');
fprintf('This sequence should be a integral multiple of 2*n \n');
h = input('Enter the sequence H(n) = ');

% Code to perform Convolution using Overlap Add Method
n1 = length(x);
n2 = length(h);
N = n1+n2-1;
y = zeros(1,N);
h1 = [h zeros(1,n2-1)]
n3 = length(h1);
y = zeros(1,N+n3-n2);
H = fft(h1);
for i = 1:n2:n1
    if i<=(n1+n2-1)
        x1 = [x(i:i+n3-n2) zeros(1,n3-n2)];
    else
        x1 = [x(i:n1) zeros(1,n3-n2)];
    end
    x2 = fft(x1);
    x3 = x2.*H;
    x4 = round(ifft(x3));
    if (i==1)
        y(1:n3) = x4(1:n3);
    else
        y(i:i+n3-1) = y(i:i+n3-1)+x4(1:n3);
    end
end

% Code to plot X(n)
subplot(3,1,1);
stem(x(1:n1),'black');
grid on;
title('X(n)');
xlabel('n--->');
ylabel('Amplitude --->');

%Code to plot H(n)
subplot(3,1,2);
stem(h(1:n2),'red');
grid on;
title('H(n)');
xlabel('n--->');
ylabel('Amplitude --->');

%Code to plot the Convolved Signal
subplot(3,1,3);
disp(y(1:N));
stem(y(1:N));
grid on;
title('Convolved Singal');
xlabel('n--->');
ylabel('Amplitude --->');

% Add title to the Overall Plot
ha = axes ('Position',[0 0 1 1],'Xlim',[0 1],'Ylim',[0 1],'Box','off','Visible','off','Units','normalized', 'clipping' , 'off');
text (0.5, 1,'\bf Block Convolution using Overlap Add Method ','HorizontalAlignment','center','VerticalAlignment', 'top')