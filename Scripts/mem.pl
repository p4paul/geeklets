#! /usr/bin/perl

use strict;
use warnings;

use Sys::MemInfo;
use Data::Dumper;
use POSIX;

my $tmem = Sys::MemInfo::get("totalmem") / 1024;
my $umem = Sys::MemInfo::get("freemem") / 1024;
my $pmem = $umem / $tmem * 25;

graph("Memory", $pmem);


# Pages from vmstat
my $mem_size = 24*1024*1024*1024;
my $page_size = 4096;
my @vmstat = `vm_stat | grep '^Pages'`;
my $hash;

foreach my $x (@vmstat) {
	chomp $x;
	$x =~ /(.*):\s+(.*)./;
	$hash->{$1} = $2;
}

my $wired = $hash->{'Pages wired down'} * $page_size / $mem_size * 100;
my $active = $hash->{'Pages active'} * $page_size / $mem_size * 100;
my $inactive = $hash->{'Pages inactive'} * $page_size / $mem_size * 100;

graph("Pages wired", $wired);
graph("Pages active", $active);
graph("Pages inactive", $inactive);

sub graph {
    my $title = shift;
    my $percent = shift;
    
    my $width = 50;
	my $used = ceil($percent * $width / 100);
	my $free = $width - $used;

	printf("%-15s (%-2d%)  %s\n", $title, $percent, "◼" x $used . "-" x $free);
	#printf("%-15s (%-2d%)  %s◻\n", $title, $percent, "◼" x $used . " " x $free);
}
