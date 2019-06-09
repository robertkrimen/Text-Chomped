#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use Text::Chomped;

# Make sure it's nondestructive
my $var = "hello\n";
is( chopped $var, 'hello' );
is( $var, "hello\n" );
is( chomped $var, 'hello' );
is( $var, "hello\n" );

# Trailing non-newlines
is( chomped 'bar', 'bar' );
is( chopped 'bar', 'ba' );

# More sophisticated tests
sub sentence { chomped <<_END_ }
A quick brown fox jumped over the lazy dog
_END_

is( sentence, "A quick brown fox jumped over the lazy dog" );
is( chopped "Xyzzy", "Xyzz" );
cmp_deeply( scalar chomped [ "A\n", "b", "c\n" ], [qw/ A b c /] );
cmp_deeply( scalar chopped [ "A\n", "b", "c\n" ], [ 'A', '', 'c' ] );

my @vals = chomped [ "A\n", "b", "c\n" ];
cmp_deeply( \@vals, [qw/ A b c /] );
@vals = chopped [ "A\n", "b", "c\n" ];
cmp_deeply( \@vals, [ 'A', '', 'c' ]);

1;
