#!/usr/bin/perl

use strict;
use File::Slurp qw/read_file write_file/;
use DateTime;

#####
# Script for updating the wmk documentation site from the wmk readme file.
# Must be invoked from the base project directory, i.e. ./bin/autodoc.pl.
#
# Currently the only markdown content which is not part of the readme file
# and thus needs to be (occasionally) edited by hand is content/index.md.
######

die "FATAL: Must be run in the wmk-docs dir: cannot find ./content/\n"
    unless -d "./content";
die "FATAL: Must be run in the wmk-docs dir: cannot find ./wmk_config.yaml/\n"
    unless -f "./wmk_config.yaml";

my ($version, $pubdate, $wmk_home) = get_wmk_info();
die "Need a wmk installation" unless $version && $wmk_home;
$pubdate ||= DateTime->now->ymd;

my @content = read_file("$wmk_home/readme.md");
die "Need content for processing. No readme.md in $wmk_home?" unless @content;

write_file("./content/index.yaml", "pubdate: $pubdate\nversion: $version\n");

my ($buf, $fn, $title, $weight);

foreach my $line (@content) {
    if ($line =~ /^<!-- (\w+) "([^"]+)" (\d+) -->/) {
        write_content($buf, $fn, $title, $weight);
        $fn = $1;
        $title = $2;
        $weight = $3;
        $buf = '';
        next;
    }
    next unless $fn;
    $buf .= $line;
}
write_content($buf, $fn, $title, $weight) if $fn;


### SUBS BELOW

sub write_content {
    my ($buf, $fn, $title, $weight) = @_;
    return unless $fn;
    $buf = qq[---
title: "$title"
slug: $fn
weight: $weight
---

] . $buf;
    $buf =~ s!\b([Ss]ee) (?:the )?"([^"]+)" section(?: below)?!$1 {{< linkto("$2") >}}!g;
    write_file("./content/$fn.md", $buf);
}

sub get_wmk_info {
    my $home_info = qx/wmk info ./;
    my $vers_info = qx/wmk --version/;
    my $wmk_home = $1 if $home_info =~ / home: (.*)$/m;
    my $version = $1 if $vers_info =~ / version (\S+)/;
    my $pubdate;
    if ($version && $wmk_home) {
        my $pubinfo = qx/cd "$wmk_home" && git show --pretty=%ai --stat v$version/;
        $pubdate = $1 if $pubinfo =~ /^([\d-]+) /;
    }
    return ($version, $pubdate, $wmk_home);
}
