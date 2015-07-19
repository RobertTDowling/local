#!/usr/bin/perl

use lib "..";
# use lib "/home/rob/comp-sci/stat";
use stats34;

sub doit () {
    printf "N=%s mean=%s stdev=%s var=%s\n\tskew=%s kurt=%s min=%s max=%s\n",
	$o->N, $o->mean, $o->stdev, $o->var, $o->skew, $o->kurt, $o->min, $o->max;
}

$o = new stats;
$o->add (1); 
$o->add (2);
$o->add (2); doit();
$o->add (3); $o->add (3); $o->add (3); doit ();
$o->add (4); $o->add (4); $o->add (4); $o->add (4); doit ();
__END__
These values are tested against octave

N=3 skew=-0.70711 kurt=1.5 
N=6 skew=-0.62610 -7/5V5 or -7V5/25 kurt=2.04 51/25
N=10 skew=-0.6 kurt=2.2 11/5

Looks like my kurtosis is broken

    kurtosis (a,b,c,d,e,f)

    (6 ((1/6 (-a-b-c-d-e-f)+a)^4+(1/6 (-a-b-c-d-e-f)+b)^4+(1/6 (-a-b-c-d-e-f)+c)^4+(1/6 (-a-b-c-d-e-f)+d)^4+(1/6 (-a-b-c-d-e-f)+e)^4+(1/6 (-a-b-c-d-e-f)+f)^4))
    /
    ((1/6 (-a-b-c-d-e-f)+a)^2+(1/6 (-a-b-c-d-e-f)+b)^2+(1/6 (-a-b-c-d-e-f)+c)^2+(1/6 (-a-b-c-d-e-f)+d)^2+(1/6 (-a-b-c-d-e-f)+e)^2+(1/6 (-a-b-c-d-e-f)+f)^2)^2


    6* sum [All these things ^4] / [All the same things ^ 2]^2

    ---

    (1/6 (-a-b-c-d-e-f)+a) = x_i-x_mean

    N * Sum(x_i-x_mean) ^ 4 / [Sum(x_i-x_mean) ^ 2]^2


    x_mean = Sum_x / N


    # Kurtosis = E[(x-u)^4] / E[(x-u)^2]^2
    #          = {E[x^4] - 4uE[x^3] + 6u^2E[x^2] - 4u^3E[x] + u^4} / s^4
    # ....
    my $self = shift;
    $self->{N} > 1 ? 
	(  $self->{SXXXX}/($self->{N}-0) -
	 4*$self->{SXXX}*$self->{SX}/($self->{N}-0)/($self->{N}-0) +
	 6*$self->{SXX}*$self->{SX}*$self->{SX}/($self->{N}-0)/($self->{N}-0)/($self->{N}-0) -
	 3*$self->{SX}*$self->{SX}*$self->{SX}*$self->{SX}/($self->{N}-0)/($self->{N}-0)/($self->{N}-0)/($self->{N}-0)
	)/($self->var * $self->var) - 3
	: "?";
    

Sum[(x-u)^4] = Sum[x^4 - 4x^3u + 6x^2u^2 - 4xu^3 + u^4]

u = Sum_x/N
  Sum[u] = N u = Sum_x
  Sum[u]^2 = (Sum_x)^2
  Sum[u^3] = ...
  Sum[u^4] = ....

Sum[1] = N
Sum[x] = Sum_x
Sum[x^2] = Sum_x^2
Sum[x^3] = Sum_x^3
Sum[x^4] = Sum_x^4

Sum[(x-u)^4] = Sum[x^4 - 4x^3u + 6x^2u^2 - 4xu^3 + u^4]
	     = Sum[x^4] - 4Sum(x^3 u) + 6Sum(x^2 u^2) - 4Sum(x u^3) + Sum(u^4)
	     = Sum[x^4]
	       - 4 Sum[x^3 Sum(x)/n] = 4 Sum[x^3]Sum[x]
	       + 6 Sum[x^2 Sum(x)/n Sum(x)/n] = 6 Sum[x^2] Sum[x]^2 / N
	       - 4 Sum[x {Sum(x)/n}^3] = 4 Sum[x] Sum[x]^3 / N^2
	       + Sum[{Sum(x)/n}^4] = Sum[x]^4 / N^3

Compare

	     {SXXXX}/N
	 - 4*{SXXX}*{SX}/N/N
	 + 6*{SXX}*{SX}*{SX}/N/N/N
	 - 3*{SX}*{SX}*{SX}*{SX}/N/N/N/N


** Kurtosis = 1/N Sum (x-u)^4 / [1/N Sum (x-u)^2]^2
** Which is where N in numerator shows up

I must have made a mistake

    N=10
    SX=30
    SXX=100
    SXXX=354
    SXXXX=1300

    denom might be 1.25 = 5/4

    k = N/D = 11/5, then N = 11/4; D=5/4

	     = 1300
	       - 4 354 30
	       + 6 100 30*30 / 10
	       - 4 30 30*30*30 / 100
	       + 30^4 / 1000
    
	     = 1300 -42480 +54000 -32400 +810 -- wrong!
	     


Done the other way u = 3, N=10

Sum[(x-u)^4] = (1-3)^4 + 2*(2-3)^4 + 3*(3-3)^4 + 4(4-3)^4
	     = 2^4 + 2 + 0 + 4
	     = 22

