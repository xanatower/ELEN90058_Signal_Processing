#include <stdio.h>
#define M 48
float process_time(float x0);


int main() {
    float in[M] = {0.0};
    float out[M] = {0.0};
    int i;

    for (i=0; i<M; i++){
        in[i] += 1;
    }

    for (i=0; i<M; i++) {
        out[i] = process_time(in[i]);
    }

    for (i=0; i<M; i++) {
        printf("out[%d] = %f\n", i, out[i]);
    }

    /*Check for 2nd cycle run if 'current' is resetting - dont worry about output*/
    for (i=0; i<M; i++){
        in[i] += 1;
    }

    for (i=0; i<M; i++) {
        out[i] = process_time(in[i]);
    }

    for (i=0; i<M; i++) {
        printf("out[%d] = %f\n", i, out[i]);
    }
    return 0;
}


float process_time(float x0)
{
	// TODO: 1. Implement the filter using time domain methods
    float y;
    int k;
    
    float b[] = { -0.023196, 0.001615, 0.002148, 0.003042, 0.004285,
            0.005860, 0.007729, 0.009883, 0.012281, 0.014896,
            0.017673, 0.020588, 0.023571, 0.026576, 0.029539,
            0.032445, 0.035150, 0.037656, 0.039974, 0.041942,
            0.043577, 0.044834, 0.045691, 0.046120, 0.046120,
            0.045691, 0.044834, 0.043577, 0.041942, 0.039974,
            0.037656, 0.035150, 0.032445, 0.029539, 0.026576,
            0.023571, 0.020588, 0.017673, 0.014896, 0.012281,
            0.009883, 0.007729, 0.005860, 0.004285, 0.003042,
            0.002148, 0.001615, -0.023196 };

/*
            float b[] = { -0.023442, 0.002569, 0.003110, 0.004042, 0.005350, 
        0.006991, 0.008953, 0.011183, 0.013656, 0.016321, 
        0.019156, 0.022085, 0.025091, 0.028018, 0.030937, 
        0.033753, 0.036369, 0.038771, 0.040886, 0.042684, 
        0.044126, 0.045181, 0.045806, 0.046024, 0.045806, 
        0.045181, 0.044126, 0.042684, 0.040886, 0.038771, 
        0.036369, 0.033753, 0.030937, 0.028018, 0.025091, 
        0.022085, 0.019156, 0.016321, 0.013656, 0.011183, 
        0.008953, 0.006991, 0.005350, 0.004042, 0.003110, 
        0.002569, -0.023442 };
*/
    static float xBuffer[M] = {0.0};  //0-47
    static int current = 0;
    //y[n] = h[0]x[n] + h[1]x[n-1] + ... + h[M-1]x[n-(M-1)]
    //y[n] = summation of h[k]x[n-k], from k=0 to k=M-1
    //Elements b[23],b[24] is the same value (starting pt for symmetry)

    //Initialise the 1st element  of y, k=0
    y = b[0]*x0;

    //Store all x signal values in buffer array
    xBuffer[current] = x0;

    //Add last element to respective symmetry coeff b[0] when n=M-1
    if(current == M-1) {
        y = y + b[M-1]*xBuffer[current];
    }

    //Symmetry between b[0 to 23] and b[24 to 47] - from 1-23 index only needed
    //Covers elements 1&46, 2&45, ... 23&24
    /*
    if (current != 0) {
    	for (k=1; k <= M/2 - 1; k++) {
    	    //y = y + b[k] * (xBuffer[current-1 %(M/2)] + xBuffer[M-current+1]);
            y = y + b[k] * (xBuffer[current-1 %(M/2)] + xBuffer[M-current+1]);
    	}
    }
*/
    if (current != 0) {
        for (k=1; k <= M - 2; k++) {
            y = y + b[k] * (xBuffer[current-k]);
            if(current-k == 0) {
                break;
            }
        }
    }


    current += 1;
    current = current % M;

    return y;
}