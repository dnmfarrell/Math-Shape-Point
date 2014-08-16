use Test::More;

use strict;
use warnings;
use Math::Trig qw/:pi/;

BEGIN { use_ok('Math::Shape::Point', 'use Math::Shape::Point') }
ok(my $p = Math::Shape::Point->new(5, 5, 0), 'create new point');
ok($p->getLocation->[0] == 5, 'point x co equals 5');
ok($p->getLocation->[1], 'point y co equals 5');

# rotate
ok($p->rotate(pi), 'rotate pi');
ok($p->getDirection == pi, 'point r equals pi');
ok($p->rotate(pip2), 'rotate pi');
ok($p->getDirection == pi + pip2, 'point r equals pi + pip2');
ok($p->rotate(pi), 'rotate pi');
ok($p->setDirection(0), 'setDirection 0');

# create origin point
ok(my $p0 = Math::Shape::Point->new(5, 4, 0), 'create new origin point');
ok($p0->{x} == 5, 'origin point x equals 5');
ok($p0->{y} == 4, 'origin point y equals 4');

# getDistanceToPoint
ok($p->getDistanceToPoint($p0) == 1, 'getDistanceToPoint');
ok(my $p1 = Math::Shape::Point->new(5, 4, 0), 'create new origin point');
ok($p->getDistanceToPoint($p1) == 1, 'getDistanceToPoint');

# rotate about point 1
ok($p->rotateAboutPoint($p0, pi2), 'rotateAboutPoint pi2');
ok($p->{x} == 5, 'point x co equals 5');
ok($p->{y} == 5, 'point y co equals 5');
ok($p->{r} == 0, 'point r equals pi2'); 

# rotate about point 2
ok($p->rotateAboutPoint($p0, pi), 'rotateAboutPoint pi');
ok($p->{x} == 5, 'point x co equals 5');
ok($p->{y} == 3, 'point y co equals 3');
ok($p->{r} == pi, 'point r equals pi'); 

# advance 1
ok($p->advance(1), 'advance 1');
ok($p->{x} == 5, 'point x co equals 5');
ok($p->{y} == 2, 'point y co equals 2');

# advance 2
ok($p->rotate(pip2), 'rotate pi/2');
ok($p->advance(4), 'advance 1');
ok($p->{x} == 1, 'point x co equals 1');
ok($p->{y} == 2, 'point y co equals 2');

# normalizeRadian
ok($p->normalizeRadian(10), 'normalizeRadian 10');
ok(0 == $p->normalizeRadian(pi2), 'normalizeRadian pi2');
ok($p->normalizeRadian(pi), 'normalizeRadian pi');
ok($p->normalizeRadian(pip2), 'normalizeRadian pip2');
ok($p->normalizeRadian(pip4), 'normalizeRadian pip4');

# getDirection
use Data::Dumper;
ok($p0->setDirection(0), 'set direction 0');
ok($p1->setDirection(0), 'set direction 0');
ok($p0->setLocation(1,1), 'set location 1 1');
ok($p1->setLocation(1,0), 'set location 1 0');
ok('back' eq $p0->getDirectionToPoint($p1), 'get direction back');
ok('front' eq $p1->getDirectionToPoint($p0), 'get direction front');
ok($p1->setLocation(2,0), 'set location 2 0');
ok('right' eq $p0->getDirectionToPoint($p1), 'get direction bottom right');
ok('left' eq $p1->getDirectionToPoint($p0), 'get direction top left');
ok($p1->setLocation(2,1), 'set location 2 1');
ok('right' eq $p0->getDirectionToPoint($p1), 'get direction right');
ok('left' eq $p1->getDirectionToPoint($p0), 'get direction left');
ok($p1->setLocation(2,2), 'set location 2 2');
ok('front' eq $p0->getDirectionToPoint($p1), 'get direction top right');
ok('back' eq $p1->getDirectionToPoint($p0), 'get direction bottom left');
ok($p1->setLocation(1,2), 'set location 1 2');
ok('front' eq $p0->getDirectionToPoint($p1), 'get direction top');
ok('back' eq $p1->getDirectionToPoint($p0), 'get direction bottom');
ok($p1->setLocation(0,2), 'set location 0 2');
ok('left' eq $p0->getDirectionToPoint($p1), 'get direction top left');
ok('right' eq $p1->getDirectionToPoint($p0), 'get direction bottom right');
ok($p1->setLocation(0,1), 'set location 0 1');
ok('left' eq $p0->getDirectionToPoint($p1), 'get direction left');
ok('right' eq $p1->getDirectionToPoint($p0), 'get direction right');
ok($p1->setLocation(0,0), 'set location 0 0');
ok('back' eq $p0->getDirectionToPoint($p1), 'get direction bottom left');
ok('front' eq $p1->getDirectionToPoint($p0), 'get direction top right');
eval { 
    $p0->setLocation(0,0);
    $p0->getDirectionToPoint($p1);
};
ok($@, 'check exception raised when getDirection called on 2 points at the same location');

# negative coordinates tests
ok($p1->setLocation(0,-5), 'set location 0 -5');
ok($p1->getDirectionToPoint($p0) eq 'front', 'getDirectionToPoint from negative y');
ok($p1->getDistanceToPoint($p0) == 5, 'getDistanceToPoint from negative y');
ok($p1->setLocation(-5,-5), 'set location -5 -5');
ok($p1->getDirectionToPoint($p0) eq 'front', 'getDirectionToPoint from negative y and x');
ok(int($p1->getDistanceToPoint($p0)) == 7, 'getDistanceToPoint from negative y and x');
ok($p1->setLocation(-8, 0), 'set location -8 0');
ok($p1->getDirectionToPoint($p0) eq 'right', 'getDirectionToPoint from negative x');
ok($p1->getDistanceToPoint($p0) == 8, 'getDistanceToPoint from negative x');
ok($p0->setLocation(-7, -1), 'set location -7 -1');
ok($p0->getDirectionToPoint($p1) eq 'left', 'getDirectionToPoint from negative x and y');
done_testing();

__END__
