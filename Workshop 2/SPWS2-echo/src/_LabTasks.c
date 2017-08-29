#include "SPWS2-echo.h"

// Input samples
float LeftInput;
float RightInput;

// Output samples
float loa, lob, loc;

// Declare any global variables you need
int D = 1760;
float alpha_a  = 0.75;
float alpha_b = 0.75;
float x[1760] = {0.0};
float y2[1760] = {0.0};
int current = 0;


void EchoFilter(void)
{
	// TODO: Implement echo filter (a)
	//loa = LeftInput;
	//y[n] = x[n] + alpha*x[current] becuase x[current] is from the last sample period
	loa = LeftInput + alpha_a*x[current];

	// TODO: Implement echo filter (b)
	lob = LeftInput - alpha_b*y2[current];
	//lob = LeftInput;

	// TODO: Implement echo filter (c)
	loc = LeftInput;

	//update the sample 
	x[current] = LeftInput;
	y2[current] = lob;
	current++;
	//printf("%d\n", current);
	current = current%1760;
}
