#!/usr/bin/perl

# Compute Backup Storage Requirements.
#
# Run from current directory to get du-like output in MB, with
# commentary on what is not compressible and should not be archived
# along with everything else.
#
# Prune off anything less than 10MB

# chdir ($ENV{HOME}); #  . "/local/bin/speculative/testdir");
open (FIN, "find . -type f |") || die;
while (<FIN>) {
    chomp;
    s/^\.\///;
    $s = -s $_;
    $S{$_} = $s;
    $I{$_} = $s if /\.(?:zip|gz|mp3|ogg|png|jpg|mp4)$/i;
    $F{$_} = "F";
    add_to_pathof ($_, $S{$_}, $I{$_});
}

sub add_to_pathof ($$$)
{
    my ($file, $size, $isize) = @_;
    ($path, $base) = $file =~ /^(.*)\/([^\/]+)$/;
    $T{$file}++, return unless $path;
    $S{$path} += $size;
    $I{$path} += $isize;
    add_to_pathof ($path, $size, $isize);
}

# for (sort { $S{$a} <=> $S{$b} } keys %S) {
printf ("%10s %10s\n", 'Total MB', 'Uncmp-able');
for (sort { $S{$a} <=> $S{$b} } keys %T) {
    next unless $S{$_} > 1e7;
    printf ("%10.3f %10.3f %1s %s\n", $S{$_}/1e6, $I{$_}/1e6, $F{$_}, $_);
    # printf ("%13.0f %1s %s\n", $S{$_}/1024, $F{$_}, $_);
}
