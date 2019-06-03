#!/usr/bin/perl -w

use strict;
use warnings;

use Test::Most;

plan qw/no_plan/;

use Text::Chomped;

for("42\n") {
    is chomped, '42';
    is chopped, '42';
}

my $x = "1337\n";
for($x) {
    is chomped, '1337';
    is $x, "1337\n";
    is chopped, '1337';
    is $x, "1337\n";
}

my @vals = map { chomped } "a\n", "b", "c\n";
cmp_deeply( \@vals, [qw(a b c)] );

@vals = map { chopped } "a\n", "b", "c\n";
cmp_deeply( \@vals, ['a', '', 'c']);

for(["a\n", "b", "c\n"]) {
    my $vals = chomped;
    cmp_deeply( $vals, [qw(a b c)] );
    @vals = chomped;
    cmp_deeply( \@vals, [qw(a b c)] );

    $vals = chopped;
    cmp_deeply( $vals, ['a', '', 'c']);
    @vals = chopped;
    cmp_deeply( \@vals, ['a', '', 'c']);
}

1;
