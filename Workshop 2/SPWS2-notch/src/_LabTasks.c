#include "SPWS2-notch.h"

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
float x[2] = {0.0};
float y[2] = {0.0};
// TODO: 0. Define your own global coefficients for filtering


void FilterCoeff(void)
{
	// TODO: 1. Initialise the filter coefficients
	//   You should write this function so the filter centre frequency and
	//   bandwidth can be easily changed.
	float F = 460;
	float BW = 0.1*PI;
	float OMG_0 = 2*PI*F/SAMPLE_RATE;
	float beta = cos(OMG_0);
	float alpha;
	2*alpha/(1+alpha^2) = cos(BW) ;



}


void AddSinus(void)
{
	// TODO: 2. Add the sinusoidal disturbance to the input samples

	LeftInputCorrupted = LeftInput+sin(OMG_0*current);
    RightInputCorrupted = RightInput+sin(OMG_0*current);
}

void NotchFilter(void)
{
	// TODO: 3. Filter the corrupted samples


//	RightOutputFiltered = RightInputCorrupted;

	y[current] =  LeftInputCorrupted - 2*beta*x[current-1] + x[current - 2] 
	+ beta * (1+alpha) * y[current-1] - alpha*y[current-2];
	
	LeftOutputFiltered = y[current];
	//update buffer
	x[current] = LeftInputCorrupted;
	current++;
	current = current%2;

}
