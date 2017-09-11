clear all 
clc 
close all
[x, fs]=audioread('speech.wav');
D = 1760;
alpha = 1.05;

B = [1 zeros(1, D-1) alpha];
A = [1];
y = filter(A, B, x);
sound(y, fs);