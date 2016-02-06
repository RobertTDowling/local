#!/usr/bin/perl

use lib $ENV{HOME}."/local/lib";
use ema;
use stats;
use leastsquares;


# use constant C => 100; # 100 -> 582, 50 -> 288, 30 -> 171, 20 -> 113, 10 -> 55
use constant PI => 3.1415926535;
use constant T => 10000; # overall period to se
use constant CP => 77; # Period of filter.  Too small, CF shifts
use constant CF => T/(CP*(2*PI));  # T / (2PiCp)
use constant FCP => (2*PI)*CP;	   # 2PiCp
use constant F0 => int(CF/3); # Max freq to test
use constant F1 => int(CF*3); # Max freq to test

printf ("Filter Period=%d Implied Cutoff Frequency=%f, Period=%f\n", CP, CF, FCP);
my $e = new ema (1/CP, 0);

printf ("Filter Period=%d Implied Cutoff Frequency=%f, Period=%f\n", CP,
	$e->cutoff_frequency(T), $e->cutoff_period);

for my $f (F0..F1) {
    my $s = new stats;
    my $e = new ema (1/CP, 0);
    my $l0 = new leastsquares;
    my $l1 = new leastsquares;
    my $c0 = 0;
    my $c1 = 0;
    for my $p (0..T) {
	my $x = 2*PI*$f*$p/T;
	my $y0 = sin($x)/2;
	my $y1 = $e->filter ($y0);
	if ($p > T/4) {
	    $s->add($y1);
	    if ($ly1 > $lly1 && $ly1 > $y1) {
		$l1->add($c1++, $p-1);
	    }
	    if ($ly0 > $lly0 && $ly0 > $y0) {
		$l0->add($c0++, $p-1);
	    }
	}
	($lly1,$ly1) = ($ly1,$y1);
	($lly0,$ly0) = ($ly0,$y0);
    }
    printf ("Freq=%d Range=%f ", $f, $s->range);
    # printf ("0: m=%f b=%f (N=%d)", $l0->m, $l0->b, $l0->N);
    # printf ("1: m=%f b=%f (N=%d)\n", $l1->m, $l1->b, $l1->N);
    # T/$f = one cycle
    printf ("Expected phase=%.2f (%.2f) ",
	    57.29578*$e->phase_delay($f,T),
	    $e->phase_delay_samples($f,T));
    printf ("Phase=%.2f (%.2f) (N=%d)\n",
	    360*($l1->b-$l0->b)/(T/$f),
	    ($l1->b-$l0->b), $l1->N);
}

__END__

my $f = 90;
my $e = new ema (1/CP, 0);
for my $p (0..T) {
    my $x = sin(2*PI*$f*$p/T)/2;
    my $y = $e->filter ($x);
    printf ("%f,%f\n", $x, $y);
}
