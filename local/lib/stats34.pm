package stats;

# Minimal statistics
#
'(C) Copyright 2015 Robert Dowling.';
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
# $o = new stats;
# $o->add (1);
# $o->add (2);
# $o->add (3);
# print "N=",$o->N, "\n";
# print "mean=",$o->mean, "\n";
# print "stdev=",$o->stdev, "\n";
# print "min=",$o->min, "\n";
# print "max=",$o->max, "\n";

require Exporter;
our @ISA = qw(Exporter); 
our @EXPORT = qw(new add mean stdev sum N min max);

sub new
{
    my $self = {};
    $self->{N} = 0;
    $self->{SX} = 0;
    $self->{SXX} = 0;
    $self->{SXXX} = 0;
    $self->{SXXXX} = 0;
    bless $self;
    $self;
}

sub N ()
{
    my $self = shift;
    $self->{N};
}

sub sum ()
{
    my $self = shift;
    $self->{SX};
}

sub add ($)
{
    my $self = shift;
    my $x = shift;
    $self->{N}++;
    $self->{SX}+=$x;
    $self->{SXX}+=$x*$x;
    $self->{SXXX}+=$x*$x*$x;
    $self->{SXXXX}+=$x*$x*$x*$x;
    $self->{MAX}=$x if $self->{N}==1 || $self->{MAX}<$x;
    $self->{MIN}=$x if $self->{N}==1 || $self->{MIN}>$x;
}

sub mean ()
{
    # Mean = u = E[x] = SX/N
    my $self = shift;
    $self->{N} ? $self->{SX}/$self->{N} : "?";
}

sub var () # Population variance.  For Sample, somehow subtract 1 from numerator
{
    # Var = E[(x-u)^2] = E[x^2] - 2 u E[x^2] + N u^2
    # Var = (1/N) Sum[x^2] - (1/N) 2 u Sum[x] + (1/N) N u^2
    #     = SXX/N - SX/N * SX/N
    my $self = shift;
    $self->{N} ? 
	($self->{SXX}-$self->{SX}*$self->{SX}/$self->{N})/$self->{N}
	: "?";
}

sub stdev () # Sample Stdev.  For Population, don't -1 at end
{
    # Stdev = s = Sqrt(Var)
    my $self = shift;
    $self->{N} > 1 ?
	sqrt (($self->{SXX}-$self->{SX}*$self->{SX}/$self->{N})/($self->{N}-1))
	: "?";
}

sub skew ()
{
    # Skewness = E[(x-u)^3] / E[(x-u)]^(3/2)
    # Skewness = (1/N) Sum[(x-u)^3] / (1/N^(3/2)) Sum[(x-u)]^(3/2)
    # Skewness = Sqrt(N) Sum[(x-u)^3] / Sum[(x-u)]^(3/2)
    my $self = shift;
    my $u = $self->{SX} / $self->{N};
    $self->{N} ?
	$self->{N}**0.5 *
	(      $self->{SXXX}
	 - 3 * $self->{SXX} * $u
	 + 3 * $self->{SX} * $u**2
	 -     $self->{N} * $u**3
	)/(      $self->{SXX}
	   - 2 * $self->{SX} * $u
	   + $self->{N} * $u**2)**1.5
     	: "?";
}

sub kurt ()
{
    # Kurtosis = E[(x-u)^4] / E[(x-u)^2]^2
    # Kurtosis = (1/N) Sum[(x-u)^4] / (1/N)^2 Sum[(x-u)^2]^2
    # Kurtosis = N Sum[(x-u)^4] / Sum[(x-u)^2]^2
    my $self = shift;
    my $u = $self->{SX} / $self->{N};
    $self->{N} ?
	$self->{N} *
	(      $self->{SXXXX}
	 - 4 * $self->{SXXX} * $u
	 + 6 * $self->{SXX} * $u**2
	 - 4 * $self->{SX} * $u**3
	 +     $self->{N} * $u**4
	)/(      $self->{SXX}
	   - 2 * $self->{SX} * $u
	   + $self->{N} * $u**2)**2
     	: "?";
}

sub min ()
{
    my $self = shift;
    $self->{N} ? $self->{MIN} : "?";
}

sub max ()
{
    my $self = shift;
    $self->{N} ? $self->{MAX} : "?";
}

1;
__END__

=head1 NAME

stats34 - perl library for simple statistics including skewness and kurtosis

=head1 SYNOPSIS

 use stats34;

 $o = new stats;
 $o->add (1);
 $o->add (2);
 $o->add (3);
 print "N=",$o->N, "\n";
 print "mean=",$o->mean, "\n";
 print "stdev=",$o->stdev, "\n";
 print "skewness=",$o->skew, "\n";
 print "kurtosis=",$o->kurt, "\n";
 print "min=",$o->min, "\n";
 print "max=",$o->max, "\n";

=head1 DESCRIPTION

The B<stats34> library calculates simple statistics in the fashion of
a handheld calculator.  All input and return values are floating
point.

The B<stats34> library is mostly a drop-in replacement for the
B<stats> library, with the added overhead necessary to compute the 3rd
and 4th standardized moments, skewness and kurtosis.  It is worth
looking at B<man stats> to see where this came from.

Briefly, B<skewness> is how lopsided a distribution is.  For a normal
distribution of standard deviation 1.0 around the mean 0.0, B<skew> is
0.  A negative B<skew> indicates the tail on the left side is longer
or fatter than the right; a positive B<skew> indicates the opposite.

Briefly, B<Kurtosis> is how sharp or broad the peak is.  For a normal
distribution of standard deviation 1.0 around the mean 0.0, B<kurt> is
zero.  A negative B<kurt> indicates a flatter peak; positive
indicates sharper.

=over

=item new stats

Construct a new B<stats34> object.  (Note, the class is still called
B<stats> to retain compatibility with the perl B<stats> library.)  It
contains all the information necessary to compute statistics on one
set of data.  If you want to analyze multiple sets of data, create
multiple objects.

=item add (x)

Add value B<x> to the set.  This will increase B<N> by 1

=item N

Return the number of items in the set.  When constructed, the set
contains no values.

=item sum

Return the sum of all the numbers in the set.

=item mean

Return the mean value of the set, or "?" if the set is empty

=item stdev

Return the sample standard deviation of the set, or "?" if the set
does not have 2 or more items.

=item skew

Return the skewness of the set, or "?" if the set is empty

=item kurt

Return the excess kurtosis of the set, or "?" if the set is empty

=item min

=item max

Return the extreme values of the set, or "?" if the set is empty

=back

=head1 SEE ALSO

stats(3), histo(3), perm(3), sets(3), normaldist(3), Stats(3), Histo(3)

=head1 AUTHOR

Robert Dowling <F<RPNCalcN@gmail.com>>.

=cut
