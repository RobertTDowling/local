package leastsquares;

# Minimal least squares
#
'(C) Copyright 2016 Robert Dowling.';
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
# $o = new leastsquares;
# $o->add (0,0);
# $o->add (1,0);
# $o->add (2,1);
# $o->add (3,1);
# print "N=",$o->N, "\n";
# print "m=",$o->m, "\n";
# print "b=",$o->b, "\n";

require Exporter;
our @ISA = qw(Exporter); 
our @EXPORT = qw(new add N m b);

# y = mx+b
# Minimize Err(m,b) = Sum(mx_i + b -y_i)^2
# Err(m,b) = Sum(m^2 x_i^2) + Sum(b^2) + Sum(y_i^2)
#	   + Sum(2mb x_i) - Sum(2m x_i y_i) - Sum(2b y_i)
# Find where slope is 0:
#
# 1: \partial Err(m,b) / \partial m = 0
#	Sum(2 x_i^2 m) + Sum(2b x_i) - Sum(2 x_i y_i) = 0
#	2Sum(x_i^2)m = 2Sum(x_i y_i) - 2Sum(b x_i) = 0
#	Sum(x_i^2)m = Sum(x_i y_i) - bSum(x_i)
#	let c=Sum(x_i^2), d=Sum(x_i y_i), e=Sum(x_i)
#	then cm=d-eb
#
# 2: \partial Err(m,b) / \partial b = 0
#	Sum(2b) + Sum(2m x_i) - Sum(2 y_i) = 0
#	Sum(1)b = Sum(y_i) - mSum(x_i)
#	let n=Sum(1), f=Sum(y_i)
#	then nb=f-em
# Solve for m, b
#	m = (-dn+ef)/(e^2-nc)
#	b = (de-cf)/(e^2-nc)

sub new
{
    my $self = {};
    $self->{N} = 0;
    $self->{SX} = 0;
    $self->{SXX} = 0;
    $self->{SY} = 0;
    $self->{SYY} = 0;
    $self->{SXY} = 0;
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

sub add ($$)
{
    my ($self, $x, $y) = @_;
    $self->{N}++;
    $self->{SX}+=$x;
    $self->{SXX}+=$x*$x;
    $self->{SY}+=$y;
    $self->{SYY}+=$y*$y;
    $self->{SXY}+=$x*$y;
}

#	let c=Sum(x_i^2), d=Sum(x_i y_i), e=Sum(x_i)
#	let n=Sum(1), f=Sum(y_i)
#
#	m = (-dn+ef)/(e^2-nc)
#	b = (de-cf)/(e^2-nc)

sub m ($)
{
    my $self = shift;
    return 0 unless $self->{N};
    return (-$self->{SXY}*$self->{N} + $self->{SX}*$self->{SY}) /
	    ($self->{SX}*$self->{SX} - $self->{N}*$self->{SXX});
}

sub b ($)
{
    my $self = shift;
    return 0 unless $self->{N};
    return ($self->{SXY}*$self->{SX} - $self->{SXX}*$self->{SY}) /
	   ($self->{SX}*$self->{SX}  - $self->{N}*$self->{SXX});
}

1;
__END__

=head1 NAME

leastsquares - perl library for simple least squares

=head1 SYNOPSIS

 use leastsquares;

 $o = new leastsquares;
 $o->add (0,0);
 $o->add (1,0);
 $o->add (2,1);
 $o->add (3,1);
 print "N=",$o->N, "\n";
 print "m=",$o->m, "\n";
 print "b=",$o->b, "\n";

=head1 DESCRIPTION

The B<leastsquares> library calculates a simple linear curve fit for a
set of x,y data.  All input and return values are floating point.

=over

=item new stats

Construct a new B<leastsquares> object.  It contains all the information
necessary to compute statistics on one set of data.  If you want to
analyze multiple sets of data, create multiple objects.

=item add (x,y)

Add value B<x,y> to the set.  This will increase B<N> by 1

=item N

Return the number of items in the set.  When constructed, the set
contains no values.

=item m

Return the slope of the fit line: y=mx+b

=item b

Return the y-intercept of the fit line: y=mx+b

=back

=head1 SEE ALSO

stats(3), stats34(3), histo(3), perm(3), sets(3), normaldist(3), Stats(3), Histo(3)

=head1 AUTHOR

Robert Dowling <F<RPNCalcN@gmail.com>>.

=cut
