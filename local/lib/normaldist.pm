#!/usr/bin/perl

package normaldist;

# Normal Distribution
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
# $n = new normal;
# $n->nrand ($mean, $stdev);

require Exporter;
our @ISA = qw(Exporter); 
# our @EXPORT = qw(new);

sub new
{
    my $self = {};
    bless $self;
    $self;
}

sub nrand ($$)
{
    my ($self, $mean, $stdev) = @_;
    my ($z1, $z2, $s);
    while (1) {
	$z1 = rand(2)-1;
	$z2 = rand(2)-1;
	$s = $z1*$z1+$z2*$z2;
	last if $s < 1.0;
    }
    my $u = $z1 * sqrt(-2*log($s)/$s);
    my $v = $z2 * sqrt(-2*log($s)/$s);
    return $mean + $stdev * $u;
}

1;
__END__

=head1 NAME

normaldist - perl library to generate a set of normally distributed values

=head1 SYNOPSIS

 use normaldist;

 $n = new normal;
 my $randval = $n->nrand ($mean, $stdev);

=head1 DESCRIPTION

The B<normaldist> library creates normally distributed random numbers using the The Box-Muller transform. 

=over

L<http://stackoverflow.com/questions/2325472/generate-random-numbers-following-a-normal-distribution-in-c-c>

L<http://en.wikipedia.org/wiki/Normal_distribution#Generating_values_from_normal_distribution>

L<http://en.wikipedia.org/wiki/Box_Muller_transform>

=back

It isn't very smart about it at all

=over

=item *

It generates two numbers and throws away the second.

=item *

It uses a object-oriented interface, but the object isn't used for
anything.  It probably could at least store the unused 2nd number and
return it quickly next time.  It could also store the desired B<mean>
and B<stdev> parameters instead of requiring them for every call for
B<nrand>.

=back

=head1 RETURN VALUE

Every call to B<nrand> will return a normally distributed random
number, based on the parameters passed in.  As the set of numbers
grows, their mean and standard deviation will approach B<mean> and
B<stdev>.

=head1 SEE ALSO

rand(3), stats(3), stats34(3), histo(3), perm(3), sets(3), Stats(3), Histo(3)

=head1 AUTHOR

Robert Dowling <F<RPNCalcN@gmail.com>>.

=cut
