#include "SPWS3.h"
#include "Params.h"

complex_fract32 twiddle[N/2] = { 0 };
complex_fract32 filter_fft[N] = { 0 };

complex_fract32 input_freq[N] = { 0 };
complex_fract32 output_fft[N] = { 0 };
fract32 output_save[M-1] = { 0 };

// array b
float b[] = { -0.022345, 0.000024, 0.000477, 0.001261, 0.002341, 
    0.003740, 0.005422, 0.007399, 0.009625, 0.012098, 
    0.014760, 0.017602, 0.020547, 0.023589, 0.026627, 
    0.029677, 0.032549, 0.035320, 0.037891, 0.040180, 
    0.042183, 0.043828, 0.045099, 0.045957, 0.046392, 
    0.046392, 0.045957, 0.045099, 0.043828, 0.042183, 
    0.040180, 0.037891, 0.035320, 0.032549, 0.029677, 
    0.026627, 0.023589, 0.020547, 0.017602, 0.014760, 
    0.012098, 0.009625, 0.007399, 0.005422, 0.003740, 
    0.002341, 0.001261, 0.000477, 0.000024, -0.022345 };

float process_time(float x0)
{
	// TODO: 1. Implement the filter using time domain methods
    
    static float x[BUFFER_SIZE] = {0.0};          // BUFFER_SIZE = (M-1) is defined in 'Params.h'
    static int current = 0;

    //return back forwading position of the array if current is negative
    float y = b[0] * (x0 + x[(current + BUFFER_SIZE)%BUFFER_SIZE]);      // Macro 'REM(current)' is defined in 'Params.h'

    x[current] = x0;
    // save current x0 into x after 'y' is calculated, thus the size of 'x' can be reduced by 1 (from M to M-1).

    for (int i = 1; i <= BUFFER_SIZE/2-1; i++) {
        y += b[i] * (x[(current-i) + BUFFER_SIZE)%BUFFER_SIZE)] + x[((current+i) + BUFFER_SIZE)%BUFFER_SIZE]);
    }
   
    y += b[BUFFER_SIZE/2] * x[((current-BUFFER_SIZE/2)) + BUFFER_SIZE)%BUFFER_SIZE];
    current++;
    current %= BUFFER_SIZE;//INCREMENT EVERY BUFFER_SIZE
    
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

    int index = 0;

    int blk_exp;

    //input_data defined, input_fft->input_freq, twiddle, N,  
    rfft_fr32(input_data, input_freq, twiddle, 1, N, &blk_exp, 1);

    // conjugate symmetry 
    output_fft[0] = cmlt_fr32(filter_fft[0], input_freq[0]);

    index = 1;
    while(index<N/2){
        //multiply H[k] and x[k]
        output_fft[index] = cmlt_fr32(filter_fft[index], input_fft[index]);
        //secong half of the FFT is conjugate of the first half
        output_fft[N-index] = conj_fr32(output_fft[index]);//complex conjugate
        index++;
    }
    
    output_fft[N/2] = cmlt_fr32(filter_fft[N/2], input_fft[N/2]);
    
    complex_fract32 output_complex[N]= { 0 };

    //inverse FFT of the output array
    ifft_fr32(output_fft, output_complex, twiddle, 1, N, &blk_exp, 1);
    
	int i;
	for (i = 0; i < N; i++)
	{
        //re scale data point as what he did in init_process()
		output[index] = output_complex[index].re << (blk_exp);
    }
    
    // overlap add
    index = 0;
    while( index < M-1 ) {
        output[index] += output_save[index];
        output_save[index] = output[L+index];
        index++
    }
    
}
