use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use File::Spec;
use Config;

my $VERSION_FROM = File::Spec->catfile(qw(lib Text Chomped.pm));
my $IS_TRIAL = check_trial();
my $secure_perl_path = get_perl_filename();
my @provides = ();

# Check if this is a TRIAL version {{{1
sub check_trial {
    TRIAL: {
        # Get the VERSION line
        open my $fd, '<', $VERSION_FROM or last TRIAL;
        my $linetext;
        while(<$fd>) {
            next unless /VERSION/;
            $linetext = $_;
            last;
        }
        close $fd;
        return !!($linetext =~ /\bTRIAL\b/);
    }
    return 0;
} #check_trial()

# }}}1
# Module metadata {{{1
eval {
    require Module::Metadata;
    @provides =
        (provides => Module::Metadata->provides(version => '2', dir => 'lib'));
        # Thanks to https://stackoverflow.com/a/28928985/2877364 by LEONT
        # for suggesting Module::Metadata.
};

# }}}1
# Get the filename of the Perl interpreter running this. {{{1
# Modified from perlvar.
# The -x test is for cygwin or other systems where $Config{perlpath} has no
# extension and $Config{_exe} is nonempty.  E.g., symlink perl->perl5.10.1.exe.
# There is no "perl.exe" on such a system.
sub get_perl_filename {
    my $secure_perl_path = $Config{perlpath};
    if ($^O ne 'VMS') {
        $secure_perl_path .= $Config{_exe}
            unless (-x $secure_perl_path) ||
                            ($secure_perl_path =~ m/$Config{_exe}$/i);
    }
    return $secure_perl_path;
} # get_perl_filename()

# }}}1
# Makefile customization (MY) {{{1
{   package MY;

    # dist_core: make `dist` a :: target rather than a : target,
    # and add distcheck before dist.  Also, add -TRIAL to the tgz if necessary.
    sub dist_core {
        my $self = shift;
        my $text = $self->SUPER::dist_core(@_);
        $text =~ s/^dist\s*:[^:]/dist:: distcheck /m;

        # Add -TRIAL if it's a trial release
        if($IS_TRIAL) {
            # Note: we don't have to worry about EOL; Appveyor uses gmake even
            # on Windows, and it only uses \n.
            print STDERR "TRIAL version\n";
            my $newtext .=  # Command to rename the tgz.  TODO see if this works on Windows.
                "\t\"$secure_perl_path\" -MExtUtils::Command -e mv -- " .
                '"$(DISTVNAME).tar$(SUFFIX)" ' .
                '"$(DISTVNAME)-TRIAL.tar$(SUFFIX)"' . "\n";

            # Insert $newtext at the end of the `dist` target
            $text =~ s{
                ^(dist[ \t]*:.*\n      # dist header line
                    (?:[ \t]+\S.*\n)+) # dist body lines.  `.` doesn't match `\n`.
                                    # NOTE: on Appveyor, the continuation line
                                    # begins with a space rather than a tab.
                                    # Therefore, look for horizontal whitespace
                                    # after \n.  Not \s, because that matches a \n!
            }{$1$newtext}mx;
        } #endif $IS_TRIAL

        return $text;
    } # MY::dist_core
} #package MY

# }}}1

# Main options for EUMM
my %opts = (
    NAME             => 'Text::Chomped',
    AUTHOR           => q{Robert Krimen <rkrimen@cpan.org>},
    VERSION_FROM     => $VERSION_FROM,
    ABSTRACT_FROM    => $VERSION_FROM,
    LICENSE          => 'perl_5',
    PL_FILES         => {},
    MIN_PERL_VERSION => '5.006',
    CONFIGURE_REQUIRES => {
        'Config' => '0',
        'ExtUtils::MakeMaker' => '0',
        'File::Spec' => '0',
    },
    TEST_REQUIRES => {
        'Test::Most' => '0',
    },
    PREREQ_PM => {
        'Exporter' => '0',
        'strict' => '0',
        'vars' => '0',
        'warnings' => '0',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Text-Chomped-*' },

    META_MERGE => {
        'meta-spec' => { version => 2 },

        resources => {
            bugtracker => {
                web  => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Text-Chomped',
            },
            repository => {
                type => 'git',
                url  => 'https://github.com/robertkrimen/Text-Chomped.git',
                web  => 'https://github.com/robertkrimen/Text-Chomped',
            },
        },

        prereqs => {
            develop => {
                requires => {
                    'Module::Metadata' => '1.000016',
                },
            },
        },

        x_contributors => [
            'Christopher White <cxw@cpan.org>',
        ],

        @provides,

    }, #META_MERGE
);

$opts{META_MERGE}->{release_status} = 'testing' if $IS_TRIAL;

# Some tests run on older versions of EUMM that do not support TEST_REQUIRES.
# This is a workaround, modified from
# https://metacpan.org/source/RJBS/JSON-Typist-0.005/Makefile.PL .
unless( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
    $opts{PREREQ_PM}->{$_} = $opts{TEST_REQUIRES}->{$_}
        foreach keys %{$opts{TEST_REQUIRES}};
    delete $opts{TEST_REQUIRES};
}

WriteMakefile(%opts);
# vi: set fdm=marker: #
