package ema;

# Exponential Moving Average
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
# $e = new ema (0.5, 0);
# printf "%.3f", $e->filter (1);
# printf "%.3f", $e->filter (1);
# printf "%.3f", $e->filter (1);

require Exporter;
our @ISA = qw(Exporter);
# our @EXPORT = qw();

sub new
{
    my ($type, $alpha, $y) = @_;
    my $self = {};
    $self->{alpha} = $alpha;
    $self->{y} = $y;
    bless $self, $type;
    $self;
}

sub filter ($)
{
    my ($self, $x) = @_;
    $self->{y} += ($x - $self->{y}) * $self->{alpha};
}

sub y ()
{
    my $self = shift;
    $self->{y};
}

1;
__END__

=head1 NAME

ema - perl library for Exponential Moving Average

=head1 SYNOPSIS

 use ema;

 $e = new ema (0.5, 0);
 printf "%.3f", $e->filter (1);
 printf "%.3f", $e->filter (1);

=head1 DESCRIPTION

The B<ema> library implements an exponential moving average,
effectively the discrete version of a RC low-pass filter.  All input
and return values are floating point.

See L<https://en.wikipedia.org/wiki/Moving_average#Exponential_moving_average>

=over

=item $e = new ema ($alpha, $initial_value)

Construct a new B<ema> object with the given B<alpha>, and optional
B<initial_value>.  If no B<initial_value> is given, zero will be used.

The object contains all the information necessary to compute a moving average
on one set of data.  If you want to filter multiple sets of data, create
multiple objects.

The value of B<alpha> controls how fast the filter converges on the new value.
B<Alpha> should be small, between 0 and 1.  Smaller values of B<alpha> will
take longer to converge and will effectively filter more.  In terms of classic
RC filters, the time constant, T = 1/B<alpha>.  After 1/B<alpha> samples, the
filter will have converged 1-exp(-1)=63.2% of the way to the new input value.

The cutoff frequency of the filter is 1/T radians/second.  As a
period, this will be 2Pi*T samples.  At this frequency, the filter
passes half the power, or 1/sqrt(2) = 0.707 of the amplitude.

=item $y = $e->value ($x)

Advance the moving average by including a new input value B<$x> and return the
next filtered value.

=item $e->y

Return the current value of the filter without advancing it.

=back

=head1 SEE ALSO

stats(3), leastsquares(3)

=head1 AUTHOR

Robert Dowling <F<RPNCalcN@gmail.com>>.

=cut
a
