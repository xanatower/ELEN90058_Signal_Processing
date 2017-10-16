%B[] = filter coefficients
%x[] is a long input sequence
%N length of data block
function X = overlapadd(B, x, N)
    
    %N is given in this case
    N1=length(x);
    M=length(B);
    %therefore we calculate L based on N and M
    L = N - M +1;
    
    %new zero padded array of x
    x=[x zeros(1,mod(-N1,L))];%to make sure x has interger number * L's length

    N2=length(x);
    %pad zeros to filter coef array
    B=[B zeros(1,L-1)];
    %perform N = L+M-1 point FFT to the h
    H_k=fft(B,L+M-1);
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
        Y=X1.*H_k;
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

%test filter is working

