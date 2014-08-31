use Test::More;
use 5.008;
use strict;
use warnings;
use Math::Trig qw/:pi/;
use Test::Exception;

BEGIN { use_ok('Math::Shape::Point', 'use Math::Shape::Point') }

# constructor
ok(my $p = Math::Shape::Point->new(5, 5, 0), 'create new point');
dies_ok sub { Math::Shape::Point->new(1,3) }, 'too few args passed to new()';
dies_ok sub { Math::Shape::Point->new(1,3, 4, undef) }, 'too many args passed to new()';

is $p->get_location->[0], 5, 'point x co equals 5';
is $p->get_location->[1], 5, 'point y co equals 5';
is $p->{r}, 0, 'point r equals 0';

# rotate
ok $p->rotate(pi), 'rotate pi';
is $p->get_direction, pi, 'point r equals pi';
ok $p->rotate(pip2), 'rotate pi';
is $p->get_direction, pi + pip2, 'point r equals pi + pip2';
ok $p->rotate(pi), 'rotate pi';
is $p->get_direction, pip2, 'point r equals pip2';
ok $p->rotate(- pip2), 'rotate negative pip2';
is $p->get_direction, 0, 'point r equals 0';

# create origin point
ok my $p0 = Math::Shape::Point->new(4, 4, 0), 'create new origin point';
is $p0->{x}, 4, 'origin point x equals 4';
is $p0->{y}, 4, 'origin point y equals 4';

# get_distance_to_point
is $p->get_distance_to_point($p0), sqrt(2), 'get_distance_to_point';
ok my $p1 = Math::Shape::Point->new(5, 4, 0), 'create new origin point' ;
is $p->get_distance_to_point($p1), 1, 'get_distance_to_point';

# rotate about point 1 360 degrees
ok $p->rotate_about_point($p0, pi2), 'rotate_about_point pi2';
is $p->{x}, 5, 'point x co equals 5';
is $p->{y}, 5, 'point y co equals 5';
is $p->{r}, 0, 'point r equals pi2';

# rotate about point 1 180 degrees
ok $p->rotate_about_point($p0, pi), 'rotate_about_point pi';
is $p->{x}, 3, 'point x co equals 3';
is $p->{y}, 3, 'point y co equals 3';
is $p->{r}, pi, 'point r equals pi';

# rotate about point 1 90 degrees
ok $p->rotate_about_point($p0, pip2), 'rotate_about_point pip2';
is $p->{x}, 5, 'point x co equals 3';
is $p->{y}, 3, 'point y co equals 5';
is $p->{r}, pi + pip2, 'point r equals pi + pip2';

# rotate about point 1 -90 degrees
ok $p->rotate_about_point($p0, - pip2), 'rotate_about_point negative pip2';
is $p->{x}, 3, 'point x co equals 3';
is $p->{y}, 3, 'point y co equals 3';
is $p->{r}, pi, 'point r equals pi';

# rotate about point 1 360 degrees
my $p2 = Math::Shape::Point->new(5,3,0);

ok $p2->rotate_about_point($p0, pi2), 'rotate_about_point pi2';
is $p2->{x}, 5, 'point x co equals 5';
is $p2->{y}, 3, 'point y co equals 3';
is $p2->{r}, 0, 'point r equals pi2';

# rotate about point 1 180 degrees
ok $p2->rotate_about_point($p0, pi), 'rotate_about_point pi';
is $p2->{x}, 3, 'point x co equals 3';
is $p2->{y}, 5, 'point y co equals 5';
is $p2->{r}, pi, 'point r equals pi';

# rotate about point 1 90 degrees
ok $p2->rotate_about_point($p0, pip2), 'rotate_about_point pip2';
is $p2->{x}, 3, 'point x co equals 3';
is $p2->{y}, 3, 'point y co equals 3';
is $p2->{r}, pi + pip2, 'point r equals pi + pip2';

# rotate about point 1 -90 degrees
ok $p2->rotate_about_point($p0, - pip2), 'rotate_about_point negative pip2';
is $p2->{x}, 3, 'point x co equals 3';
is $p2->{y}, 5, 'point y co equals 5';
is $p2->{r}, pi, 'point r equals pi';

# reset point
$p->set_location(5,3);
$p->set_direction(pi);

## $p is now facing PI ##

# advance 1
ok($p->advance(1), 'advance 1');
ok($p->{x} == 5, 'point x co equals 5');
ok($p->{y} == 2, 'point y co equals 2');

# retreat
ok $p->retreat(3), 'retreat 1';
is $p->{x}, 5, 'point x co equals 5';
is $p->{y}, 5, 'point y co equals 5';

# move left
ok $p->move_left(3), 'move_left 3';
is $p->{x}, 8, 'point x co equals 8';
is $p->{y}, 5, 'point y co equals 5';

