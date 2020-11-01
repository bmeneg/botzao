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

my $cfg_topic = 'core';
my $cfg_opt_file = 'log_file';
my $cfg_opt_level = 'log_level';
my %cfg = (
	file => './botzao.log',
	level => LOG_LEVEL_WARN,
);

sub log_error($msg) {
	return if $cfg{level} < LOG_LEVEL_ERROR;

	print STDERR "error: $msg\n";
	open(my $fh, '>>', $cfg{file}) or carp('failed to write to log file');
	print $fh ctime() . " | error: $msg\n";
	close($fh) or carp('failed to close log file');
	return;
}

sub log_fatal($msg) {
	log_error($msg);
	croak('Fatal error');
}

sub log_warn($msg) {
	return if $cfg{level} < LOG_LEVEL_WARN;

	print STDERR "warn: $msg\n";
	open(my $fh, '>>', $cfg{file}) or carp('failed to write to log file');
	print $fh ctime() . " | warning: $msg\n";
	close($fh) or carp('failed to close log file');
	return;
}

sub log_info($msg) {
	return if $cfg{level} < LOG_LEVEL_INFO;

	print STDOUT "info: $msg\n";
	open(my $fh, '>>', $cfg{file}) or carp('failed to write to log file');
	print $fh ctime() . " | info: $msg\n";
	close($fh) or carp('failed to close log file');
	return;
}

sub log_debug($msg) {
	return if $cfg{level} < LOG_LEVEL_DEBUG;

	print STDOUT "debug: $msg\n";
	open(my $fh, '>>', $cfg{file}) or carp('failed to write to log file');
	print $fh ctime() . " | debug: $msg\n";
	close($fh) or carp('failed to close log file');
	return;
}

sub init(%config) {
	my %cfg_log = %{$config{$cfg_topic}};

	$cfg{file} = $cfg_log{$cfg_opt_file} if $cfg_log{$cfg_opt_file};
	$cfg{level} = $cfg_log{$cfg_opt_level} if $cfg_log{$cfg_opt_level};
	return -1 if ($cfg{level} < LOG_LEVEL__LAST);
	return;
}

1;
