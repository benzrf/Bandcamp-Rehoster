#!/usr/bin/perl
use LWP::Simple;

($al = get(shift)) =~ m#<link rel="alternate" type="application/rss\+xml" title="[^"]*" href="[^"]*">[\s\n]*<link rel="alternate" type="application/rss\+xml" title="([^"]*)"#;
$at = $1;
$at =~ s/'/'"'"'/g;
mkdir "mp4s";
chdir "album";
for (<*.mp3>)
{
	$if = s/mp3$/jpg/r;
	$if =~ s/'/'"'"'/g;
	$of = s/3$/4/r;
	$of =~ s/'/'"'"'/g;
	$of = "$at - $of";
	system("convert -resize 1920x1080 '$if' 'big.$if'") == 0 or exit 1;
	system("ffmpeg -i '$_' -f image2 -loop 1 -i 'big.$if' " .
		"-r 24 -c:v libx264 -crf 18 -tune stillimage -c:a " .
		"aac -strict -2 -b:a 192k -shortest '../mp4s/$of'") == 0 or exit 1;
}
system "clear";