# move right
ok $p->move_right(9), 'move_left 9';
is $p->{x}, -1, 'point x co equals -1';
is $p->{y}, 5, 'point y co equals 5';

ok $p->rotate(pip2), 'rotate pip2';
is $p->{r}, pi + pip2, 'point faces pi + pip2';

# $p is now facing PI/2

# advance
ok($p->advance(2), 'advance 1');
is $p->{x}, -3, 'point x co equals -3';
is $p->{y}, 5, 'point y co equals 5';

# retreat
ok $p->retreat(1), 'retreat 1';
is $p->{x}, -2, 'point x co equals -2';
is $p->{y}, 5, 'point y co equals 5';

# move left
ok $p->move_left(7), 'move_left 3';
is $p->{x}, -2, 'point x co equals -2';
is $p->{y}, -2, 'point y co equals -2';

# move right
ok $p->move_right(20), 'move_left 9';
is $p->{x}, -2, 'point x co equals -1';
is $p->{y}, 18, 'point y co equals 18';

# normalize_radian
is $p->normalize_radian(pi2),       0,          'normalize_radian pi2';
is $p->normalize_radian(pi),        pi,         'normalize_radian pi';
is $p->normalize_radian(pip2),      pip2,       'normalize_radian pip2';
is $p->normalize_radian(pip4),      pip4,       'normalize_radian pip4';
is $p->normalize_radian(pi2 * 3),   0,          'normalize_radian pi2 * 3';
is $p->normalize_radian(pi * 4),    0,          'normalize_radian pi * 4';
is $p->normalize_radian(pip2 * 5),  pip2,       'normalize_radian pip2 5 3';
is $p->normalize_radian(pip4 * 14), pi + pip2,  'normalize_radian pip4 * 14';

# get_direction
ok($p0->set_direction(0), 'set direction 0');
ok($p1->set_direction(0), 'set direction 0');
ok($p0->set_location(1,1), 'set location 1 1');
ok($p1->set_location(1,0), 'set location 1 0');
ok('back' eq $p0->get_direction_to_point($p1), 'get direction back');
ok('front' eq $p1->get_direction_to_point($p0), 'get direction front');
ok($p1->set_location(2,0), 'set location 2 0');
ok('right' eq $p0->get_direction_to_point($p1), 'get direction bottom right');
ok('left' eq $p1->get_direction_to_point($p0), 'get direction top left');
ok($p1->set_location(2,1), 'set location 2 1');
ok('right' eq $p0->get_direction_to_point($p1), 'get direction right');
ok('left' eq $p1->get_direction_to_point($p0), 'get direction left');
ok($p1->set_location(2,2), 'set location 2 2');
ok('front' eq $p0->get_direction_to_point($p1), 'get direction top right');
ok('back' eq $p1->get_direction_to_point($p0), 'get direction bottom left');
ok($p1->set_location(1,2), 'set location 1 2');
ok('front' eq $p0->get_direction_to_point($p1), 'get direction top');
ok('back' eq $p1->get_direction_to_point($p0), 'get direction bottom');
ok($p1->set_location(0,2), 'set location 0 2');
ok('left' eq $p0->get_direction_to_point($p1), 'get direction top left');
ok('right' eq $p1->get_direction_to_point($p0), 'get direction bottom right');
ok($p1->set_location(0,1), 'set location 0 1');
ok('left' eq $p0->get_direction_to_point($p1), 'get direction left');
ok('right' eq $p1->get_direction_to_point($p0), 'get direction right');
ok($p1->set_location(0,0), 'set location 0 0');
ok('back' eq $p0->get_direction_to_point($p1), 'get direction bottom left');
ok('front' eq $p1->get_direction_to_point($p0), 'get direction top right');
eval {
    $p0->set_location(0,0);
    $p0->get_direction_to_point($p1);
};
ok($@, 'check exception raised when get_direction called on 2 points at the same location');

# negative coordinates tests
ok($p1->set_location(0,-5), 'set location 0 -5');
ok($p1->get_direction_to_point($p0) eq 'front', 'get_direction_to_point from negative y');
ok($p1->get_distance_to_point($p0) == 5, 'get_distance_to_point from negative y');
ok($p1->set_location(-5,-5), 'set location -5 -5');
ok($p1->get_direction_to_point($p0) eq 'front', 'get_direction_to_point from negative y and x');
ok(int($p1->get_distance_to_point($p0)) == 7, 'get_distance_to_point from negative y and x');
ok($p1->set_location(-8, 0), 'set location -8 0');
ok($p1->get_direction_to_point($p0) eq 'right', 'get_direction_to_point from negative x');
ok($p1->get_distance_to_point($p0) == 8, 'get_distance_to_point from negative x');
ok($p0->set_location(-7, -1), 'set location -7 -1');
ok($p0->get_direction_to_point($p1) eq 'left', 'get_direction_to_point from negative x and y');

# coordinates
ok $p->print_coordinates;

done_testing();

__END__
