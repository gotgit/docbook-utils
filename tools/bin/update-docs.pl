#!/usr/bin/perl -w

use strict;
use POSIX;
use File::Basename;

$ENV{'LANG'} = 'C';
$ENV{'LC_ALL'} = 'C';

my ($opt_verbose, $opt_version, $opt_help, $opt_outfile, $opt_infile, $opt_src_dir, $opt_doc_dir, $CWD, $DOC_ROOT, $SRC_ROOT);


sub CheckRevDate
{
	my ($dir) = @_;
	my ($opt_repos, $CMDLINE, $PATTERN_V, $PATTERN_D);
	my $checkrev=0;
	my $checkdate=0;
	my $result_v="";
	my $result_d="";
	
	unless (chdir ($dir))
	{
		die ("can not open dir $dir");
	}

	if ( -d "CVS" )
	{
		$opt_repos="cvs";
		$CMDLINE="cvs log -r  2>/dev/null|";
		$PATTERN_V='^revision ([0-9\.]*)';
		$PATTERN_D='^date:[\s]*(\d+[\/-]\d+[\/-]\d+(?:[\s]*\d+:\d+:\d+)?)';
	}
	elsif ( -d ".svn" )
	{
		$opt_repos="svn";
		$CMDLINE="svn info  2>/dev/null|";
		$PATTERN_V='^Last Changed Rev:[\s]*(.*)$';
		$PATTERN_D='Last Changed Date:[\s]*(\d+[\/-]\d+[\/-]\d+(?:[\s]*\d+[\/-:]\d+[\/-:]\d+)?)';
	}
	else
	{
		$CMDLINE="";
	}
	
	if ( -d ".git" )
	{
		$result_v=`git describe --always --tags`;
		$result_d=`git log -1 --date=short --format="%ad"`;
    chomp $result_v;
    chomp $result_d;
	  return ($result_v, $result_d);	
	}
	elsif ($CMDLINE eq "")
	{
		return ("", "");
	}
	
	open (LOG, $CMDLINE);

	while (my $line = <LOG>)
	{
		if ( $opt_repos eq "cvs")
		{
			if ($line =~ /^Working file: (.*\/)?(index\.xml|index\.sgml|\.mm)/)
			{
				$checkrev=1;
				$checkdate=1;
				next;
			}
			elsif ($line =~ /^Working file: (.*)?\.(xml|sgml|mm)/)
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
	
	close (LOG);
	
	return ($result_v, $result_d);	
}


sub draw_icon 
{
	my ($dir, $file, $img) = @_;
	my ($draw_icon);
	if ( -f "$DOC_ROOT/$dir/$file" )
	{
		$draw_icon = "
    <ulink url=\"/doc/$dir/$file\">
      <inlinegraphic fileref=\"/docbook/includes/images/icons/$img\"></inlinegraphic></ulink>";
	}
	else
	{
		$draw_icon = "
    <inlinegraphic fileref=\"/docbook/includes/images/icons/spacer.gif\" width='19' depth='21'></inlinegraphic>";
	}
}

sub draw_scm_icon 
{
	my ($draw_scm_icon);
	my ($doc, $img) = @_;
	$draw_scm_icon = "
      <ulink url=\"https://github.com/gotgit/doc-$doc\">
      <inlinegraphic fileref=\"/docbook/includes/images/icons/$img\"></inlinegraphic></ulink>";
}

sub Usage 
{
	my ($usage,$script);
	
	$script=$0;
	$script =~ s/.*\///;

	$usage=<<USAGE;
Build doc.xml from doc.template...

format: 
    $script [-q|-v] 
            --template=<doc.template> 
            --xml=<doc.xml> 
            --dir=<doc diretory>
	    
    $script  -V|-h

USAGE
	printf $usage;
	exit(1);
}


#################################################
# Getopt... 
#################################################

use Getopt::Long; #qw(no_ignore_case);

$opt_verbose = 1;
$opt_version = 0;
$opt_help = 0;
$opt_outfile = "doc.xml";
$opt_infile  = "doc.template";
$opt_src_dir= ".";
$opt_doc_dir= "../doc";

Getopt::Long::Configure( "no_ignore_case" );

#$result = 
my $opt_valid = GetOptions ( 
	'i|template=s' => \$opt_infile,
	'o|xml=s'      => \$opt_outfile,
	'd|doc=s'      => \$opt_doc_dir,
	's|src=s'      => \$opt_src_dir,
	'v|verbose!'   => \$opt_verbose,
	'q|quiet'      => sub { $opt_verbose = 0 },
	'V|version'    => \$opt_version,
	'h|help'       => \$opt_help,
);

$CWD=`pwd`;
$CWD =~ s/\r?\n//;
$SRC_ROOT = $opt_src_dir =~ /^\// ? $opt_src_dir : "$CWD/$opt_src_dir";
$DOC_ROOT = $opt_doc_dir =~ /^\// ? $opt_doc_dir : "$CWD/$opt_doc_dir";

if ($opt_help || !$opt_valid )
{
	Usage();
}

if ("$opt_infile" eq "")
{
	Usage();
}

if ("$opt_outfile" eq "")
{
	open (OUTFILE, ">&STDOUT")      || die ("Cannot open STDOUT!");
}
else
{
	open (OUTFILE, ">$opt_outfile") || die ("Cannot open outfile ($opt_outfile)!");
}

if ($opt_verbose)
{
	printf ("template file   : %s\n", $opt_infile);
	printf ("output xml file : %s\n", $opt_outfile);
	printf ("doc directory   : %s\n", $DOC_ROOT);
	printf ("src directory   : %s\n", $SRC_ROOT);
}

my ($line);
my (%docs,%dates,%revs,%mmindex,%dbindex);

unless (open (INFILE, "$opt_infile"))
{
	die("can not open file $opt_infile");
}

while ($line = <INFILE>)
{
	if ($line =~ '<!--[\s]*whodo_docs[\s]+(.*)[\s]*-->')
	{
		my ($myline, $doc, $mmindex, $dbindex);
		
		$myline = $1;
		
		$doc  = $1 if ($myline =~ 'doc="(.*?)"');
		if ($doc eq "")
		{
			die("whodo_docs must has a doc element!");
		}

		if ($myline =~ 'dbindex="(.*?)"')
		{
			$dbindex  = $1;
		}
		else
		{
			$dbindex = "index.xml";
		}
		if ($myline =~ 'mmindex="(.*?)"')
		{
			$mmindex  = $1;
		}
		else
		{
			$mmindex = "$doc.mm";
		}

		if (!$docs{$doc})
		{
			$docs{$doc} = 1;
			$dbindex{$doc} = $dbindex;
			$mmindex{$doc} = $mmindex;
		}
		if ($opt_verbose)
		{
			printf ("----- find PI: doc:$doc -----\n");
		}
	}
}

foreach my $doc (sort(keys(%docs)))
{
	my ($opt_repos, $result_v, $result_d, $CMDLINE, $PATTERN_V, $PATTERN_D);
	
	$opt_repos="";
	$result_v="";
	$result_d="";

	$dbindex{$doc}="" unless ( -f "$SRC_ROOT/$doc/".$dbindex{$doc} );
	$mmindex{$doc}="" unless ( -f "$SRC_ROOT/$doc/".$mmindex{$doc} );
	#die ("No documents found in $SRC_ROOT/$doc/") if($dbindex{$doc} eq "" && $mmindex{$doc} eq "");
	if($dbindex{$doc} eq "" && $mmindex{$doc} eq "")
	{
		$dates{$doc} = "";
		$revs{$doc} = "";
		print STDERR "$doc: No documents found in $SRC_ROOT/$doc/";
	}
	else
	{
	
		($result_v, $result_d) = CheckRevDate("$SRC_ROOT/$doc/");
	
		$dates{$doc} = $result_d;
		$revs{$doc} = $result_v;
		print STDERR "$doc: $dates{$doc} | $revs{$doc}\n";
	}
}

seek INFILE, 0, 0;

while ($line = <INFILE>)
{
	if ($line =~ '<!--[\s]*whodo_docs[\s]+(.*)[\s]*-->')
	{
		my ($myline, $type, $doc, $title, $datefrom);
		$myline = $1;

		$myline =~ 'param="(.*?)"';
		$type = $1;

		$myline =~ 'doc="(.*?)"';
		$doc  = $1;

		$myline =~ 'title="(.*?)"';
		$title  = $1;

		$myline =~ 'datefrom="(.*?)"';
		$datefrom  = $1;

		if ($type eq "date")
		{
			$line =~ s/<!--[\s]*whodo_docs[\s]+.*\/whodo_docs[\s]*-->/<!-- whodo_docs param="$type" doc="$doc" -->$dates{$doc}<!-- \/whodo_docs -->/;
		}
		elsif ($type eq "rev")
		{
			$line =~ s/<!--[\s]*whodo_docs[\s]+.*\/whodo_docs[\s]*-->/<!-- whodo_docs param="$type" doc="$doc" -->$revs{$doc}<!-- \/whodo_docs -->/;
		}
		elsif ($type eq "list")
		{
			my $mytext;
			$mytext="
<row>
  <entry role=\"doclist\"><inlinegraphic fileref=\"/docbook/includes/images/icons/dot.png\"></inlinegraphic></entry>
  <entry role=\"doclist\">$datefrom - $dates{$doc}</entry>
  <entry role=\"doclist\"><ulink url=\"/doc/$doc/\" type=\"new\">$title (v$revs{$doc})</ulink></entry>
  <entry role=\"doclist\">";

		  $mytext .= draw_icon( "$doc", $mmindex{$doc}.".htm",     "20/mm.png" );
			$mytext .= draw_icon( "$doc", "$doc.htm",                "20/html.png" );
			$mytext .= draw_icon( "$doc", "index.html",              "20/htmls.png" );
			#$mytext .= draw_icon( "$doc", "$doc-html.tar.bz2",       "20/htmlz.png" );
			#$mytext .= draw_icon( "$doc", "$doc-html-chunk.tar.bz2", "20/htmlsz.png" );
			$mytext .= draw_icon( "$doc", "$doc-chm.tar.bz2",        "20/chmz.png" );
			$mytext .= draw_icon( "$doc", "$doc-pdf.tar.bz2",        "20/pdfz.png" );
			$mytext .= draw_icon( "$doc", "$doc-rtf.tar.bz2",        "20/wordz.png" );
			$mytext .= draw_icon( "$doc", "$doc-txt.tar.bz2",        "20/textz.png" );
			#$mytext .= draw_icon( "$doc", "$doc-xml.tar.bz2",        "20/xmlz.png" );
			$mytext .= draw_scm_icon( $doc,                          "20/git.png" );

			$mytext .= "
  </entry>
</row>";
  			$mytext =~ s/[\r\n]//g;

			$line =~ s/<!--[\s]*whodo_docs[\s]+.*\/whodo_docs[\s]*-->/<!-- whodo_docs param="$type" doc="$doc" title="$title" -->$mytext<!-- \/whodo_docs -->/;
		}
	}

	print OUTFILE "$line";
}
