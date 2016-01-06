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

# From Wikipedia and facts-about-sums...
# \sum 1 = N
# \sum (mean x) = N mean x = \sum x
# \sum (x mean x) = mean x \sum x = (\sum x)^2 / N
# \sum ((mean x)^2) = N (mean x)^2 = (\sum x)^2 / N
#
# R^2: from 0 (not fitting) to 1 (perfect fit)
#
# R^2 = 1 - SSres / SStot
#
# SStot = sum(y_i-mean y)^2
# SSres = sum(y_i-f)^2
# SSreg = sum(f-mean y)^2
#
# SSres + SSreg = SStot ... but we don't use this
#
# SStot = \sum(y^2 - 2y mean y + (mean y)^2)
#       = \sum(y^2) - 2\sum(y)\sum(y)/\sum(1) + sum(y)^2/\sum(1)
#       = \sum(y^2) - sum(y)^2/\sum(1)
#
# ### some symbols in unicode... ŷƒ nothing with x though
# ƒ = mx+b  (don't confuse ƒ with f)
# ƒ^2 = m^2x^2+2mbx+b^2
# yƒ = ymx+yb
#
# SSres = \sum(y^2 - 2yƒ + ƒ^2)
#       = \sum(y^2) - 2\sum(yƒ) + \sum(ƒ^2)
#       = \sum(y^2) - 2\sum(ymx+yb) + \sum((mx+b)^2)
#  = \sum(y^2) - 2m\sum(xy)- 2b\sum(y) + m^2\sum(x^2) + 2mb\sum(x) + b^2\sum(1)
#
#	let c=Sum(x_i^2), d=Sum(x_i y_i), e=Sum(x_i)
#	let n=Sum(1), f=Sum(y_i), g=Sum(y_i^2)
#	m = (-dn+ef)/(e^2-nc)
#	b = (de-cf)/(e^2-nc)
#
# SStot = g - f^2/n (verified)
# SSres = g - 2md - 2bf + cm^2 + 2mbe + nb^2 (verified)

sub r_squared ($)
{
    my $self = shift;
    return 0 unless $self->{N};
    my $b = $self->b;
    my $m = $self->m;
    my $ss_tot = $self->{SYY} - $self->{SY}*$self->{SY}/$self->{N};
    my $ss_res = $self->{SYY}
	- 2*$m*$self->{SXY}
	- 2*$b*$self->{SY}
	+ $self->{SXX}*$m*$m
	+ 2*$m*$b*$self->{SX}
	+ $self->{N}*$b*$b;
    return 1-($ss_res/$ss_tot);
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

=item r_squared

Return r_squared, the
L<Coefficient_of_determination|https://en.wikipedia.org/wiki/Coefficient_of_determination>,
a much reviled measure of the quality of the fit, from 0 (bad) to 1
(good).

=back

=head1 SEE ALSO

stats(3), stats34(3), histo(3), perm(3), sets(3), normaldist(3), Stats(3), Histo(3)

=head1 AUTHOR

Robert Dowling <F<RPNCalcN@gmail.com>>.

=cut
