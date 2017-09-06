#include "SPWS2-notch.h"
#include "math.h"
#define SAMPLE_RATE 24000.0
#define PI 3.14159265359

// Input samples
float LeftInput; 
float RightInput;

// Corrupted samples
float LeftInputCorrupted; 
float RightInputCorrupted;

// Filtered samples
float LeftOutputFiltered; 
float RightOutputFiltered;




int current = 0;
int t= 0;//this is the real world time used to create noise

// TODO: 0. Define your own global coefficients for filtering
static float F = 460;
static float BW = 0.31415926535;
static float OMG_0 = 0.12036666667;
static float beta = 0.9999977;
static float alpha = 0.726543;


void FilterCoeff(void)
{
	// TODO: 1. Initialise the filter coefficients
	//   You should write this function so the filter centre frequency and
	//   bandwidth can be easily changed.

}


void AddSinus(void)
{
	// TODO: 2. Add the sinusoidal disturbance to the input samples

	LeftInputCorrupted = LeftInput+1e8*sin(OMG_0 *t);
    RightInputCorrupted = RightInput+1e8*sin(OMG_0*t);
    t++;
}


//we are only implementing MONO audio at this stage
float x[4] = {0.0};
float y[2] = {0.0};
float xn, xn_1, xn_2 = 0;
float yn, yn_1, yn_2 = 0;

void NotchFilter(void)
{
	// TODO: 3. Filter the corrupted samples

	//first assign the LeftInputCorrupted as the input x

	//x[n] is just LeftInputCorrupted

	xn = LeftInputCorrupted;

	/*standard way*/
	//y[n] = ((1+alpha)/2) * (x[n] - 2*beta*x[n-1] +x[n-2])
	// + beta*(1+alpha)*y[n-1] - alpha*y[n-2];

	 yn = ((1+alpha)/2) * (xn - 2*beta*xn_1 + xn_2)
	 + beta*(1+alpha)*yn_1 - alpha*yn_2;


	 

	 /*update my stuffs*/
	 xn_2 = xn_1;
	 xn_1 = xn;
	 yn_2 = yn_1;
	 yn_1 = yn;
	 /*output yn*/
	 LeftOutputFiltered = yn;



	 /*
	y[current] =  beta*(1+alpha)*y[current-1] + (1+alpha)/2 * x[current] 
	+  beta*(1+alpha) * x[current] + ((1+alpha)/2)*x[current-2];
	*/

	//((1+alpha)/2)*x[current] - 2*beta*x[current-1] + x[current - 2]
	//+ beta * (1+alpha) * y[current-1] - alpha*y[current-2];


	//after calculation, update stuffs
//	y[current-1] = y[current];//update y
//	x[current-2] = x[current-1];
//	x[current-1] = x[current];

	//output the calculated(filtered) result
	/*LeftOutputFiltered = y[current];
	current++;
	current = current%3;*/

}
