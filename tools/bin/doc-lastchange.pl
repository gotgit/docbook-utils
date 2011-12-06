#!/usr/bin/perl -w

use strict;
use POSIX;
$ENV{'LANG'} = 'C';
$ENV{'LC_ALL'} = 'C';

sub Usage 
{
	my $usage;
	$usage=<<USAGE;
perl scriptname
    [-query date|version|all] 
    [-dir  <dir/file name>]
USAGE
	printf $usage;
	exit(1);
}

use Getopt::Long; #qw(no_ignore_case);

my ($opt_query, $opt_dir, $opt_repos, $result_v, $result_d, $CMDLINE, $PATTERN_V, $PATTERN_D);

$opt_query = 'all';
$opt_dir  = '.';
$opt_repos="";
$result_v="";
$result_d="";

Getopt::Long::Configure( "no_ignore_case" );

GetOptions ( 
	'query|q=s' => \$opt_query,
	'dir|d=s'  => \$opt_dir,
);

if ($#ARGV == 0)
{
	if ($opt_dir eq '.')
	{
		$opt_dir  = $ARGV[0];
	}
	else
	{
		Usage;
	}
}
elsif ($#ARGV > 0)
{
	Usage;
}

if ( POSIX::access( "$opt_dir/CVS", R_OK ) )
{
	$opt_repos="cvs";
	$CMDLINE="cvs log -r $opt_dir 2>/dev/null|";
	$PATTERN_V='^revision ([0-9\.]*)';
	$PATTERN_D='^date:[\s]*(\d+[\/-]\d+[\/-]\d+(?:[\s]*\d+:\d+:\d+)?)';
}
elsif ( POSIX::access( "$opt_dir/.svn", R_OK ) )
{
	$opt_repos="svn";
	$CMDLINE="svn info $opt_dir 2>/dev/null|";
	$PATTERN_V='^Last Changed Rev:[\s]*(.*)$';
	$PATTERN_D='Last Changed Date:[\s]*(\d+[\/-]\d+[\/-]\d+(?:[\s]*\d+[\/-:]\d+[\/-:]\d+)?)';
}
else
{
	$CMDLINE="";
}

if ($CMDLINE ne "")
{
  open (LOG, $CMDLINE);
  my $checkrev=0;
  my $checkdate=0;
  
  while (my $line = <LOG>)
  {
  	if ( $opt_repos eq "cvs")
  	{
  		if ($line =~ /^Working file: (.*\/)?index.(xml|sgml)/)
  		{
  			$checkrev=1;
  			$checkdate=1;
  			next;
  		}
  		elsif ($line =~ /^Working file: (.*)?\.(xml|sgml)/)
  		{
  			$checkdate=1;
  			next;
  		}
  	}
  	else
  	{
  		$checkrev=1;
  		$checkdate=1;
  	}
  
  	if ($checkrev == 1 && $line =~ /$PATTERN_V/)
  	{
  		if ($result_v lt $1)
  		{
  			$result_v = $1;
  		}
  		$checkrev=0;
  	}
  	elsif ($checkdate == 1 && $line =~ /$PATTERN_D/)
  	{
  		if ($result_d lt $1)
  		{
  			$result_d = $1;
  		}
  		$checkrev=0;
  	}
  
  }
}
elsif ( POSIX::access( "$opt_dir/.git", R_OK ) )
{
	$result_v=`git describe --always --tags`;
	$result_d=`git log -1 --date=short --format="%ad"`;
  chomp $result_v;
  chomp $result_d;
}
else
{
	exit 1;
}

if ($opt_query eq "version")
{
	print $result_v;
}
elsif ($opt_query eq "date")
{
	print $result_d;
}
else
{
	print "Revision: $result_v\nDate: $result_d";
}
