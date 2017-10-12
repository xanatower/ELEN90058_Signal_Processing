#include "SPWS3.h"
#include "Params.h"

complex_fract32 twiddle[N/2] = { 0 };
complex_fract32 filter_fft[N] = { 0 };

complex_fract32 input_fft[N] = { 0 };
complex_fract32 output_fft[N] = { 0 };
fract32 output_save[M-1] = { 0 };

//Array - Impulse Response coefficients
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

float process_time(float x0)
		{
			// TODO: 1. Implement the filter using time domain methods

		    float y;
		    int k;
		    static float xBuffer[M] = {0.0};  //0-47
		    static int current = 0;
		    //y[n] = h[0]x[0] + h[1]x[n-1] + ... + h[M-1]x[n-(M-1)]
		    //y[n] = summation of h[k]x[n-k], from k=0 to k=M-1
		    //Elements b[23],b[24] is the same value (starting pt for symmetry)




		    //Initialise the 1st element  of y, k=0
		    y = b[0]*(x0 + xBuffer[current]);

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

		    //Covers 2nd to 2nd last element
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




void init_process()
{
    int i;

    // calculate twiddle factors
    twidfftrad2_fr32(twiddle, N);
    
    // copy filter coefficients to input array to do fft
    for (i = 0; i < M; i++)
        input_data[i] = (1 << 30) * b[i];
        // [ note ]
        // Here we should scale by (1 << 31)-1 for full scale, however
        // doing so can cause overflows in fixed point, so we halve it
        // here and put back the factor 2 on output.
    
    // do fft
    int filter_blk_exp;
    rfft_fr32(input_data, filter_fft, twiddle, 1, N, &filter_blk_exp, 1);
    
    // rescale data points
    for (i = 0; i < N; i++)
    {
        filter_fft[i].re = filter_fft[i].re << (filter_blk_exp);
        filter_fft[i].im = filter_fft[i].im << (filter_blk_exp);
    }
    
    // clear input array
    for (i = 0; i < M; i++)
        input_data[i] = 0;
}

void process_block(fract32 output[])
{
    // TODO: 2. Implement the filter using the overlap-add method

	int i;
	int blk_exp;
	complex_fract32 output_IFFT[N] = { 0.0 };

	//y[n] = IFFT(FFT(x_k[n]) * (FFT(h[n]))) from wikipedia

	rfft_fr32(input_data, input_fft, twiddle, 1, N, &blk_exp, 1);

	//First element
	output_fft[0] = cmlt_fr32(input_fft[0], filter_fft[0]);

	//Complex multiplication on FFT(x_k[n]) * (FFT(h[n])
	//Element 1 & 511, 2 & 510 ... 255 & 257 (using symmetry)
	for (i = 1; i < N/2; i++) {
		output_fft[i] = cmlt_fr32(input_fft[i], filter_fft[i]);
		output_fft[N-i] = conj_fr32(input_fft[i]);
	}

	//Element 256
	output_fft[N/2] = cmlt_fr32(input_fft[N/2], filter_fft[N/2]);

	//Do the IFFT to obtain y[n]
	ifft_fr32(output_fft, output_IFFT, twiddle, 1, N, &blk_exp, 1);


	//Rescale - we only want Real parts for the output
	for (i = 0; i < N; i++)
	{
		output[i] = output_IFFT[i].re << blk_exp;
	}


	/*
	for (i = 0; i < N; i++)
	{
		// Note- the input is scaled by half here because the output will
		// be scaled to account for the filter coefficient scaling above.
		// In your filtering code you should NOT do this.
		output[i] = input_data[i] / 2;
	}
	*/
}
