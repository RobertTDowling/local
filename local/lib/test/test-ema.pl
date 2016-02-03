#!/usr/bin/perl

use lib "..";
use ema;

use constant N => 20;

$e[$_] = new ema (1/$_, 0) for (1..N);

for $i (1..N) {
    printf (" %5.3f", $e[$_]->filter(1)) for (1..N);
    print "\n";
}

printf ("expect a diagonal line where values straddle 1-exp(-1)=%.6f\n",
	1-exp(-1));

__END__
