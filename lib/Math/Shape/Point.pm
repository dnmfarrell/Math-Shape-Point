package Math::Shape::Point;

use strict;
use warnings;
use 5.008;
use Math::Trig 1.22 ':pi';
use Regexp::Common;
use Carp 'croak';

# ABSTRACT: a 2d point object in cartesian space with utility angle methods

=for HTML <a href="https://travis-ci.org/sillymoose/Math-Shape-Point"><img src="https://travis-ci.org/sillymoose/Math-Shape-Point.svg?branch=master"></a>
<a href='https://coveralls.io/r/sillymoose/Math-Shape-Point'><img src='https://coveralls.io/repos/sillymoose/Math-Shape-Point/badge.png' alt='Coverage Status' /></a>

=head1 DESCRIPTION

This module is designed to provide some useful 2d functions for manipulating point shapes in cartesian space. Advanced features include rotating around another point, calculating the distance to a point and the calculating the angle to another point. The module uses cartesian coordinates and radians throughout.

=head1 SYNOPSIS

    use Math::Shape::Point;
    use Math::Trig ':pi';

    my $p1 = Math::Shape::Point->new(0, 0, 0);
    my $p2 = Math::Shape::Point->new(5, 5, 0);
    $p1->rotate_about_point($p2, pip2);
    my $angle = $p1->get_angle_to_point($p2);
    my $distance = $p1->get_distance_to_point($p2);

=head1 METHODS

=head2 new

Instantiates a new point object. Requires the x and y cartesian coordinates and the facing direction in radians.

    my $p = Math::Shape::Point->new(0, 0, 0);

=cut

sub new {
    croak 'Incorrect number of arguments for new()' unless @_ == 4;
    my ($class, $x, $y, $r) = @_;
    my $self =  bless { x => $x,
                        y => $y,
                        r => 0,
                      },
                      $class;
    $self->rotate($r);
    return $self;
}

=head2 get_location

Returns an arrayref containing the point's location in cartesian coordinates.

    $p->get_location;

=cut

sub get_location { [$_[0]->{x}, $_[0]->{y}] }


=head2 set_location

Sets the point's location in cartesian coordinates. Requires two numbers as inputs for the x and y location.

    $p->set_location($x, $y);

=cut

sub set_location {
    my ($self, $x, $y) = @_;
    $self->{x} = $x;
    $self->{y} = $y;
    1;
}

=head2 get_direction

Returns the current facing direction in radians.

    $p->get_direction;

=cut

sub get_direction {
    return $_[0]->{r};
}

=head2 set_direction

Sets the current facing direction in radians.

    $p->set_direction(2.5);

=cut

sub set_direction {
    $_[0]->{r} = $_[0]->normalize_radian($_[1]);
    1;
}

=head2 advance

Requires a numeric distance argument - moves the point forward that distance in Cartesian coordinates towards the direction it is facing.

    $p->advance(5);

=cut

sub advance {
    $_[0]->{x} += int(sin($_[0]->{r}) * $_[1]);
    $_[0]->{y} += int(cos($_[0]->{r}) * $_[1]);
    1;
}

=head2 retreat

Requires a numeric distance argument - moves the point backwards that distance in Cartesian coordinates from the direction it is facing.

    $p->retreat(5);

=cut

sub retreat {
    $_[0]->{x} -= int(sin($_[0]->{r}) * $_[1]);
    $_[0]->{y} -= int(cos($_[0]->{r}) * $_[1]);
    1;
}

=head2 move_left

Requires a numeric distance argument - moves the point that distance to the left.

    $p->move_left(3);

=cut

sub move_left {
    $_[0]->{x} += int(sin( $_[0]->{r} - pip2 ) * $_[1]);
    $_[0]->{y} += int(cos( $_[0]->{r} - pip2 ) * $_[1]);
    1;
}

=head2 move_right

Requires a numeric distance argument - moves the point that distance to the right.

    $p->move_right(7);

=cut

sub move_right {
    $_[0]->{x} += int(sin( $_[0]->{r} + pip2 ) * $_[1]);
    $_[0]->{y} += int(cos( $_[0]->{r} + pip2 ) * $_[1]);
    1;
}

=head2 rotate

Updates the point's facing direction by radians.

    $p->rotate(2);

=cut

