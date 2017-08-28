#include "SPWS2-notch.h"

#define SAMPLE_RATE	24000.0
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


// TODO: 0. Define your own global coefficients for filtering


void FilterCoeff(void)
{
	// TODO: 1. Initialise the filter coefficients
	//   You should write this function so the filter centre frequency and
	//   bandwidth can be easily changed.


}


void AddSinus(void)
{
	// TODO: 2. Add the sinusoidal disturbance to the input samples

	LeftInputCorrupted = LeftInput;
    RightInputCorrupted = RightInput;
}

void NotchFilter(void)
{
	// TODO: 3. Filter the corrupted samples

	LeftOutputFiltered = LeftInputCorrupted;
	RightOutputFiltered = RightInputCorrupted;
}
