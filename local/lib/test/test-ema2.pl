#!/usr/bin/perl

use lib "..";
use ema;
use stats;


# use constant C => 100; # 100 -> 582, 50 -> 288, 30 -> 171, 20 -> 113, 10 -> 55
use constant PI => 3.1415926535;
use constant T => 10000; # overall period to se
use constant CP => 77; # Period of filter.  Too small, CF shifts
use constant CF => T/CP/(2*PI);
use constant FCP => (2*PI)*CP;
use constant F0 => int(CF/3); # Max freq to test
use constant F1 => int(CF*3); # Max freq to test

printf ("Filter Period=%d Implied Cutoff Frequency=%f, Period=%f\n", CP, CF, FCP);

for my $f (F0..F1) {
    my $s = new stats;
    my $e = new ema (1/CP, 0);
    for my $p (0..T) {
	my $x = sin(2*PI*$f*$p/T)/2;
	my $y = $e->filter ($x);
	if ($p > T/2) {
	    $s->add($y);
	}
    }
    printf ("Freq=%d Range=%f\n", $f, $s->range)
}

__END__

my $f = 90;
my $e = new ema (1/CP, 0);
for my $p (0..T) {
    my $x = sin(2*PI*$f*$p/T)/2;
    my $y = $e->filter ($x);
    printf ("%f,%f\n", $x, $y);
}
