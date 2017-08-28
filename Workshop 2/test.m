%fixed tau

%https://au.mathworks.com/help/control/ref/tf.html
clear all
clc
close all
K=[1 3 5];
tau=2;
s = tf('s');

for s_i = 1:1:3
    sys{s_i} = K(s_i)/(tau*s+1);
end

for s_i = 1:1:3
    step(sys{s_i});
    hold on
end

figure;
for s_i = 1:1:3
    bode(sys{s_i});
    hold on
end

%fixed K =1
clear all

K = 1;
tau = [2 4 6];
s = tf('s');

for s_i = 1:1:3
    sys{s_i} = K/(tau(s_i)*s+1);
end
figure;
for s_i = 1:1:3
    step(sys{s_i});
    hold on
end

figure;
for s_i = 1:1:3
    bode(sys{s_i});
    hold on
end
%bode(H);