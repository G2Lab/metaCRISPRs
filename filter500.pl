use strict;
use warnings;
use File::Basename;
#use namespace::autoclean;

# Specify working directory
my $directory = "/gpfs/commons/groups/gursoy_lab/knurge/crisprdata4";
opendir(my $dh, $directory) or die "Cannot open directory $directory: $!";
my @files = readdir($dh);
closedir($dh);

#my @files = <*>;
foreach my $file (@files) {
    # Skip files if already filtered
    next if (index($file, "_ftd.fasta") != -1);

    # Skip files unless they end in .fna
    next unless $file =~ /\.fna|\.fasta$/i; 

    # Open file and rename output file
    open my $input_fh, '<', $file or die "Cannot open file '$file' for reading: $!\n";
    my ($name, $path, $ext) = fileparse($file, qr/\.[^.]*/);
    my $output_file = $path . $name . "_ftd.fasta";

    open my $output_fh, '>', $output_file or die "Cannot open file '$output_file' for writing: $!\n";

    local $/=">";
    while(<$input_fh>) {
        chomp;
        next unless /\w/;
        s/>$//gs;
        my @chunk = split /\n/;
        my $header = shift @chunk;
        my $seqlen = length join "", @chunk;
        print $output_fh ">$_" if($seqlen >= 500);
    }
    local $/="\n";

    close $output_fh;
    unlink $file;
}
