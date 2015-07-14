package histo;

# Minimal statistics
#
'(C) Copyright 2010-2015 Robert Dowling.';
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
# Usage
#
# $o = new histo;
# $o->add (1);
# $o->add (2);
# $o->add (3);
# print "N=",$o->N, "\n";
# print "min=",$o->min, "\n";
# print "max=",$o->max, "\n";
# print "buckets of 5:", join(',' $o->buckets(5)), "\n";

require Exporter;
our @ISA = qw(Exporter); 
our @EXPORT = qw(new N add min max buckets);

sub new
{
    my $self = {};
    $self->{x} = [];
    bless $self;
    $self;
}

sub N ()
{
    my $self = shift;
    scalar (@{$self->{x}});
}

sub add ($)
{
    my $self = shift;
    my $x = shift;
    $self->{MAX}=$x if !$self->N || $self->{MAX}<$x;
    $self->{MIN}=$x if !$self->N || $self->{MIN}>$x;
    push @{$self->{x}}, $x;
}

sub min ()
{
    my $self = shift;
    $self->N ? $self->{MIN} : "?";
}

sub max ()
{
    my $self = shift;
    $self->N ? $self->{MAX} : "?";
}

sub mean ()
{
    my $self = shift;
    return 0 unless $self->N;
    my $sum; $sum += $_ for (@{$self->{x}});
    $sum / $self->N;
}

sub median ()
{
    my $self = shift;
    my $n = $self->N;
    return 0 unless $n;
    my @s = sort {$a<=>$b} (@{$self->{x}});
    return $s[$n/2] if @s & 1;
    return ($s[$n/2]+$s[1+$n/2])/2;
}

sub median_pct ($)
{
    my $self = shift;
    my $pct = shift;
    my $n = $self->N;
    return 0 unless $n;
    my @s = sort {$a<=>$b} (@{$self->{x}});
    $pct >= 1 ? $s[-1] : $s[$n*$pct];
}

sub percentile ($)
{
    my $self = shift;
    my $target = shift;
    my $n = $self->N;
    return (0,0) unless $n>1;
    my @s = sort {$a<=>$b} (@{$self->{x}});
    my $lo, $hi;
    for (0..$#s)
    {
	$lo = $_ if $s[$_] == $target && !defined $lo;
	$hi = $_ if $s[$_] == $target;
    }
    return (int(100*$lo/($n-1)), int(100*$hi/($n-1)+.99));
}

sub buckets ($)
{
    my $self = shift;
    my $width = shift;
    my @b = ();
    $b[$_/$width]++ for (@{$self->{x}});
    @b;
}

sub mode ()
{
    my $self = shift;
    my $n = $self->N;
    return 0 unless $n;
    my %s;
    $s{$_}++ for (@{$self->{x}});
    my @s = sort {$s{$a}<=>$s{$b}} keys %s;
    return $s[-1];
}

sub modeN ()
{
    my $self = shift;
    my $n = $self->N;
    return 0 unless $n;
    my %s;
    $s{$_}++ for (@{$self->{x}});
    my @s = sort {$s{$a}<=>$s{$b}} keys %s;
    return $s{$s[-1]};
}

sub show_buckets ()
{
    my $self = shift;
    my $width = shift;
    my @b = $self->buckets($width);
    for (0..$#b)
    {
	printf ("%4d-%4d: %4d\n", $_*$width, $_*$width+$width-1, $b[$_]);
    }
}

sub show_nz_buckets () # Non Zero Buckets
{
    my $self = shift;
    my $width = shift;
    my @b = $self->buckets($width);
    for (0..$#b)
    {
	next unless $b[$_];
	printf ("%4d-%4d: %4d\n", $_*$width, $_*$width+$width-1, $b[$_]);
    }
}

# self->show_buckets_range (low, high, width)
sub show_buckets_range ()
{
    my ($self, $low, $high, $width) = @_;
    my @b = $self->buckets($width);
    for ($low/$width..$high/$width)
    {
	printf ("%4d-%4d: %4d\n", $_*$width, $_*$width+$width-1, $b[$_]);
    }
}

1;
__END__

=head1 NAME

histo - perl library for simple histogram statistics

=head1 SYNOPSIS

 use histo;

 $o = new histo;
 $o->add (1);
 $o->add (2);
 $o->add (3);
 print "N=",$o->N, "\n";
 print "min=",$o->min, "\n";
 print "max=",$o->max, "\n";
 print "buckets of 5:", join(',' $o->buckets(5)), "\n";

=head1 DESCRIPTION

The B<histo> library calculates simple histogram statistics.

The B<histo> library is even less of a drop-in replacement for the
B<stats> library than B<stats34> is, because it has the overhead of
maintaining the entire set of data in order to perform the histogram
bucket computations.  But it is worth looking at B<man stats> to see
where this came from.

=over

=item new histo

Construct a new B<histo> object.  It contains all the information
necessary to compute histogram statistics on one set of data.  If you
want to analyze multiple sets of data, create multiple objects.

=item add (x)

Add value B<x> to the set.  This will increase B<N> by 1

=item N

Return the number of items in the set.  When constructed, the set
contains no values.

=item min ()

=item max ()

Return the extreme values of the set, or "?" if the set is empty

=item mean ()

Return the B<mean> value of the set, or "?" if the set is empty

=item mode (w)

Return the B<mode> of the set, value in the set which appears the most
often, or one of the values if several are tied.

=item modeN (w)

Return the count of the elements that are the B<mode> of the set.

=item median ()

Return the "center value" of the sorted set.  By definition, the
B<median> of a set with a even number of elements is the average of
the two center-most elements.  For sets with an odd number of elements,
the B<median> is always an element of the set, unlike B<mean>

=item median_pct (p)

Return the value of B<q>'th element, where B<q>=B<floor>(B<N>*B<p>)
and B<p> is a number in the range [0..1).

B<Median> = B<median_pct> (0.5) for a set with a odd number of
elements.  (Hopefully!)

=item ($first, $last) = percentile (target)

Return the positions (as a percent) in the sorted set of values of the
B<first> and B<last> values in the set that are equal to the B<target>
value.

=item @b = buckets (w)

Return a list B<@b> of buckets of width B<w> that form a histogram.
For example, if B<w>=5, then B<$b[0]> will have the count of values in
the set that are in the range 0..4, and B<$b[1]> will have the count
for 5..9, and so on.

=item show_buckets (w)

Compute B<buckets(w)> and print out the histogram as a table.

=item show_nz_buckets (w)

Compute B<buckets(w)> and print out the histogram as a table, showing
only buckets with non-zero counts.

=item show_bucket_range (low, high, w)

Compute B<buckets(w)> and print out the histogram as a table, showing
only buckets from B<low> to B<high>.

=back

=head1 SEE ALSO

stats(3), stats34(3), perm(3), sets(3), normaldist(3), Stats(3), Histo(3)

=head1 AUTHOR

Robert Dowling <F<RPNCalcN@gmail.com>>.

=cut
