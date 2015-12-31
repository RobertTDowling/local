#!/usr/bin/perl

$TX = 1550;
$TY = 700;
$M = 10;   # Margin

$DYEAR = 55;
$YEAR0 = 1963;
$YEAR1 = $YEAR0+$DYEAR;
$MON0 = 1;
$SX = ($TX-2*$M)/$DYEAR/12; # Width, in months
$SY = ($TY-2*$M)/24;    # Height, in categories
;
$BDY = $SY * .8;
$TDY = $SY * .6;

sub line_to_y ($)
{
    $M + $SY*shift;
}

sub date_to_x ($)
{
    local $_ = shift;
    my ($m, $y) = split /\//;
    $m = eval ($m);
    $y = eval ($y);
    $M + $SX * (($y-$YEAR0) * 12 + $m-1);
}

# Header
print <<EOF;
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="${TX}px" height="${TY}px"
     xmlns="http://www.w3.org/2000/svg" version="1.1">

EOF
# <svg width="${TX}mm" height="${TY}mm" viewBox="0 0 $TX $TY"

# Background gray
printf <<EOF;
<rect x="0" y="0" width="$TX" height="$TY" fill="#ddd" />
EOF

# Yearly white ticks
printf <<EOF, date_to_x ("1/$_")-2 for ($YEAR0..$YEAR1);
<rect x="%d" y="0" width="1" height="$TY" fill="#eee" />
EOF

# My Age
printf <<EOF, date_to_x ("8/$_"), line_to_y(2), 11*$SX, $BDY, date_to_x ("13.5/$_"), line_to_y(2)+$TDY, $TDY, "blue", $_-$YEAR0 for ($YEAR0..$YEAR1);
<rect x="%d" y="%d" width="%d" height="%d" fill="white" />
<text x="%d" y="%d" font-size="%d" fill="%s" font-family="sans serif" text-anchor="middle" >%s</text>
EOF

# Years
printf <<EOF, date_to_x ("1/$_"), line_to_y(0), 11*$SX, $BDY, date_to_x ("6/$_"), line_to_y(0)+$TDY, $TDY, "blue", $_ % 100 for ($YEAR0..$YEAR1);
<rect x="%d" y="%d" width="%d" height="%d" fill="white" />
<text x="%d" y="%d" font-size="%d" fill="%s" font-family="sans serif" text-anchor="middle" >%02d</text>
EOF

$line=1;
while (<DATA>)
{
    $line++, next if /^---/;
    chomp;
    my ($sdate, $edate, $label) = split /,/;
    $label =~ s/#.*//;
    my $x0 = date_to_x ($sdate);
    my $x1 = date_to_x ($edate);
    my $y0 = line_to_y ($line);
    my $y1 = $y0 + $BDY;
    printf '<rect x="%d" y="%d" width="%d" height="%d"'."\n",
	$x0, $y0, $x1-$x0, $y1-$y0, "none";
#     printf '      fill="%s" stroke="%s" stroke-width="%d"/>'."\n",
# 	"none", "black", 2;
    printf '      fill="%s" />'."\n",
 	"white", "black", 2;
    printf '<text x="%d" y="%d" font-size="%d" fill="%s"',
	($x0+$x1)/2, $y0+$TDY, $TDY, "blue";
    printf ' font-family="sans serif" text-anchor="middle"';
    printf ' >%s</text>'."\n", $label;
}


# print "<rect x=\"10\" y=\"10\" width=\"50\" height=\"10\" fill=\"none\"\n";
# print "      stroke=\"black\" stroke-width=\"2\"/>\n";

print "</svg>\n";

__DATA__
1/1960,12/1969,60's
1/1970,12/1979,70's
1/1980,12/1989,80's
1/1990,12/1999,90's
1/2000,12/2009,00's
1/2010,12/2019,10's
---
---
4/1947,7/1996,A
---
3/1956,12/2007,B
---
1/1998,10/2012,C
---
1/1999,3/2015,D
---
6/2014,12/$YEAR1,E
---
9/1969,6/1970,1st
9/1970,6/1971,2nd
9/1971,6/1972,3rd
9/1972,6/1973,4th
9/1973,6/1974,5th
9/1974,6/1975,6th
9/1975,6/1977,MS
9/1977,6/1981,HS
1/1997,12/2001,C
1/2002,5/2004,U
 __END__
