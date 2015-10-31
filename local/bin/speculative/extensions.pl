#!/usr/bin/perl

open (FIN, "find . -type f|") || die;
while (<FIN>) {
    $files ++;
    chomp;
    $t += -s;
    if (/\.\S+(\.[^.]+)$/) {
	$X{$1}++;
    }
}

printf ("Files: %d\n", $files);
for (sort { $X{$a} <=> $X{$b} } keys %X) {
    printf ("%7d %s\n", $X{$_}, $_);
}
