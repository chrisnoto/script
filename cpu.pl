#!/usr/bin/perl -w
##Show overall CPU utilization of the system
##This is a part of the post http://phoxis.org/2013/09/05/finding-overall-and-per-core-cpu-utilization
# 
use strict;
use warnings;
use List::Util qw(sum);
use Fcntl;
 
my $idle_old = 0;
my $total_old = 0;
   
open (my $STAT, "/proc/stat") or die ("Cannot open /proc/stat\n");
while (1)
  {
    seek ($STAT, Fcntl::SEEK_SET, 0);
     
        while (<$STAT>)
          {
              next unless ("$_" =~ m/^cpu\s+/);
               
                   my @cpu_time_info = split (/\s+/, "$_");
                       shift @cpu_time_info;
                           my $total = sum(@cpu_time_info);
                               my $idle = $cpu_time_info[3];
                                
                                    my $del_idle = $idle - $idle_old;
                                        my $del_total = $total - $total_old;
                                         
                                             my $usage = 100 * (($del_total - $del_idle)/$del_total);
                                              
                                                  printf ("Total CPU Usage: %0.2f%%\n", $usage);
                                                   
                                                       $idle_old = $idle;
                                                           $total_old = $total;
                                                             }
                                                               sleep 1;
                                                               }
                                                         close ($STAT);
