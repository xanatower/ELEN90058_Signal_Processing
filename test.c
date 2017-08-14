#include <stdio.h>
#include <math.h>

// Globals
#define N	256
#define	PI	3.1415

float x[N];
float h[N];
float XK[N];
float y[N];
float t[N];
int main(void)
{

	int i;
	float omega1 = 0.25 * PI, omega2 = 1.9 * PI;
	float T = 1/4.8;
	float a=0.12;
	float alpha1 = 0.593, alpha2 = 0.464;


	//x[0]  = exp(-a*0*T2)*cos(omega1*0*T2) + 0.1*sin(omega2*0*T2);
	x2[0]  = 0.1*sin(omega2*0*T2);
	y1[0] = ((1-alpha1)/2)*x2[0];
	y2[0] = ((1-alpha2)/2)*y1[0];
	for (i = 0; i < N; i++)
	{
		//x[i] = exp(-a*i*T2)*cos(omega1*i*T2) + 0.1*sin(omega2*i*T2);
		x2[0]  = 0.1*sin(omega2*i*T2);
		y1[i] = ((1-alpha1)/2)*x2[i]+((1-alpha1)/2)*x2[i-1]+alpha1*y1[i-1];
    	y2[i] = ((1-alpha2)/2)*y1[i]+((1-alpha2)/2)*y1[i-1]+alpha2*y2[i-1];
	}

	/*for (i = 0; i < N; i++)
	{
		printf("x[%d] = %f\n", i, x[i]);
	}
*/
	printf("Done.\n");

	return 0;
}
