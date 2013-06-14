#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
$\ = "\n";

my $input;

if (@ARGV) {
	$input = $ARGV[0];
}
else {
	$input = 'svg_logo.svg';
}

my $output = 'output';
my $output_opti = $output.'/output_opti';

# my $cmd_opti = "pngcrush -d $output_opti -q -rem text \"%s\"";
my $cmd_opti = "optipng -strip all \"%s\"";

my $cmd_icon1 = "convert \"%s\" -strip -resize 57x57\\!   $output\/57x57.png";
my $cmd_icon2 = "convert \"%s\" -strip -resize 72x72\\!	  $output\/72x72.png";
my $cmd_icon3 = "convert \"%s\" -strip -resize 114x114\\! $output\/114x114.png";
my $cmd_icon4 = "convert \"%s\" -strip -resize 144x144\\! $output\/144x144.png";

my @cmd_launch;

push @cmd_launch, launch_icon(320, 480);
push @cmd_launch, launch_icon(640, 960);
push @cmd_launch, launch_icon(640, 1136);
push @cmd_launch, launch_icon(768, 1004);
push @cmd_launch, launch_icon(1536, 2008);
push @cmd_launch, launch_icon(1024, 748);
push @cmd_launch, launch_icon(2048, 1496);

# convert 1024X1024.PNG -resize "SET1xSET2^" -gravity center -crop SET1xSET2+0+0 +repage SET1XSET2.PNG

# convert 1024X1024.PNG -resize "320x480^" -gravity center -crop 320x480+0+0 +repage 320X480.PNG
# convert 1024X1024.PNG -resize "640x960^" -gravity center -crop 640x960+0+0 +repage 640X960.PNG
# convert 1024X1024.PNG -resize "640x1136^" -gravity center -crop 640x1136+0+0 +repage 640X1136.PNG
# convert 1024X1024.PNG -resize "768x1004^" -gravity center -crop 768x1004+0+0 +repage 768X1004.PNG
# convert 1024X1024.PNG -resize "1536x2008^" -gravity center -crop 1536x2008+0+0 +repage 1536X2008.PNG
# convert 1024X1024.PNG -resize "1024x748^" -gravity center -crop 1024x748+0+0 +repage 1024X748.PNG
# convert 1024X1024.PNG -resize "2048x1496^" -gravity center -crop 2048x1496+0+0 +repage 2048X1496.PNG

open my $out, "+>run.sh" || die "Can't create file: $!\n";
# select $out;
print "mkdir $output";
print "mkdir $output_opti";
process_files($input);
close ($out);

sub launch_icon {
	my ($width, $height) = @_;
	my $param = $width . 'x' . $height;
	# return qq|convert "%s" -resize "$param^" -gravity center -crop $param+0+0 +repage $param.png|;
	return qq|convert "%s" -resize "$param" "$output\/$param.png"|;
}
sub process_files {
	my %file = parse_path(shift);

	# print sprintf $cmd_opti, $file{path};
	mk_opti($file{path}, $file{full});
	print sprintf $cmd_icon1, "$output\/$file{path}";
	print sprintf $cmd_icon2, "$output\/$file{path}";
	print sprintf $cmd_icon3, "$output\/$file{path}";
	print sprintf $cmd_icon4, "$output\/$file{path}";
	for my $cmd (@cmd_launch) {
		print sprintf $cmd, "$output\/$file{path}";
	}
}

sub parse_path {
	my $path = shift;
	my %file;
	my($filename, $directories, $suffix) = fileparse($path, '\.[^\.]*');
	$file{path} = lc $path;
	$file{filename} = lc $filename;
	$file{full} = lc $filename.$suffix;
	$file{directories} = lc $directories;
	$file{directory_output} = lc $output;
	$file{directory_output_opti} = lc $output_opti;
	$file{suffix} = lc $suffix;
	$file{pre} = lc $file{directories}.$file{filename};

	return %file;
}

sub mk_opti {
	my $input_path = shift;
	my $filename = shift;
	# my $output_path_opti = "$directory_output_opti\/$output_filename";
	my $output_path_opti = "$output_opti\/$filename";

	print("cp $input_path \"$output\/$filename\"");
	# strip data
	# print(sprintf $cmd_opti, $input_path);
	print(sprintf $cmd_opti, "$output\/$filename");
	print("mv $output_opti\/$filename $output\/$filename");
}
