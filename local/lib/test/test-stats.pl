#!/usr/bin/perl

use lib "..";
# use lib "/home/rob/comp-sci/stat";
use stats;

sub doit () {
    printf "N=%s mean=%s stdev=%s min=%s max=%s\n",
	$o->N, $o->mean, $o->stdev, $o->min, $o->max;
}

$o = new stats;
$o->add (1); doit();
$o->add (2); doit();
$o->add (3); doit();
$o->add (4); doit();

__END__
These values are tested against octave

N=1 mean=1 stdev=? min=1 max=1
N=2 mean=1.5 stdev=0.707106781186548 min=1 max=2
N=3 mean=2 stdev=1 min=1 max=3
N=4 mean=2.5 stdev=1.29099444873581 min=1 max=4
