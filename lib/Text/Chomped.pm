package Text::Chomped;

use warnings;
use strict;
use Import::Into;

our $VERSION = '0.02';  # TRIAL

# This module simply dispatches to a submodule based on the Perl version

sub import {
    my $pkg = shift;
    my $target = caller;
    my $src_pkg = $] lt '5.014' ? 'Pre5014' : 'From5014';
    "Text::Chomped::$src_pkg"->import::into($target, @_);
}

1; # End of Text::Chomped
__END__

=head1 NAME

Text::Chomped - Nondestructive chomp/chop that return the modified string

=head1 SYNOPSIS

    # Old way
    sub sentence {
        my $value = <<_END_
A quick brown fox jumped over the lazy dog
_END_
        chomp $value;
        return $value;
    }

    # New way
    use Text::Chomped;

    sub sentence { chomped <<_END_ }
A quick brown fox jumped over the lazy dog
_END_

    # Chomp a list (have to use [], sorry)

    my @got = chomped [ "A\n", "b", "c\n", ... ]

    # ... or ...
    my $got = chomped [ "A\n", "b", "c\n", ... ]
    $got->[0] # A

=head1 DESCRIPTON

Text::Chomped exports C<chomped> and C<chopped>.  These behave like C<chomp>
and C<chop> except return the cho[mp]ped value rather than what was cho[mp]ped
off (the character) or the count of chomped characters.

Unfortunately subroutine prototyping in Perl cannot ape the builtin chomp/chop
prototype, so you'll have to pass in an ARRAY reference if you want to
chomp/chop a literal list.

=head1 MINIMUM PERL VERSION

This module can run on Perls as old as 5.6.  However, chopping/chomping
C<$_> is only available on Perl 5.14+.

=head2 import

The C<import> function dispatches to an appropriate package using
L<Import::Into> depending on the Perl version.

=head1 ACKNOWLEDGEMENTS

                                  Y\     /Y
                                  | \ _ / |
            _____                 | =(_)= |
        ,-~"     "~-.           ,-~\/^ ^\/~-.
      ,^ ___     ___ ^.       ,^ ___     ___ ^.
     / .^   ^. .^   ^. \     / .^   ^. .^   ^. \
    Y  l    O! l    O!  Y   Y  lo    ! lo    !  Y
    l_ `.___.' `.___.' _[   l_ `.___.' `.___.' _[
    l^~"-------------"~^I   l^~"-------------"~^I
    !\,               ,/!   !                   !
     \ ~-.,_______,.-~ /     \                 /
      ^.             .^       ^.             .^    -Row
        "-.._____.,-"           "-.._____.,-"

                   ->Mr&MrsPacman<-

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-text-chomped at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Text-Chomped>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Text::Chomped

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Text-Chomped>

=item * MetaCPAN

L<https://metacpan.org/pod/Text::Chomped>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009, 2019 Robert Krimen and contributors.  All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

