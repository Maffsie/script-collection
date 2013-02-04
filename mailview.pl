#!/usr/bin/env perl
# mailview.pl
# This should be added to your ~/.mailcap as: text/html; mailview.pl; copiousoutput

#Encoding stuff
use encoding 'UTF-8';
binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

#Libraries/modules. This is basically the dependencies list.
use Encode;
use HTML::FormatText::WithLinks;

#Main source
#Disable STDERR - This is done so that the bottom of displayed mails isn't perl errors about invalid unicode chars
open STDERR, ">/dev/null";
#Instantiate parser, set it up to output parsed data as "blah blah (http://link-that-blah-was-an-href-for/)"
my $parser = HTML::FormatText::WithLinks->new(
	before_link => '',
	after_link => ' (%l)',
	footnote => ''
);
#Read data in from mutt (stdin)
my $upmail;
while (<STDIN>) {
	last if /^END$/;
	$upmail .= $_;
}
#Parse HTML into plaintext
my $pmail;
$pmail = $parser->parse($upmail);
#Decode UTF8 so that you don't end up with stuff like a\200\223
$pmail = decode_utf8($pmail);
$pmail =~ s/\\xA0/ /g;
#Output back into mutt
print $pmail;
