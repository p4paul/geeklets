#!/usr/bin/perl

use strict;
use warnings;
use Net::Curl::Easy qw(:constants);
use Data::Dumper;

my $curl = Net::Curl::Easy->new;

$curl->setopt(CURLOPT_HEADER,1);
$curl->setopt(CURLOPT_URL, 'http://feeds.bbci.co.uk/news/rss.xml');

# A filehandle, reference to a scalar or reference to a typeglob can be used here.
my $response_body;
$curl->setopt(CURLOPT_WRITEDATA,\$response_body);

# Starts the actual request
my $retcode = $curl->perform();

my $limit = 120;

my @items = split( /<.item>/, $response_body );
for(my $i=1; $i<8; $i++) {
	$items[$i] =~ /<description><\!\[CDATA\[(.*)\]\]><\/description>/;
	my $line = $1;
	if( length( $line ) > $limit ) {
		my $short = substr( $line, 0, $limit );
		$line = $short . "...";
	}
	print( "● $line\n" );	
}
