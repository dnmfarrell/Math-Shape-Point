package Math::Shape::Point;

use strict;
use warnings;
use Method::Signatures;
use Math::Trig ':pi';
use Regexp::Common;
use Carp 'croak';

=head1 NAME

Math::Shape::Point - a 2d point object in cartesian space with utility angle methods

=for html
<a href="https://travis-ci.org/sillymoose/Math-Shape-Point-pm.png"><img src="https://travis-ci.org/sillymoose/Math-Shape-Point-pm.png alt="Math-Shape-Point-pm"></a>

=head1 DESCRIPTION

This module is designed to provide some useful 2d functions for manipulating point shapes in cartesian space. Advanced features include rotating around another point, calculating the distance to a point and the calculating the angle to another point. The module uses cartesian coordinates and radians throughout.

=head1 SYNOPSIS

    use Math::Shape::Point;
    use Math::Trig ':pi';

    my $p0 = Math::Shape::Point->new(0, 0, 0);
    my $p1 = Math::Shape::Point->new(5, 5, 0);
    $p0->rotateAboutPoint($p1, pip2);
    my $angle = $p0->getAngleToPoint($p1);
    my $distance = $p0->getDistanceToPoint($p1);

=head1 METHODS

=head2 new

Instantiates a new point object. Requires the x and y cartesian coordinates and the facing direction in radians.

=cut

func new ($class, $x where { $_ =~ /$RE{num}{real}/ }, $y where { $_ =~ /$RE{num}{real}/ }, $r where { $_ =~ /$RE{num}{real}/ }) {
    my $self = { 
        x => $x,
        y => $y,
        r => $r,
    };
    return bless $self, $class;
}


=head2 getLocation

Returns an arrayref containing the point's location in cartesian coordinates.

=cut

method getLocation () {
    return [$self->{x}, $self->{y}];
}


=head2 setLocation

Sets the point's location in cartesian coordinates. Requires two numbers as inputs for the x and y location.

=cut

method setLocation ($x where { $_ =~ /$RE{num}{real}/ }, $y where { $_ =~ /$RE{num}{real}/ } ) {
    $self->{x} = $x;
    $self->{y} = $y;
    1;
}


=head2 getDirection

Returns the current facing direction in radians.

=cut

method getDirection () {
    return $self->{r};
}


=head2 setDirection

Sets the current facing direction in radians.

=cut

method setDirection ($r where { $_ =~ /$RE{num}{real}/ } ) {
    $self->{r} = $self->normalizeRadian($r);
    1;
}


=head2 advance

Requires a numeric distance argument - moves the point forward that distance in Cartesian coordinates towards the direction it is facing.

=cut

method advance ($distance where { $_ > 0 } where { $_ =~ /$RE{num}{real}/ } ) {
    $self->{x} += int(sin($self->{r}) * $distance);
    $self->{y} += int(cos($self->{r}) * $distance);
    1;
}


=head2 rotate

Updates the point's facing direction by radians.

=cut

method rotate ($r where { $_ =~ /$RE{num}{real}/ } ) {
    $self->{r} = $self->{r} + $self->normalizeRadian($r);
    1;
}


=head2 rotateAboutPoint

Rotates the point around another point of origin. Requires a point object and the angle in radians to rotate. This method updates the facing direction of the point object, as well as it's location.

=cut

method rotateAboutPoint (Math::Shape::Point $origin, $r where { $_ =~ /$RE{num}{real}/ } ) {
    $r = $self->normalizeRadian($r);
    $self->{x} = $origin->{x} + int(cos($r) * ($self->{x} - $origin->{x}) - sin($r) * ($self->{y} - $origin->{y}));
    $self->{y} = $origin->{y} + int(sin($r) * ($self->{x} - $origin->{x}) + cos($r) * ($self->{y} - $origin->{y}));
    $self->rotate($r);
    1;
}


=head2 getDistanceToPoint

Returns the distance to another point object. Requires a point object as an argument.

=cut

method getDistanceToPoint (Math::Shape::Point $p) {
    return sqrt ( abs($self->{x} - $p->{x}) ** 2 + abs($self->{y} - $p->{y}) ** 2);
}


=head2 getAngleToPoint

Returns the angle of another point object. Requires a point as an argument.

=cut

method getAngleToPoint (Math::Shape::Point $p) {

    # check points are not at the same location
    if ($self->getLocation->[0] == $p->getLocation->[0]
        && $self->getLocation->[1] == $p->getLocation->[1]) 
    {
        croak 'Error: points are at the same location';
    }
    
    my $atan = atan2($p->{y} - $self->{y}, $p->{x} - $self->{x});

    if ($atan <= 0) { # lower half
        return abs($atan) + pip2 + $self->getDirection;
    }
    elsif ($atan <= pip2)  { # upper right quadrant
        return abs($atan - pip2) + $self->getDirection;
    }
    else { # upper left quadrant
        return pi2 - $atan + pip2 + $self->getDirection;
    }
}

=head2 getDirectionToPoint

Returns the direction of another point objection as a string (front, right, back or left). Assumes a 90 degree angle per direction.  Requires a point object as an argument.

=cut

method getDirectionToPoint (Math::Shape::Point $p) {
    my $angle = $self->getAngleToPoint($p);
    if    ($angle > 0 - pip4  && $angle <= pip4)      { return 'front' }
    elsif ($angle > pip4      && $angle <= pi - pip4) { return 'right' }
    elsif ($angle > pi - pip4 && $angle <= pi + pip4) { return 'back'  }
    return 'left';
}

=head2 normalizeRadian

Takes a radian argument and returns it between 0 and PI2. Negative numbers are assumed to be backwards (e.g. -1.57 == PI + PI / 2)

=cut

method normalizeRadian ($radians where { $_ =~ /$RE{num}{real}/ }) {
    my $piDecimal = ($radians / pi2 - int($radians / pi2));
    return $piDecimal < 0 ? pi2 + $piDecimal * pi2 : $piDecimal * pi2;
}

1;

=head1 AUTHOR

David Farrell, C<< <davidnmfarrell at gmail.com> >>, L<perltricks.com|http://perltricks.com>

=head1 BUGS

Please report any bugs or feature requests to C<bug-math-shape-point at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=math-shape-point>.  I will be notified, and then you'll automatically be notified of 
progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Math::Shape::Point

=head1 REPOSITORY

L<https://github.com/sillymoose/Math-Shape-Point.git>

=cut
