%filter design

clc;
clear;
close all;


N = 2^9;                % block length

fs = 24E3;%samplin frequency
% FIR filter design
[ORD, passband_edge, frequency_band_mag, w] = firpmord([220 880], [1 0], [0.05 0.05], fs);
ORD = ORD + 7;  % increment the filter order until all specifications are satisfied

num = firpm(ORD, passband_edge, frequency_band_mag, w);

%verify the filter
[h, w] = freqz(num, 1, 2^10);
plot(w/pi, abs(h));
title('Magnitude response');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Magnitude(linear scale)');

%PHASE
figure;
plot(w/pi, phase(h));
title('Phase response');
xlabel('Normalised frequency(*pi rad/s)');
ylabel('Phase(rad)');

%num is the filter coefficients we need
%use print array for this array
print_array(num, 'b');

%%%%Test signal genration
%central frequency at around
%r = r1+r2, where r1 at 100Hz, 
f1 = 100;
w1 = 2*pi*f1;
%r2 at 1000Hz 
f2 = 2000;
w2 = 2*pi*f2;
%test signal length is the same as the sampling frequency
n_sampled = (1:fs*100)/fs;
x = sin(w2*n_sampled);

%plot this generated signal in frequency domain
figure;
N=fs*100;
X1_mags = abs(fft(x));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs/N, X1_mags(1:N_2));
title('Generated x in Frequency domain');
xlabel('frequency(Hz)');
ylabel('Magnitude(linear scale)');

%sound(x, fs);

%%try to filter this signal with the filter we designed

x_filtered = filter(num, 1, x);


%plot this generated signal in frequency domain
figure;
N=fs*100;
X1_mags = abs(fft(x_filtered));
fax_bins = [0 : N-1]; %frequency axis in bins
N_2 = ceil(N/2);
plot(fax_bins(1:N_2)*fs/N, X1_mags(1:N_2));
title('filtered x in Frequency domain');
xlabel('frequency(Hz)');
ylabel('Magnitude(linear scale)');

sound(x, fs);







