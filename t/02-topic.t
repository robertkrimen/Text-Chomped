#!/usr/bin/perl -w
# 02-topic.t: Tests of cho[mp]ped with $_ as an implicit argument
use strict;
use warnings;

use Test::Most;

BEGIN {
    # Need this in a BEGIN because the rest of the file can't compile on
    # Perl < 5.014.
    plan skip_all => 'Topic is unsupported on Perl < 5.14' if $] lt '5.014';
}

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

done_testing;
