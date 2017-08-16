%xc = exp(-a*t)*cos(OMG1*t), XC = (a+jw)/((a+jw)^2+OMG^2)
%fix OMG, change a
clc
clear all

%a = 0.12; 

for a = 1:10:30
    OMG = 0.25*pi;
    %xc = exp(-a.*t).*cos(OMG1.*t);
    t  = 0:0.01:10;
    xc = exp(-a.*t).*cos(OMG.*t);
    figure(1);
    plot(t, xc);
    hold on

    figure(2);
    w = -pi:0.1:pi;
    XC = (a+1i*w)./((a+1i*w).^2+ OMG.^2);
    plot(w, abs(XC));
    hold on
end
%( a + 1j * Omega ) ./ ( (a + 1j * Omega ) .^2 + Omega_1 ^2 );



