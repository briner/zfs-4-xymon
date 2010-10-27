#!/usr/bin/perl

# unknown    Fabrice.DiPasquale@unige.ch
#            created
#
# 2010.02.01 Cedric.Briner@unige.ch
#            modified to take in account the new format of zfs_pool
#            which contains now more information on the zpool
#            passed  $LINE_COLOR, $NAME, $CAP, $HEALTH
#            to      $LINE_COLOR, $NAME, $SIZE, $USED, $AVAIL, $CAP, $HEALTH

use strict;
use warnings;

my $hostname=$ARGV[0]; 
my $testname=$ARGV[1]; 
my $fname   =$ARGV[2];

#qx(cp -p $fname /tmp/fab.out);


open(IN,$fname);

if ($testname  =~ /^zfs$/) {
  while (my $line = <IN>) {
    if ($line =~ /^\s+<!--LineToGraph:zfs_v1.1 name:(\S+) cap:(\S+) cap_2:(\S+)/)
    {
      my $name_rrd = $1;
      $name_rrd =~ tr/\//,/;
      my $cap = $2;
      my $cap_2=$3;
      # print used
      #
      print "DS:pct:GAUGE:600:0:100\n"; 
      print "zfs.$name_rrd.rrd\n";
      print "$cap\n";    
      # print used_2
      #      
      print "DS:pct:GAUGE:600:0:100\n"; 
      print "zfs.$name_rrd,.rrd\n";
      print "$cap_2\n";    
    }
    elsif ($line =~ /^\s+<!--LineToGraph:zfs_v1.2 name:(\S+) cap_2:(\S+)/)
    {
      my $name_rrd=$1;
      $name_rrd =~ tr/\//,/;
      my $cap_2=$2;
      #
      # print used_2
      print "DS:pct:GAUGE:600:0:100\n"; 
      print "zfs.$name_rrd,.rrd\n";
      print "$cap_2\n";    
    }
  }
}




if ($testname =~ /^zfs_pool$/) {
  while (my $line = <IN>) {
    chomp($line);
#   if ($line =~ /^<!--LineToGraph--><tr><td>&(green|yellow|red)<\/td><td>(\w+)<\/td><td>(\w+)%<\/td><td>/)

#                                                     $1                   $2              $3             $4
#                                               &$LINE_COLOR              $NAME           $CAP%         $HEALTH
    if ($line =~ /^<!--LineToGraph--><tr><td>&(green|yellow|red)<\/td><td>([^<]+)<\/td><td>([^<]+)%<\/td><td>([^<]+)<\/td><\/tr>/)
#    if ($line =~ /^<!--LineToGraph--><tr><td>&(green|yellow|red)<\/td><td>(.+)<\/td><td>(.+)%<\/td><td>(.+)<\/td><\/tr>/)
    {
      print "DS:pct:GAUGE:600:0:100\n"; 
      print "zfs_pool.$2.rrd\n";
      print "$3\n";
    }
#                                                 $1                         $2             $3              $4                $5            $6              $7
#                                           &$LINE_COLOR                    $NAME          $SIZE           $USED            $AVAIL         $CAP%          $HEALTH
#                                                                         root_pool        136G            15.8G             120G           11%            ONLINE
    elsif ($line =~ /^<!--LineToGraph--><tr><td>&(green|yellow|red)<\/td><td>([^<]+)<\/td><td>([^<]+)<\/td><td>([^<]+)<\/td><td>([^<]+)<\/td><td>([^<]+)%<\/td><td>([^<]+)<\/td><\/tr>/)
#    elsif ($line =~ /^<!--LineToGraph--><tr><td>&(green|yellow|red)<\/td><td>(.+)<\/td><td>(.+)<\/td><td>(.+)<\/td><td>(.+)<\/td><td>(.+)%<\/td><td>(.+)<\/td><\/tr>/)
    {
      print "DS:pct:GAUGE:600:0:100\n"; 
      print "zfs_pool.$2.rrd\n";
      print "$6\n";
    }
  }
}


if ($testname =~ /^zfs_fs$/) {
  while (my $line = <IN>) {
    chomp($line);
    if ($line =~ /^<!--LineToGraph--><tr><td>&(green|yellow|red)<\/td><td>(\S+)<\/td><td>(\w+)%<\/td><\/tr>/) {
      my $tmp = $2;
      $tmp =~ tr/\//\,/;
      print "DS:pct:GAUGE:600:0:100\n";
      print "zfs_fs.$tmp.rrd\n";
      print "$3\n";
    }
  }
}

close(IN);






