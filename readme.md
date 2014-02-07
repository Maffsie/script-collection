script-collection
=================

Preface
-------

I write scripts a lot. Partly as a hobby, partly to make my own work easier and partly for my job.

I tend to choose whatever language is most appropriate for what I'm doing, although I usually prefer Bash.

License
-------

Unless otherwise stated, all scripts and code in this repo are licensed under the 3-clause BSD license.

Scripts
-------

This readme contains an up to date list of all scripts in the repo + their descriptions:

- aslookup (and aslookup-new): Perl - Script to look up ASN information for a given IP or ASN. aslookup-new is a rewrite aimed at being more robust and providing more reliably useful data.

- cpanel-rdns-manager: Bash - Script to manage in-addr.arpa zones (and in the future, ip6.arpa zones). Primarily meant to be used on cPanel systems but should be fairly portable to anything that uses bind9.

- mailview: Perl - Script to parse HTML email and format it in a text-reader-friendly way.

- nscheck: Bash - DNS diagnosis script

- watchd & watchd.conf: Bash - Script designed to run as a cronjob, alerting the user to any events.

- wdns: Bash - General-purpose script for managing DNS zones in a bind9 system. Work in progress.
