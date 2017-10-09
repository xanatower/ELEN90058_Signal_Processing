clear;
close all;

notch_F_0 = 7372.8;     % sinusoid noise frequency
F_s = 32.768E3;         % sampling frequency
F_c = 12.288E3;         % carrier frequency

signal_bw = 4096;
r2_lower_bound = F_c - signal_bw;

load('projsignal1');

rs = rs(1:25E3);
% the first 25000 data points

N = length(rs);


% BlockA 2nd order notch filter

notch_BW = 5E-3 * pi;
% notch filter bandwidth

notch_omega_0 = 2 * pi * notch_F_0 / F_s;

cosine = cos(notch_BW);
notch_alpha = 1/cosine - sqrt(1/cosine^2 - 1);
clear cosine;

notch_beta = cos(notch_omega_0);

fprintf('Sinusoid frequency: F_0 = %.1f Hz\n', notch_F_0);
fprintf('Sinusoid frequency: omega_0 = %f * pi rad/sample\n', notch_omega_0/pi);
fprintf('Notch filter: alpha = %f\tbeta = %f\n', notch_alpha, notch_beta);

numBlockA = ((1+notch_alpha) / 2) * [1 -2*notch_beta 1];
denBlockA = [1 -notch_beta*(1+notch_alpha) notch_alpha];

[hBlockA, wBlockA] = freqz(numBlockA, denBlockA, 1E2);

figure;
subplot(2, 1, 1);
plot(wBlockA/pi, abs(hBlockA));
title('Block A amplitude response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Magnitude (Linear Scale)');
grid on;

subplot(2, 1, 2);
plot(wBlockA/pi, rad2deg(phase(hBlockA)));
title('Block A phase response');
xlabel('Normalized Frequency (\times\pi rad/sample)');
ylabel('Phase (Degrees)');
grid on;