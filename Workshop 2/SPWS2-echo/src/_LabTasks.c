#include "SPWS2-echo.h"

// Input samples
float LeftInput;
float RightInput;

// Output samples
float loa, lob, loc;

// Declare any global variables you need
int D = 1760;
float alpha_a  = 0.75;
float x[D] = {0.0};
int current = 0;


void EchoFilter(void)
{
	// TODO: Implement echo filter (a)
	//loa = LeftInput;
	loa = LeftInput + alpha_a * x[current];

	// TODO: Implement echo filter (b)
	lob = LeftInput;

	// TODO: Implement echo filter (c)
	loc = LeftInput;

	//update the sample 
	x[current] = LeftInput;
	current++;
	current = current%4;
}
