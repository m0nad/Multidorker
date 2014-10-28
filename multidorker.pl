# multidorker - m0nad
# 
# apt-get install libwww-mechanize-perl libyaml-perl
use strict;
use warnings;
use WWW::Mechanize;
use YAML qw(LoadFile);

my $enginefile	= shift;
my $busca	= shift || die "USAGE: perl $0 <engine.yaml> <dork> [config.yaml]\n";
my $configfile	= shift;
my $config	= LoadFile($configfile) if $configfile;
my $engine	= LoadFile($enginefile);
my $mech	= WWW::Mechanize->new();
$mech->proxy(['http', 'ftp'], $config->{proxy}) if $config->{proxy};
$mech->add_header('User-agent' => $config->{agent}) if $config->{agent};

my $page_start = $config->{page_start} || 0;
my $page_end = $config->{page_end} || 100;
my %seen	= ();

for (my $i = $page_start; $i < $page_end; $i++) { 
	my $url = $engine->{url_a} . $busca . $engine->{url_b} . $i . 
		$engine->{url_c};
	$mech->get($url);
	my @links = $mech->links();
	foreach my $link (@links) {
		$url = $link->url();
		next if $seen{$url}++;
		print $url . "\n" if ($url =~ m/^https?/ 
			and $url !~ m/$engine->{filter}/);
	#	print "DESCRIPTION: " . $link->text() . "\n" 
	#	if ($url =~ m/^https?/ and 
	#		$url !~ m/$engine->{filter}/);
	}
}



