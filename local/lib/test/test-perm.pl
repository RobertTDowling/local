#!/usr/bin/perl

use lib "..";
use perm;

$p = new perm;

@p = $p->init (3);
do {
    print join(',', @p), "\n";
    @p = $p->next;
} while (@p);

printf ("4 factorial is %d\n", fact(4));
