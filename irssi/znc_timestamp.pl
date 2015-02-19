use strict;

use Irssi;
use Irssi::Irc;
use DateTime;

use vars qw($VERSION %IRSSI);

$VERSION = "0.10";
%IRSSI = (
	authors     => 'Domen Puncer',
	contact     => 'domen@cba.si',
	name        => 'znc_timestamp',
	description => 'Replace znc timestamps with native irssi ones',
	license     => 'GPLv2',
);

my $tf = Irssi::settings_get_str('timestamp_format');
my $prev_date = '';

sub msg {
	action(0,@_);
}
sub act {
	action(1,@_);
}
sub action {
	my ($action,$server, $text, $nick, $address, $target) = @_; my ($time,$date);
	$text =~ /^(?:\x01ACTION )?\[([0-9]{2}:[0-9]{2}):[0-9]{2}\] / and $time = $1 or return;
	Irssi::signal_stop();
	$text =~ s/\[[0-9:]{8}\] //;
	$date = DateTime->now->ymd;
	my $window = Irssi::window_find_item(defined $target? $target : $nick) or undef;
	$window->print("Day changed to $date", MSGLEVEL_NEVER) if defined $window and $date ne $prev_date;
	$prev_date = $date;
	Irssi::settings_set_str('timestamp_format', $time);Irssi::signal_emit('setup changed');
	if(defined $target) {Irssi::signal_emit(($action? 'message irc action' : 'message public'),$server,$text,$nick,$address,$target);}
	else {Irssi::signal_emit('message private',$server,$text,$nick,$address);}
	Irssi::settings_set_str('timestamp_format', $tf);Irssi::signal_emit('setup changed');
}

Irssi::signal_add('message public','msg');
Irssi::signal_add('message private','msg');
Irssi::signal_add('message irc action','act');
