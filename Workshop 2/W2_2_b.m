clc
clear all
close all
%set alpha = 1

%plots zeros in the unit circle
zplane([1 0 0 0 0 0 0 0 0.5], [1]);

figure;
%impluse response of the filter
impz([1 0 0 0 0 0 0 0 0.5], [1]);


figure;
%mag and phase reponse
freqz([1 0 0 0 0 0 0 0 0.5], [1], 'whole');
