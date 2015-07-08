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
our @EXPORT = qw(new);

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
