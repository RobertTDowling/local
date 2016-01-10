#!/usr/bin/perl

# Permutations
#
'(C) Copyright 2005-2015 Robert Dowling.';
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


package perm;

# Usage
# $p = new perm;
# @p = $p->init (3);
# do {
#    print join(',', @p), "\n";
#    @p = $p->next;
# } while (@p);
#

# use List::Util 'shuffle';

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw(fact);
# our @EXPORT = qw(new init state next fact);

# Create a new permutation object for N elements
sub new ()
{
    my $self = {};
    bless $self;
    $self;
}

# Reinitialize to a new size (or the same size if no size passed in)
# Returns the first permutation, the one that goes 0..N-1
sub init ($$)
{
    my ($self, $N) = @_;
    $self->{N} = $N;
    $self->{P} = [0..$N-1];
    return $self->state;
}

sub state ()
{
    my $self = shift;
    return @{$self->{P}};
}

# Returns the next permutation or an empty list when done
sub next ()
{
    my $self = shift;
    my @P = @{$self->{P}};

    # E.W.Dijkstra, A Discipline of Programming, Prentice-Hall, 1976, P 71.
    my $i = $#P-1;
    $i-- while ($P[$i] > $P[$i+1]);
    return () if $i < 0;

    my $j = $#P;
    $j-- while ($P[$i] > $P[$j]);

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

    $self->{P} = \@P;
    @P;
}

##############################################################################

sub fact ($)
{
    my $n = shift;
    $n > 1 ? $n * fact($n-1) : 1;
}

1;
__END__

=head1 NAME

perm - perl library for simple permutations

=head1 SYNOPSIS

 use perm;

 @p = $p->init (3);
 do {
    print join(',', @p), "\n";
    @p = $p->next;
 } while (@p);

=head1 DESCRIPTION

The B<perm> library generates all the permutations of a list of B<N>
ordered numbers, 0..B<N>-1 using  E.W.Dijkstra's algorithm, which does not
require nested loops.

=over

=item $p = new perm

Construct a new B<perm> object.  It contains the state of the
permutation list.  If you want to have multiple lists in different
states, create multiple objects.

=item $p->init (n)

Initialize the B<perm> object to have B<n> items in the initial state,
0..B<n>-1.

Returns the list in the initial state

=item $p->next

Advance to the next permutation.

Returns the list in the new state, or the empty list, () if all permutations
have been already exhausted.

=item fact (n)

Returns the factorial of B<n>, which is the number of permutations you
will get of the set of B<n> numbers.

=back

=head1 SEE ALSO

sets(3), stats(3), stats34(3), histo(3), normaldist(3), Stats(3), Histo(3)

=head1 AUTHOR

Robert Dowling <F<RPNCalcN@gmail.com>>.

=cut
