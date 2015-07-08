##############################################################################

###our @P;
our $RAND = 0;

use List::Util 'shuffle';

sub init_perm ($;$)
{
    
    my $Pn = shift;
    $RAND = shift if @_;
    @P = (0..$Pn-1);
}

sub perm ()
{
    if ($RAND)
    {
	return () unless --$RAND;

	# Just shuffle and return
	@P = shuffle @P;
	return @P;
    }

    # E.W.Dijkstra, A Discipline of Programming, Prentice-Hall, 1976, P 71.
    my $i = $#P-1;
    $i-- while ($P[$i] > $P[$i+1]);
    return () if $i < 0;
#  print "oldP=(",join(',',@P),") \$#=",$#P," i down to $i ";
    my $j = $#P;
    $j-- while ($P[$i] > $P[$j]);
#  print "j down to $j\n";
    # Swap P[i] and P[j]
    ($P[$i], $P[$j]) = ($P[$j], $P[$i]);
    $i++;
    $j = $#P;
    while ($j > $i)
    {
	($P[$i], $P[$j]) = ($P[$j], $P[$i]);
	$i++;
	$j--;
    }
#  print "newP=(",join(',',@P),")\n";
    @P;
}

##############################################################################

sub advance_past ($)
{
    my $index = shift;
#  print "advance_past ($index) oldP=(",join(',',@P),")\n";
    return if $index >= $#P-1;
    my @p = ();
    push @p, $P[$_] for ($index+1 .. $#P);
    @P[$index+1..$#P] = sort { $b <=> $a } @p;
#  print "advance_past ($index) newP=(",join(',',@P),")\n";
}

##############################################################################

sub fact ($)
{
    my $n = shift;
    $n > 1 ? $n * fact($n-1) : 1;
}

sub sum ($)
{
    my $n = shift;
    $n > 0 ? $n + sum($n-1) : 0;
}

1;