sub rotate {
    $_[0]->{r} = $_[0]->normalize_radian($_[0]->{r} + $_[1]);
    1;
}

=head2 rotate_about_point

Rotates the point around another point of origin. Requires a point object and the angle in radians to rotate. This method updates the facing direction of the point object, as well as it's location.

    my $p1 = Math::Shape::Point->new(0, 0, 0); #new point at 0,0 facing 0 radians.
    my $p2 = Math::Shape::Point->new(1, 2, 0); #new point at 1,2 facing 0 radians.
    $p1->rotate_about_point($p2, 3.14);

=cut

sub rotate_about_point {
    my ($self, $origin, $r) = @_;

    my $nr = $self->normalize_radian($r);
#    $nr = $nr > 0 ? pi2 - $nr
#                  : abs $nr;

    my $s = sin $nr;
    my $c = cos $nr;

    $self->{x} -= $origin->{x};
    $self->{y} -= $origin->{y};

    # rotate point
    my $xnew = $self->{x} * $c - $self->{y} * $s;
    my $ynew = $self->{x} * $s + $self->{y} * $c;

    # translate point back:
    $self->{x} = int $xnew + $origin->{x};
    $self->{y} = int $ynew + $origin->{y};

    $self->rotate($r);
    1;
}

=head2 get_distance_to_point

Returns the distance to another point object. Requires a point object as an argument.

    $p1->get_distance_to_point($p2);

=cut

sub get_distance_to_point {
    sqrt ( abs($_[0]->{x} - $_[1]->{x}) ** 2 + abs($_[0]->{y} - $_[1]->{y}) ** 2);
}

=head2 get_angle_to_point

Returns the angle of another point object. Requires a point as an argument.

    $p1->get_angle_to_point($p2);

=cut

sub get_angle_to_point {
    my ($self, $p) = @_;

    # check points are not at the same location
    if ($self->get_location->[0] == $p->get_location->[0]
        && $self->get_location->[1] == $p->get_location->[1]) 
    {
        croak 'Error: points are at the same location';
    }

    my $atan = atan2($p->{y} - $self->{y}, $p->{x} - $self->{x});

    if ($atan <= 0) { # lower half
        return abs($atan) + pip2 + $self->get_direction;
    }
    elsif ($atan <= pip2)  { # upper right quadrant
        return abs($atan - pip2) + $self->get_direction;
    }
    else { # upper left quadrant
        return pi2 - $atan + pip2 + $self->get_direction;
    }
}

=head2 get_direction_to_point

Returns the direction of another point objection as a string (front, right, back or left). Assumes a 90 degree angle per direction.  Requires a point object as an argument.

    $p1->get_direction_to_point($p2); # front

=cut

sub get_direction_to_point {
    my ($self, $p) = @_;
    my $angle = $self->get_angle_to_point($p);
    if    ($angle > 0 - pip4  && $angle <= pip4)      { return 'front' }
    elsif ($angle > pip4      && $angle <= pi - pip4) { return 'right' }
    elsif ($angle > pi - pip4 && $angle <= pi + pip4) { return 'back'  }
    return 'left';
}

=head2 normalize_radian

Takes a radian argument and returns it between 0 and PI2. Negative numbers are assumed to be backwards (e.g. -1.57 == PI + PI / 2)

=cut

sub normalize_radian {
    my ($self, $radians) = @_;

    my $pi_ratio = $radians / pi2;
    $pi_ratio < 1
        ? $radians
        : $radians - pi2 * int $pi_ratio;
}

=head2 print_coordinates

Prints a small grid and indicates the location of the point with an '@'.

=cut

sub print_coordinates {
    my $self = shift;

    print "Coordinates x: $self->{x}, y: $self->{y}, r: $self->{r}\n";

    # print grid
    my $min_x = $self->{x} + -10;
    my $max_x = $self->{x} + 10;
    my $min_y = $self->{y} + -10;
    my $max_y = $self->{y} + 10;

    print '   ';
    for ($min_x..$max_x) { printf "%3s", $_ }
    printf "%3s", "x\n";
    for my $y (reverse $min_y..$max_y) {
        printf "%3s", $y;
        for my $x ($min_x..$max_x) {
               if ($self->{x} == $x && $self->{y} == $y) { printf "%3s", '@' }
             else { printf "%3s", '.' }
        }
        print "\n";
    }
    printf "%3s", "y\n";
    1;
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
