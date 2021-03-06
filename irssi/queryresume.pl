# QueryResume by Stefan Tomanek <stefan@pico.ruhr.de>
#
use strict;

use vars qw($VERSION %IRSSI);
$VERSION = '2003021201';
%IRSSI = (
	authors     => 'Stefan \'tommie\' Tomanek',
	contact     => 'stefan@pico.ruhr.de',
	name        => 'QueryResume',
	description => 'restores the last lines of a query on re-creation',
	license     => 'GPLv2',
	modules     => 'Date::Format File::Glob',
	changed     => $VERSION,
);  

use Irssi 20020324;
use Date::Format;
use File::Glob ':glob';

sub draw_box ($$$) {
	my ($title, $text, $colour) = @_;
	my $box = '';
	$box .= '%K%U« '.$title.' »%U%n'."\n";
	foreach (split(/\n/, $text)) {
		$box .= '%K'.$_."%n\n";
	}
	$box =~ s/%.//g unless $colour;
	return $box;
}

sub sig_window_item_new ($$) {
	my ($win, $witem) = @_;
	return unless (ref $witem && $witem->{type} eq 'QUERY');
	my $lines = Irssi::settings_get_int('queryresume_lines');
	my $autolog = Irssi::settings_get_str('autolog_path');
	my $name = lc $witem->{name};
	my @t=localtime;
	$autolog =~ s/(\$tag|\$1)/$witem->{server}->{tag}/g;
	$autolog =~ s/\$\{?0\}?/$name/g;
	$autolog = strftime($autolog, @t, undef);
	$autolog =~ s/([\]\[])/\\$1/g;
	$autolog =~ s/\/[\{\}a-zA-Z0-9_\-\.]*$//;
	my @files = get_sorted_files($autolog);
	return unless scalar @files;
	my $filename;
	foreach(@files) {
		$filename=$_ and last if -s $_ >= 300;
	}
	$filename=$files[0] unless $filename or !scalar @files;
	open(F, "<$filename");
	my @data;
	foreach (<F>) {
		next if /^(--- Log|[0-9:]{5} -!-|$)/;
		s/%/%%/g;
		shift(@data) if (@data >= $lines);
		push(@data, $_);
	}
	my $text = join '', @data;
	$lines = scalar @data;
	$witem->print(draw_box("Last $lines lines from log $filename", $text, 1), MSGLEVEL_CLIENTCRAP & MSGLEVEL_NEVER) if $text;
}

sub get_sorted_files ($) {
	my $path = shift; $path =~ s/~/$ENV{HOME}/;
	opendir my($dirh), $path or return;
	my @flist = sort { -M $a <=> -M $b }
				map  { "$path/$_" }
				grep { !/^\.{1,2}$/ }
				readdir $dirh;
	closedir $dirh;
	return @flist;
}

Irssi::settings_add_int($IRSSI{name}, 'queryresume_lines', 10);
Irssi::signal_add('window item new', 'sig_window_item_new');

