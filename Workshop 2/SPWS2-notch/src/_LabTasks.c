#include "SPWS2-notch.h"
#include "math.h"
#define SAMPLE_RATE 24000.0
#define PI 3.14159265359
#define BUFFER_SIZE     2
//define the buffer size

#define INDEX(CURRENT)  ((CURRENT) + BUFFER_SIZE) % BUFFER_SIZE

// Input samples
float LeftInput; 
float RightInput;

// Corrupted samples
float LeftInputCorrupted; 
float RightInputCorrupted;

// Filtered samples
float LeftOutputFiltered; 
float RightOutputFiltered;



static float xBufferL[BUFFER_SIZE] = {0.0};
//static float xBufferR[BUFFER_SIZE] = {0.0};
// input buffer (Left and Right)

static float yBufferL[BUFFER_SIZE] = {0.0};



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


void NotchFilter(void)
{
	static current = 0;

	LeftOutputFiltered = ((1+alpha)/2)*LeftInputCorrupted - 2*beta*((1+alpha)/2)*xBufferL[INDEX(current-1)]+
	((1+alpha)/2)*xBufferL[INDEX(current-2)] + beta*(1+alpha)*yBufferL[INDEX(current-1)]
	-alpha*yBufferL[INDEX(current-2)];


	xBufferL[current] = LeftInputCorrupted;
	yBufferL[current] = LeftOutputFiltered;

	current++;
    current = current % BUFFER_SIZE;
	 

	 /*yn = ((1+alpha)/2) * (xn - 2*beta*xn_1 + xn_2)
	 + beta*(1+alpha)*yn_1 - alpha*yn_2;*/

}
