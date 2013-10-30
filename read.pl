#!/usr/bin/perl 

print "\nHello!\n\n";
exit;

open INFILE, $ARGV[0] or die $!;
my $polariz = $ARGV[0];
$polariz =~ s/ANTENNE//g;
$polariz =~ s/RICHTIG.out//g;


my $OUTFILE;

my $freq;
my $FLAGS = {};

while(<INFILE>){
				my $line = $_;
				if ($line =~ /FREQUENCY=(.*)/){
								$freq = $line;
								$freq =~ s/^\s+FREQUENCY= //g;
								$freq =~ s/000E\+01 MHZ\s*$//g;

								print "frequency= $freq\n";
								`rm "$polariz""_$freq"`;
					open $OUTFILE, ">>$polariz"."_$freq" or die $!;
				}
				if ($line =~ /^  -90.00     0.00    /){
					$FLAGS->{next_is_data} = 1;
				}
				if ($FLAGS->{next_is_data} == 1){
					# unless ($line =~ /^\s*$/ or $line =~ /ANGLES/ or  $line =~ /THETA/ or $line =~ /DEGREES/  or $line =~ /RADIATION PATTERN/){
						my $data = $line;
						my @data = split (/\s+/, $data);
						#print "$data[1]\n";
						#print "$data[2]\n";
						#print "$data[3]\n";
						#print "$data[4]\n";
						#print "$data[5]\n";
						print $OUTFILE "$data[1]:$data[2]:$data[3]:$data[4]:$data[5]\n";
						#$data =~ s/^\://g;
						#print "$data\n";
						#$data =~ s/\:.*\:.*\:.*$//g;
						#print "$data\n";
					# }
					if ($line =~ /^   90.00   360.00    /){
						$FLAGS->{next_is_data} = 0;
						#$print "END Of Data ,$FLAGS->{end_of_data_count}";
					}
					if ($FLAGS->{end_of_data}){
						close $OUTFILE;
					}
				}
#print $_;
}

