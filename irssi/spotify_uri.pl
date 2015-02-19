# spotify_uri.pl
# Purpose: converts http:// spotify links to their URI equivalents, so linked tracks open directly in spotify rather than the browser.
# Author: Matthew Connelly <maff@maff.me.uk> [maff@freenode,oftc,furnet]
#
# Version history:
#  1.2: - Fixed bug that would've prevented rewriting in queries/possibly caused a crash
#       - Improved general stability
#  1.1: - Fixed segfault which occurred when the user theirself sent a spotify link
#       - Refined regular expression and consolidated signal handlers into one sub
#       - Colourised spotify URIs to indicate this script dealt with them
#  1.0: - Initial release
#
# Feature wishlist/TODO:
# - Make the spotify regex a configuration option
# - Enable configurable formatting
# - Maybe add an option to retrieve track/album/artist info from the spotify web API?

use strict;
use 5.6.1;
use Irssi;

my $VERSION = "1.1";

my %IRSSI = (
    authors     => "Matthew Connelly",
    contact     => "maff\@maff.scot",
    name        => "spotify_uri",
    description => "Rewrites Spotify URLs to URIs",
    license     => "BSD3",
    url         => "https://maff.scot/",
    changed     => "Thu 26 Jun 2014 23:46:00",
);

my $spotifyex = "(https?:\/\/)?(play|open)\.(spotify)\.com\/([a-z]+)\/([a-zA-Z0-9]+)";

sub msg_rewrite {
	my ($server, $msg, $nick, $address, $target) = @_;
	return if $nick eq $server->{nick};
	return if $msg !~ /$spotifyex/;
	$msg =~ s/$spotifyex/\x02\x0303$3:$4:$5\x0f/g;
	if(defined $target) { Irssi::signal_emit("message public",$server,$msg,$nick,$address,$target); }
	else { Irssi::signal_emit("message private",$server,$msg,$nick,$address); }
	Irssi::signal_stop();
}

Irssi::signal_add('message public'  => \&msg_rewrite);
Irssi::signal_add('message private' => \&msg_rewrite);
