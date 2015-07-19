#include "Stats.h"
#include <stdio.h>


void doit (CStats &o) {
	printf ("N=%.0f mean=%.1f stdev=%f min=%.0f max=%.0f\n",
		o.N(), o.Mean(), o.Stdev(), o.Min(), o.Max());
}

int main (int c, const char **v) {
	CStats o;
	o.Add (1); doit(o);
	o.Add (2); doit(o);
	o.Add (3); doit(o);
	o.Add (4); doit(o);
	return 0;
}
/*
These values are tested against octave

N=1 mean=1 stdev=? min=1 max=1
N=2 mean=1.5 stdev=0.707106781186548 min=1 max=2
N=3 mean=2 stdev=1 min=1 max=3
N=4 mean=2.5 stdev=1.29099444873581 min=1 max=4
*/
