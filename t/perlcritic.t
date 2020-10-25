use Test2::V0;
use File::Spec::Functions;
use English;

eval {
	require Test::Perl::Critic;
};

if ($EVAL_ERROR) {
   my $msg = 'Test::Perl::Critic required to criticise code';
   plan(skip_all => $msg);
}

my $rcfile = File::Spec->catfile('t', 'perlcriticrc');
Test::Perl::Critic->import(-profile => $rcfile);
all_critic_ok();
