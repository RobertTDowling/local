package stats;

# Minimal statistics
#
'(C) Copyright 2005-2016 Robert Dowling.';
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
    $self->{MAX}=$x if $self->{N}==1 || $self->{MAX}<$x;
    $self->{MIN}=$x if $self->{N}==1 || $self->{MIN}>$x;
}

sub mean ()
{
    my $self = shift;
    $self->{N} ? $self->{SX}/$self->{N} : "?";
}

sub stdev ()
{
    my $self = shift;
    $self->{N} > 1 ?
	sqrt (($self->{SXX}-$self->{SX}*$self->{SX}/$self->{N})/($self->{N}-1))
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

stats - perl library for simple statistics

=head1 SYNOPSIS

 use stats;

 $o = new stats;
 $o->add (1);
 $o->add (2);
 $o->add (3);
 print "N=",$o->N, "\n";
 print "mean=",$o->mean, "\n";
 print "stdev=",$o->stdev, "\n";
 print "min=",$o->min, "\n";
 print "max=",$o->max, "\n";

=head1 DESCRIPTION

The B<stats> library calculates simple statistics in the fashion of a
handheld calculator.  All input and return values are floating point.

=over

=item new stats

Construct a new B<stats> object.  It contains all the information
necessary to compute statistics on one set of data.  If you want to
analyze multiple sets of data, create multiple objects.

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

=item min

=item max

Return the extreme values of the set, or "?" if the set is empty

=back

=head1 SEE ALSO

stats34(3), histo(3), leastsquares(3), perm(3), sets(3), normaldist(3),
Stats(3), Histo(3)

=head1 AUTHOR

Robert Dowling <F<RPNCalcN@gmail.com>>.

=cut
