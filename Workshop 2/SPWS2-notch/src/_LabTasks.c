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
int t= 0;
float x[2] = {0.0};
float y[2] = {0.0};
// TODO: 0. Define your own global coefficients for filtering
float F = 460;
float BW = 0.31415926535;
float OMG_0 = 0.12036666667;
float beta = 0.9999977;
float alpha = 0.726543;
//	2*alpha/(1+alpha^2) = cos
//	2*alpha/(1+alpha^2) = cos

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

void NotchFilter(void)
{
	// TODO: 3. Filter the corrupted samples


//	RightOutputFiltered = RightInputCorrupted;
	x[current] = LeftInputCorrupted;

	y[current] =  x[current] - 2*beta*x[current-1] + x[current - 2]
	+ beta * (1+alpha) * y[current-1] - alpha*y[current-2];

	LeftOutputFiltered = y[current];
	//update buffer
	
	current++;
	current = current%3;

}
