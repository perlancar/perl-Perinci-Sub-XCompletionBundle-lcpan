package Perinci::Sub::XCompletion::lcpan_authorid;

# DATE
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
            "SELECT cpanid FROM author WHERE cpanid LIKE '$word%' ORDER BY cpanid");
        $sth->execute;
        my @all_authors;
        while (my @row = $sth->fetchrow_array) {
            push @all_authors, $row[0];
        }
        return complete_array_elem(array=>\@all_authors, word=>$word);
    }
}

1;
# ABSTRACT: Generate completion of CPAN author IDs from local CPAN index

=cut
