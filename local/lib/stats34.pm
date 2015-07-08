package stats;

# Minimal statistics
#
'(C) Copyright 2005 Robert Dowling.';
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

sub var ()
{
    # Var = E[(x-u)^2] = E[x^2] - E[x]^2
    #     = SXX/N - SX/N * SX/N
    my $self = shift;
    $self->{N} ? 
	($self->{SXX}-$self->{SX}*$self->{SX}/$self->{N})/(1+$self->{N})
	: "?";
}

sub stdev ()
{
    # Stdev = s = Sqrt(Var)
    my $self = shift;
    $self->{N} ? 
	sqrt (($self->{SXX}-$self->{SX}*$self->{SX}/$self->{N})/(1+$self->{N}))
	: "?";
}

sub skew ()
{
    # Skewness = E[({x-u}/s)^3] = E[(x-u)^3] / E[(x-u)^2]^(3/2)
    #          = E[(x-u)^3] / s^3
    #          = (E[x^3] - 3uE[X^2] + 3u^2E[X] - u^3) / s^3
    #          = (E[x^3] - 3us^2 - u^3) / s^3
    #          = (SXXX/N - 3us^2 - u^3) / s^3
    my $self = shift;
    $self->{N} ? 
	($self->{SXXX}/($self->{N}+1) -
	 3*$self->{SXX}*$self->{SX}/$self->{N}/($self->{N}+1) +
	 3*$self->{SX}*$self->{SX}*$self->{SX}/$self->{N}/$self->{N}/($self->{N}+1) -
	 $self->{SX}*$self->{SX}*$self->{SX}/$self->{N}/$self->{N}/($self->{N}+1)
	)/ ($self->stdev * $self->var)
	# ($self->{SXXX}/($self->{N}+1) -
	#  3*$self->mean*$self->var -
	#  $self->mean*$self->mean*$self->mean)
	# )/ ($self->stdev * $self->var)
	: "?";
}

sub kurt ()
{
    # Kurtosis = E[(x-u)^4] / E[(x-u)^2]^2
    #          = {E[x^4] - 4uE[x^3] + 6u^2E[x^2] - 4u^3E[x] + u^4} / s^4
    # ....
    my $self = shift;
    $self->{N} ? 
	(  $self->{SXXXX}/($self->{N}+1) -
	 4*$self->{SXXX}*$self->{SX}/$self->{N}/($self->{N}+1) +
	 6*$self->{SXX}*$self->{SX}*$self->{SX}/$self->{N}/$self->{N}/($self->{N}+1) -
	 3*$self->{SX}*$self->{SX}*$self->{SX}*$self->{SX}/$self->{N}/$self->{N}/$self->{N}/($self->{N}+1)
	)/($self->var * $self->var) - 3
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
