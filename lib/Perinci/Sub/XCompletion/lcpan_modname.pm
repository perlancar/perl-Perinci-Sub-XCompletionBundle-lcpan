package Perinci::Sub::XCompletion::lcpan_modname;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;
use Log::ger;

use Perinci::Sub::XCompletionBundle::lcpan;
use Complete::Util qw(complete_array_elem);

our %SPEC;

$SPEC{gen_completion} = {
    v => 1.1,
};
sub gen_completion {

    my %fargs = @_;

    sub {
        my %cargs = @_;
        my $word    = $cargs{word} // '';
        my $r       = $cargs{r};

        my $dbh = Perinci::Sub::XCompletionBundle::lcpan::_connect_lcpan()
            or return undef;

        my $sth;
        $sth = $dbh->prepare(
            "SELECT DISTINCT name FROM module ORDER BY name");
        $sth->execute;
        my @all_modnames;
        while (my @row = $sth->fetchrow_array) {
            push @all_modnames, $row[0];
        }
        return complete_array_elem(array=>\@all_modnames, word=>$word);
    }
}

1;
# ABSTRACT: Generate completion of CPAN module names from local CPAN index

=cut
