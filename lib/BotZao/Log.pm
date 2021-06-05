# The logging system is somewhat the same for every project.
# All call to the log_* functions stores the log in a specific file (possibly
# defined in the config file) and also print to STDOUT.
# TODO: allow an option (--quiet ?) to disable logging to STDOUT.

package BotZao::Log;

use v5.20;
use warnings;
use strict;

use feature qw(signatures);
no warnings qw(experimental::signatures);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(log_error log_fatal log_warn log_info log_debug);

use Carp;
use Time::localtime;

use constant {
	LOG_LEVEL_NONE => 0,
	LOG_LEVEL_ERROR => 1,
	LOG_LEVEL_WARN => 2,
	LOG_LEVEL_INFO => 3,
	LOG_LEVEL_DEBUG => 4,
	LOG_LEVEL__LAST => 5,
};

# log default values
my $DEFAULT_LOG_FILE = './botzao.log';
my $DEFAULT_LOG_LEVEL = LOG_LEVEL_WARN;

my $cfg_topic = 'core';
my $cfg_opt_file = 'log_file';
my $cfg_opt_level = 'log_level';
my %cfg = (
	file => undef,
	level => 0,
);

sub _do_log($prefix, $msg) {
	my ($pkg, undef, $line) = caller(1);
	$pkg =~ s/BotZao:://;
	my $text = "$prefix ${pkg}[$line]: $msg";

	print STDOUT "$text\n";
	open(my $fh, '>>', $cfg{file}) or carp('failed to write to log file');
	print $fh ctime() . " | $text\n";
	close($fh) or carp('failed to close log file');
	return;
}

sub log_error($msg) {
	return if $cfg{level} < LOG_LEVEL_ERROR;
	_do_log('ERROR', $msg);
	return;
}

sub log_fatal($msg) {
	log_error($msg);
	croak('FATAL ERROR');
}

sub log_warn($msg) {
	return if $cfg{level} < LOG_LEVEL_WARN;
	_do_log('WARN', $msg);
	return;
}

sub log_info($msg) {
	return if $cfg{level} < LOG_LEVEL_INFO;
	_do_log('INFO', $msg);
	return;
}

sub log_debug($msg) {
	return if $cfg{level} < LOG_LEVEL_DEBUG;
	_do_log('DEBUG', $msg);
	return;
}

sub init(%config) {
	my %cfg_log = %{$config{$cfg_topic}};

	# prefer the values stored in the config file
	$cfg{file} = $cfg_log{$cfg_opt_file} // $DEFAULT_LOG_FILE;
	$cfg{level} = $cfg_log{$cfg_opt_level} // $DEFAULT_LOG_LEVEL;
	return -1 if ($cfg{level} < LOG_LEVEL__LAST);
	return;
}

1;
