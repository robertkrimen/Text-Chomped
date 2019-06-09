package Text::Chomped::From5014;
use 5.014;
use strict;
use warnings;

our $VERSION = '0.02';  # TRIAL

use vars qw/@ISA @EXPORT/;
@ISA = qw/Exporter/;
@EXPORT = qw/chomped chopped/;

=head1 NAME

Text::Chomped::From5014 - Implementation of Text::Chomped on Perl 5.14+

=head1 SYNOPSIS

See L<Text::Chomped>.  This module requires Perl 5.14+.

=head1 FUNCTIONS

=head2 chomped

See L<Text::Chomped>.

=cut

sub chomped(;+) {
    my @retvals;

    # Process $_ by default
    push @_, $_ unless @_;

    # Accept an arrayref for "chomped [qw(...)]".
    # Note that this also means we take `for([...]) { chomped }`
    @_ = @{$_[0]} if ref $_[0] eq 'ARRAY';

    # Chomp each value
    foreach my $val (@_) {
        my $s = $val;
        chomp $s;
        push @retvals, $s;
    }

    # Only one return value (e.g., from `chomped` on $_)
    return $retvals[0] unless $#retvals;

    # Multiple return values: array or arrayref
    return wantarray ? @retvals : \@retvals;
} #chomped()

=head2 chopped

See L<Text::Chomped>.

=cut

sub chopped(;+) {
    my @retvals;

    # Process $_ by default
    push @_, $_ unless @_;

    # Accept an arrayref for "chopped [qw(...)]".
    # Note that this also means we take `for([...]) { chopped }`
    @_ = @{$_[0]} if ref $_[0] eq 'ARRAY';

    # Chop each value
    foreach my $val (@_) {
        my $s = $val;
        chop $s;
        push @retvals, $s;
    }

    # Only one return value (e.g., from `chopped` on $_)
    return $retvals[0] unless $#retvals;

    # Multiple return values: array or arrayref
    return wantarray ? @retvals : \@retvals;
} #chopped()

1;
