#!/bin/sh

here=${PWD}
cd ../lib
fgrep -l "=head1" *.pm | while read file; do
    m=$(basename $file .pm).3
    pod2man $file > ${here}/$m
done
cd ${here}

cd ../bin
fgrep -l "=head1" * | while read file; do
    pod2man $file > ${here}/${file}.1
done
cd ${here}

mv *.3 ../man/man3
mv *.1 ../man/man1
