use Test::More;
use strict;
use warnings;
use Math::Trig qw/:pi/;
use Test::Exception;

BEGIN { use_ok('Math::Shape::Point', 'use Math::Shape::Point') }
# constructor
ok(my $p = Math::Shape::Point->new(5, 5, 0), 'create new point');
dies_ok sub { Math::Shape::Point->new(1,3) }, 'too few args passed to new()';
dies_ok sub { Math::Shape::Point->new(1,3, 4, undef) }, 'too many args passed to new()';

ok($p->get_location->[0] == 5, 'point x co equals 5');
ok($p->get_location->[1], 'point y co equals 5');

# rotate
ok($p->rotate(pi), 'rotate pi');
ok($p->get_direction == pi, 'point r equals pi');
ok($p->rotate(pip2), 'rotate pi');
ok($p->get_direction == pi + pip2, 'point r equals pi + pip2');
ok($p->rotate(pi), 'rotate pi');
ok($p->set_direction(0), 'set_direction 0');

# create origin point
ok(my $p0 = Math::Shape::Point->new(5, 4, 0), 'create new origin point');
ok($p0->{x} == 5, 'origin point x equals 5');
ok($p0->{y} == 4, 'origin point y equals 4');

# get_distance_to_point
ok($p->get_distance_to_point($p0) == 1, 'get_distance_to_point');
ok(my $p1 = Math::Shape::Point->new(5, 4, 0), 'create new origin point');
ok($p->get_distance_to_point($p1) == 1, 'get_distance_to_point');

# rotate about point 1
ok($p->rotate_about_point($p0, pi2), 'rotate_about_point pi2');
ok($p->{x} == 5, 'point x co equals 5');
ok($p->{y} == 5, 'point y co equals 5');
ok($p->{r} == 0, 'point r equals pi2'); 

# rotate about point 2
ok($p->rotate_about_point($p0, pi), 'rotate_about_point pi');
ok($p->{x} == 5, 'point x co equals 5');
ok($p->{y} == 3, 'point y co equals 3');
ok($p->{r} == pi, 'point r equals pi'); 

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

# reset location for remaining tests
ok $p->set_location(5, 2), 'reset location';

# advance 2
ok $p->rotate(pip2), 'rotate pi/2';
ok $p->advance(4), 'advance 1';
is $p->{x}, 1, 'point x co equals 1';
is $p->{y}, 2, 'point y co equals 2';

# normalize_radian
ok($p->normalize_radian(10), 'normalize_radian 10');
ok(0 == $p->normalize_radian(pi2), 'normalize_radian pi2');
ok($p->normalize_radian(pi), 'normalize_radian pi');
ok($p->normalize_radian(pip2), 'normalize_radian pip2');
ok($p->normalize_radian(pip4), 'normalize_radian pip4');

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
ok($@, 'check exception raised when getDirection called on 2 points at the same location');

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
done_testing();

__END__
