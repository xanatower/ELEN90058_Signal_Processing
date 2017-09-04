#include "SPWS2-echo.h"

// Input samples
float LeftInput;
float RightInput;

// Output samples
float loa, lob, loc;

// Declare any global variables you need
int D = 1760;
float alpha_a  = 0.75;
float alpha_b = 0.6;
float alpha_c = 0.75;
float x[1760] = {0.0};
float y_b[1760] = {0.0};
float y_c[1760] = {0.0};
int current = 0;


void EchoFilter(void)
{
	// TODO: Implement echo filter (a)
	//loa = LeftInput;
	//y[n] = x[n] + alpha*x[current] becuase x[current] is from the last sample period
	loa = LeftInput + alpha_a*x[current];

	//y_b[]
	y_b[current] = LeftInput - alpha_b * y_b[current];
	// TODO: Implement echo filter (b)
	lob = y_b[current];
	//lob = LeftInput;

	y_c[current] = x[current] - alpha_c * LeftInput + alpha_c*y_c[current];
	// TODO: Implement echo filter (c)
	loc = y_c[current];

	//update the sample 
	x[current] = LeftInput;
	y2[current] = lob;
	current++;
	//printf("%d\n", current);
	current = current%1760;
}

