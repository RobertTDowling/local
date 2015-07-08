#include <stdio.h>
int median3 (int f1, int f2, int f3)
{
    int f=0;
    if (f1 < f2)
		if (f2 < f3)
			f = f2;
		else if (f1 < f3)
			f = f3;
		else
			f = f1;
    else
		if (f3 < f2)
			f = f2;
		else if (f1 < f3)
			f = f1;
		else
			f = f3;
    return f;
}

int main (int c, char **v)
{
	int i,j,k;
    for (i=0; i<3; i++)
	for (j=0; j<3; j++)
		//	    if (i!=j)
		for (k=0; k<3; k++)
			//		    if (i!=k && j!=k)
			printf ("m3 %d,%d,%d = %d\n", i,j,k, median3(i,j,k));
}

