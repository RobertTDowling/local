#!/usr/bin/perl

use lib "..";
# use lib "/home/rob/comp-sci/stat";
use histo;

sub doit () {
    printf "N=%s mean=%s min=%s max=%s mean=%s median=%s median(.25)=%s pct(.9)=%s\n",
	$o->N, $o->min, $o->max, $o->mean, $o->median,
	$o->median_pct (.25), $o->percentile (0.90);
}

$o = new histo;
$o->add (1); doit();
$o->add (2); doit();
$o->add (3); doit();
$o->add (4); doit();

__END__
These values are tested against octave

