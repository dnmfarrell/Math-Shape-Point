#!perl -T
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Math::Shape::Point' ) || print "Bail out!\n";
}

diag( "Testing Math::Shape::Point $Math::Shape::Point::VERSION, Perl $], $^X" );
