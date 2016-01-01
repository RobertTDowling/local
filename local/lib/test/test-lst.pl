#!/usr/bin/perl

 use lib "..";
 use leastsquares;

 $o = new leastsquares;
 $o->add (0,0);
 $o->add (1,0);
 $o->add (2,1);
 $o->add (3,1);
 print "N=",$o->N, " expect 4\n";
 print "m=",$o->m, " expect 0.4\n";
 print "b=",$o->b, " expect -0.1\n";

 $o->add (1,1);
 $o->add (2,0);
 print "N=",$o->N, " expect 6\n";
 print "m=",$o->m, " expect 0.2727\n";
 print "b=",$o->b, " expect 0.0909\n";
