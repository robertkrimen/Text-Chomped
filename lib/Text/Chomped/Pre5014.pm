package Text::Chomped::Pre5014;
use 5.006;
use strict;
use warnings;

our $VERSION = '0.02';  # TRIAL

use vars qw/@ISA @EXPORT/;
@ISA = qw/Exporter/;
@EXPORT = qw/chomped chopped/;

=head1 NAME

Text::Chomped::Pre5014 - Implementation of Text::Chomped on Perl < 5.14

=head1 SYNOPSIS

See L<Text::Chomped>.  This module requires Perl 5.6+.

=head1 FUNCTIONS

=head2 chomped

See L<Text::Chomped>.

=cut

sub _chomped ($)  {
    my $value = $_[0];
    chomp $value;
    return $value;
}

sub chomped ($)  {
    my $value = $_[0];
    if ( ref $value eq 'ARRAY' ) {
        my @result = map { _chomped $_ } @$value;
        return wantarray ? @result : \@result;
    }
    else {
        return _chomped $value;
    }
}

=head2 chopped

See L<Text::Chomped>.

=cut

sub _chopped ($)  {
    my $value = $_[0];
    chop $value;
    return $value;
}

sub chopped ($)  {
    my $value = $_[0];
    if ( ref $value eq 'ARRAY' ) {
        my @result = map { _chopped $_ } @$value;
        return wantarray ? @result : \@result;
    }
    else {
        return _chopped $value;
    }
}

1;
