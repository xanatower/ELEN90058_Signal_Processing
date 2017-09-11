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


static float xnL = 0;
static float xn_1L = 0;
static float xn_2L = 0;
static float ynL = 0;
static float yn_1L = 0;
static float yn_2L = 0;

static float xnR = 0;
static float xn_1R = 0;
static float xn_2R = 0;
static float ynR = 0;
static float yn_1R = 0;
static float yn_2R = 0;

static int A = 1e9;//amplititude of disturbance
static float F = 460;
static float BW = 0.31415926535;
static float OMG_0 = 0.12036666667;
static float beta;
static float alpha;


void FilterCoeff(void)
{
	// TODO: 1. Initialise the filter coefficients
	//   You should write this function so the filter centre frequency and
	//   bandwidth can be easily changed.

	alpha = 0.726543; // these are calculated by hand before
	beta = 0.9999977;


}


void AddSinus(void)
{
	// TODO: 2. Add the sinusoidal disturbance to the input samples
	LeftInputCorrupted = LeftInput+A*sin(OMG_0 *t);
    RightInputCorrupted = RightInput+A*sin(OMG_0*t);
    t++;
}




void NotchFilter(void)
{
	
	xnL = LeftInputCorrupted;
	xnR = RightInputCorrupted;

	ynL = ((1+alpha)/2) * (xnL - 2*beta*xn_1L + xn_2L)
	 + beta*(1+alpha)*yn_1L - alpha*yn_2L;

	ynR = ((1+alpha)/2) * (xnR - 2*beta*xn_1R + xn_2R)
	 + beta*(1+alpha)*yn_1R - alpha*yn_2R;

	 LeftOutputFiltered = ynL;
	 RightOutputFiltered = ynR;

	 //update the values
	 //Left channel
	 xn_2L = xn_1L;
	 xn_1L = xnL;
	 yn_2L = yn_1L;
	 yn_1L = ynL;

	 //right channel
	 xn_2R = xn_1R;
	 xn_1R = xnR;
	 yn_2R = yn_1R;
	 yn_1R = ynR;

	 /*yn = ((1+alpha)/2) * (xn - 2*beta*xn_1 + xn_2)
	 + beta*(1+alpha)*yn_1 - alpha*yn_2;*/

}
