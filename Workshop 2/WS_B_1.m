clear all 
clc 
close all
[x, fs]=audioread('speech.wav');
D = 1760;
alpha = 0.75;

A = [1 zeros(1, D-1) alpha];
B = [1];
y = filter(A, B, x);
sound(y, fs);