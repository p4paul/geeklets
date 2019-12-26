#! /usr/bin/perl

use strict;
use warnings;
         
use Filesys::Df;
use POSIX;


opendir my($dh), "/Volumes" or die "Couldn't open dir: $!";
my @files = readdir $dh;
closedir $dh;

foreach my $disk (@files) {

	my $disk_info = df("/Volumes/" . $disk);

	if (defined($disk_info) && !($disk =~ /\./) && !($disk =~ 'Preboot')) { 
		my $disk_percent = $disk_info->{per};
      
		my $width = 50;
		my $used = ceil($disk_percent * $width / 100);
		my $free = $width - $used;
      
		
		#printf("%-15s %-6s %s◻\n", $disk, "(" . $disk_percent . "%)", "◼" x $used . " " x $free);
		printf("%-15s %-6s %s\n", $disk, "(" . $disk_percent . "%)", "◼" x $used . "-" x $free);
	}
}