Sum[(x-u)^2]^2 = [(1-3)^2 + 2*(2-3)^2 + 3*(3-3)^2 + 4(4-3)^2]^2
	       = [2^2 + 2 + 4]^2 = 10^2 = 100

Answer is 22 * 10 / 100 or 2.2, exactly.

[Sum (x-u)^2] ^ 2 =... sum(x-u)^2 = sum(x^2) - 2sum(x)sum(u) + sum(u)^2
     Sum[(x-u)^2] = Sum[x^2 - 2xu + u^2]
     		  = Sum[x^2] - 2Sum(xu) + Sum(u^2)
		  = SXX - 2 SX SX +  SX SX / N
		    100 - 2*30*30 + 10*(30/10 * 30/10)
		    100 - 1800 + 90 = garbage

		    But 100 - 180 + 90 = 10!  Which is the right number!

		    SXX - 2 SX SX / N + N (SX/N * SX/N)
		    100 - 2*30*30/10 + 30*30/10
		    100 - 30*30/10 = 10

		    -2 Sum(xu) = -2 Sum(x SX/N)
		       	       = -2 SX/N (SX)
			       = -2 SX * SX / N  Yes


		    Sum(u^2) = Sum(SX/N * SX/N) = N (SX^2) / N^2 = SX^2/N Yes
----------
Sum[(x-u)^4] = Sum[x^4] - 4Sum[x^3u] + 6Sum[x^2u^2] - 4Sum[xu^3] + Sum[u^4]
	     = Sum[x^4]
	       - 4 Sum[x^3 Sum(x)/n] = 4 Sum[x^3]Sum[x]/N
	       + 6 Sum[x^2 Sum(x)/n Sum(x)/n] = 6 Sum[x^2] Sum[x]^2 / N^2
	       - 4 Sum[x {Sum(x)/n}^3] = 4 Sum[x] Sum[x]^3 / N^3
	       + Sum[{Sum(x)/n}^4] = Sum[x]^4 / N^4


	       1300
	       - 4 354 30 /10
	       + 6 100 30 * 30 / 100
	       - 4 30 * 30 * 30 * 30 / 1000
	       + 30 * 30 * 30 * 30 / 10000

	       1300
	       -4248
	       5400
	       -3240
	       81

Nope again

    x = 1,2,2,3,3,3,4,4,4,4
    u = 3
    N=10
    SX=30
    SXX=100
    SXXX=354
    SXXXX=1300
    Su=10*3=30
    Suu=10*9=90
    Suuu=10*27=270
    Suuuu=10*81=810

Sum[(x-u)^4] = (1-3)^4 + 2*(2-3)^4 + 3*(3-3)^4 + 4(4-3)^4
	     = 2^4 + 2 + 0 + 4
	     = 22
Sum[(x-u)^4] = Sum[x^4] - 4Sum[x^3u] + 6Sum[x^2u^2] - 4Sum[xu^3] + Sum[u^4]
	     = 1300 - 4*30*354 + 6*90*100 - 4*270*30 + 810
	     = 1300 - 42480 + 54000 - 32400 + 810
	       NOPE
Sum[(x-u)^4] = Sum[x^4 - 4x^3u + 6x^2u^2 - 4xu^3 + u^4]
	     = Sum[x^4] - 4*3*Sum[x^3] + 6*9*Sum[x^2] - 4*27*Sum[x] + 81
	     = 1300 - 4248 + 5400 - 3240 + 81
	     = -707, NOPE
	     

    I figured it out

    Sum[u] = uSum[1] = nu.  That was the trick
    Sum[u^2] = u^2Sum[1] = nu^2
    Sum[ux] = uSum[x] = uSX

Sum[(x-u)^2]^2 = [(1-3)^2 + 2*(2-3)^2 + 3*(3-3)^2 + 4(4-3)^2]^2
	       = [2^2 + 2 + 4]^2 = 10^2 = 100
	     
    u = 3
    N=10
    SX=30
    SXX=100

	       = [SXX - 2 u SX + u^2 N] ^2
	       = [100 - 180 + 90]^2
	       = 100

******************************************************************************

# Skewness = E[({x-u}/s)^3] = E[(x-u)^3] / E[(x-u)^2]^(3/2)
# Skewness = Sqrt(N) Sum[(x-u)^3] / Sum[(x-u)]^(3/2)
    
Sum[(x-u)^3] = [(1-3)^3 + 2*(2-3)^3 + 3*(3-3)^3 + 4(4-3)^3]
	     = [-8 + -2 + 0 + 4]
	     = -6

Sum[(x-u)^2]^(3/2) = [(1-3)^2 + 2*(2-3)^2 + 3*(3-3)^2 + 4(4-3)^2]^2
	       = [2^2 + 2 + 4]^2 = 10^(3/2) = 10V10
  
Want -3/5 or -6/10

     V10 * 6 / 10V10  -- this is right.

	$self->{N} *
	(      $self->{SXXX}
	 - 3 * $self->{SXX} * $u
	 + 3 * $self->{SX} * $u**2
	 -     $self->{N} * $u**3
	)/(      $self->{SXX}
	   - 2 * $self->{SX} * $u
	   + $self->{N} * $u**2)**1.5
     	: "?";
