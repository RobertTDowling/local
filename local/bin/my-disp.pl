#!/usr/bin/perl

open (FOUT, ">$ARGV[0]") or die;
print FOUT ("digraph foo {\n");
print FOUT ("node [ shape=none fontname=Helvetica fontsize=8 ]\n");
print FOUT ("edge [ dir=none style=dotted ]\n");
print FOUT ("rankdir=BT\n");
# print FOUT ("nodesep=0.25 ranksep=0.25\n");
# print FOUT ("splines=polyline\n");

$REF = 0;
open (FIN, "git for-each-ref|") or die;
while (<FIN>)
{
    # 6953fce3e94a995cb5e5fc51c31728e5998e0c9c commit	refs/heads/master
    if (/(\S+)\s+(commit|tag)\s+(\S+)/) {
	$REF++;
	my ($c, $n) = ($1, $3);
	$n =~ s:refs/[^/]+/::;
	$n =~ s:(.+/)([^/]+)$:\1\n\2:;
	# $n =~ s:origin/:origin/\n:;
	printf FOUT ("\"%7.7s\" [ shape=box label=\"%s\n%7.7s\" ]\n",
		     $c, $n, $c);
	# printf FOUT ("{ rank=same \"%7.7s\" -> \"%s\" [dir=back] }\n", $c, $n);
	# printf FOUT ("\"%s\" [ shape=ellipse ]\n", $n);
	# printf FOUT ("\"%7.7s\" -> \"%s\" [weight=1 dir=back]\n", $c, $n);
	$master = $c if $n eq "master";
    }
}
close FIN;


# Just output
# open (FIN, "git rev-list --all --parents|") or die;
# while (<FIN>)
# {
#     ($l, @r) = split;
#     printf FOUT ("\"%7.7s\" -> \"%7.7s\"\n", $_, $l) for (@r);
# }
# print FOUT "}";

# Get parentage data
$P=0; $L=0;
open (FIN, "git rev-list --all --parents|") or die;
while (<FIN>)
{
    $L++;
    ($l, @r) = split;
    $P++, push @{$P{$l}}, $_ for (@r);
}

print "REF=$REF L=$L P=$P \n";

# Wow! 20,000,000 inerations when $REF=24 and $L=387, $P=412
# $N = 0;
# push @hopper, $master;
# while (@hopper)
# {
#     my $n = shift @hopper;
#     if ($P{$n}) {
# 	$N++;
# 	$COM{$n}++;
# 	push @hopper, @{$P{$n}};
#     }
# }
# printf ("$N\n");

# This one only has 302 iterations
$N = 0;
push @hopper, $master;
while (@hopper)
{
    my $n = shift @hopper;
    if ($P{$n} && !$COM{$n}) {
	$N++;
	$COM{$n}++;
	push @hopper, @{$P{$n}};
    }
}
printf ("$N\n");

for $l (keys %P)
{
    my @r = @{$P{$l}};
    $extra = $COM{$l} ? "[ style=solid ]" : "";

    printf FOUT ("\"%7.7s\" -> \"%7.7s\" $extra\n", $_, $l) for (@r);
}
print FOUT "}";

exit 0;
