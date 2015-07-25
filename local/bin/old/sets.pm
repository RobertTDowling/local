# Sets are bit masks (ints)
# Memebers are lists
# SOS are lists: sets of sets

sub set2members ($)
{
    my $set = shift;
    my $mask = 1;
    my @members = ();
    for (0..$N-1)
    {
	push @members, $_ if $mask & $set;
	$mask *= 2;
    }
    @members;
}

sub list2str (@)
{
    "(".join (' ', @_).")";
}

sub set2str ($)
{
    "(".join(' ', set2members($_[0])).")";
}

sub sos2str (@)
{
    join (', ', map { set2str($_) } @_);
}

sub intersect
{
#    print "intersecting:",sos2str(@_);
    my $a = shift || 0;
#    print " was ",set2str ($a),"\n";
    $a = $a & $_ for (@_);
#    print " is ",set2str ($a),"\n";
    $a;
}

sub union
{
    my $a = shift || 0;
    $a |= $_ for (@_);
    $a;
}

# (1,2) >{contains} (2)
sub contains ($$)
{
    $_[1] == intersect ($_[0], $_[1]);
}

# Give an SOS, if one set is a subset of another, just keep bigger one
sub eliminate_subsets (@)
{
    my @sos = @_;
    # Eliminate subsets
    for my $a (@sos)
    {
	for my $b (@sos)
	{
	    next if $a == $b;
	    $a = 0 if contains ($b, $a);
	}
    }
    grep {$_} @sos;
}

1;
