#!/usr/bin/perl

open (FIN, "find . -type f|") || die;
while (<FIN>) {
    $files ++;
    chomp;
    $t += -s;
    $c += -s, next if /\.java$/;
    $c += -s, next if /\.c$/;
    $c += -s, next if /\.cpp$/;
    $h += -s, next if /\.h$/;
    $doc += -s, next if /\.pdf$/;
    $doc += -s, next if /\.txt$/;
    $doc += -s, next if /\.xml$/;
    $doc += -s, next if /\.html$/;
    $doc += -s, next if /\.htm$/;
    $make += -s, next if /\*.sh/;
    $make += -s, next if /proj/;
    $make += -s, next if /[Mm]ake/;
}

printf ("Files: %d\n", $files);
printf ("  C Files:   %7.3fM\n", $c/1e6);
printf ("  H Files:   %7.3fM\n", $h/1e6);
printf ("  Makefiles: %7.3fM\n", $make/1e6);
printf ("  Doc Files: %7.3fM\n", $doc/1e6);
printf ("  Total:     %7.3fM\n", $t/1e6);
