#include "SPWS3.h"
#include "Params.h"

//input_data is [N] length

complex_fract32 twiddle[N/2] = { 0 };
complex_fract32 filter_fft[N] = { 0 };

complex_fract32 input_fft[N] = { 0 };
complex_fract32 output_fft[N] = { 0 };
fract32 output_save[M-1] = { 0 }; //stores the last block's last [M-1] entries (time-domain)

//cadd_fr32, csub_fr32, cmlt_fr32 and cdiv_fr32 should be used instead of +-/* etc


//use to temporarily hold the ifft output
complex_fract32 output_temp[N]={0};

float previous_inputs[M]={0};

	// array filt_coeffs - exported from MATLAB
float filt_coeffs[] = { -0.023566, 0.003661, 0.004169, 0.005126, 0.006483, 
		0.008195, 0.010221, 0.012526, 0.015055, 0.017779, 
		0.020644, 0.023567, 0.026533, 0.029459, 0.032300, 
		0.034997, 0.037506, 0.039731, 0.041743, 0.043343, 
		0.044571, 0.045412, 0.045837, 0.045837, 0.045412, 
		0.044571, 0.043343, 0.041743, 0.039731, 0.037506, 
		0.034997, 0.032300, 0.029459, 0.026533, 0.023567, 
		0.020644, 0.017779, 0.015055, 0.012526, 0.010221, 
		0.008195, 0.006483, 0.005126, 0.004169, 0.003661, 
		-0.023566 };

//float input_data_padded[N+M-1]={0.0};



float process_time(float x0)
{
	// 1. Implement the filter using time domain methods
    float y=0;
    int i;
    for (i = M-1; i>0; i--){
            //Shift previous_inputs by 1 to keep a record of previous inputs:
        previous_inputs[i]=previous_inputs[i-1];
    }
    previous_inputs[0]=x0;
	//after this, convolve with the filter coefficients:
    for (i = 0; i < M-1; i++){
        //Filt coeffs are symm, so h[k]=h[-k] so convolution as below:
    	y=y+previous_inputs[i]*filt_coeffs[i];
    }
    return y;
}

void init_process()
{
    int i;

    // calculate twiddle factors
    twidfftrad2_fr32(twiddle, N);
    
    // copy filter coefficients to input array to do fft
    for (i = 0; i < M; i++)
        input_data[i] = (1 << 30) * filt_coeffs[i];
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
    
    //Pad FFT of filter with zeros to get N+M-1 length
    //Done here to avoid calling it every loop
    complex_fract32 filter_fft_padded[N+M-1]={0.0};
    for (i=0;i<M;i++){
        filter_fft_padded[i]=filter_fft[i];
    }


    // clear input array
    for (i = 0; i < M; i++)
        input_data[i] = 0;
}

void process_block(fract32 output[])
{
    // TODO: 2. Implement the filter using the overlap-add method

    //N: length chunks of x[n], and length of FFT(chunks of x[n])
    //M: length of FIR filter
    
    //Algorithm:
    //1. chop up x into blocks - DONE BEFORE THIS ROUTINE IS CALLED
    //1.5  NOT REQD? pad filter and perform FFT; FFT already performed so we have just padded the FFT above
    //2. NOT REQD? pad x to N+M-1 length
		//THIS SECTION ISNT REQUIRED???????
		//1. chop up x into blocks - DONE BEFORE THIS ROUTINE IS CALLED
	    //1.5 pad filter and perform FFT; FFT already performed so we have just padded the FFT above
	    //2. pad filter x to N+M-1 length - xPad is declared as zero array above
	    //pad x to N+M-1 length  - only first N x vals copied; rest are left as zero
	    /*int i;
	    for (i = 0; i < N-1; i++){
	        input_data_padded[i]=input_data[i];
	    }*/



	//Algorithm:
    //3. do DFT of x blocks
    //4. multiply x chunk by filter to get chunk of Y[k]
    //5. then ifft to get this chunk of y[n]
    //6. then overlapadd to get y[n] sequence 



	//////////////////////////////Code/////////////////////////////////////////////
    //3. do DFT of x blocks
    int filter_blk_exp;
    rfft_fr32(input_data,input_fft,twiddle,1,N,&filter_blk_exp,1);
    int i;
    // rescale data points -
    for (i = 0; i < N; i++)
    {
        filter_fft[i].re = filter_fft[i].re << (filter_blk_exp);
        filter_fft[i].im = filter_fft[i].im << (filter_blk_exp);
    }

    //4. multiply input data FFT chunk by filter FFT to get chunk of output data FFT
    int k;
    for (k=0; k<N-1; k++){
        output_fft[k]=cmlt_fr32(input_fft[k],filter_fft[k]);
    }
    
    //5. then ifft to get this chunk of y[n]
    ifft_fr32(output_fft,output_temp,twiddle,1,N,&filter_blk_exp,1);
	//I don't think we need to scale by filter_blk_exp here (?)
	for (i = 0; i < N; i++)
	{
		//Copy just the real part to the output array:
		output[i] = output_temp[i].re << filter_blk_exp;
	}
	//Save the last M-1 output points for use in the next function call
	for (i=N-M+1; i<N; i++){
		output_save[i]=output[i];
	}
	//Carry out overlap-add method on each point of FFT:
	for (i=0; i<M-1; i++){
		output[i]=output_save[i]+output[i];
	}
}
