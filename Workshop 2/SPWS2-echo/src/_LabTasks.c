#include "SPWS2-echo.h"

// Input samples
float LeftInput;
float RightInput;

// Output samples
float loa, lob, loc;

// Declare any global variables you need

void EchoFilter(void)
{
	// TODO: Implement echo filter (a)
	//loa = LeftInput;
	loa = LeftInput + alpha_a * 

	// TODO: Implement echo filter (b)
	lob = LeftInput;

	// TODO: Implement echo filter (c)
	loc = LeftInput;

	//update the sample 
	
}
