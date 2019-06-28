#!/usr/bin/perl -w
# Filename : client.pl

use strict;
use Socket;

my $file= shift;
open(DATA2,">$file");
# initialize host and port
my $host = 'localhost';
my $port = 7891;
my $server = "localhost";  # Host IP running the server

# create the socket, connect to the port
socket(SOCKET,PF_INET,SOCK_STREAM,(getprotobyname('tcp'))[2])
   or die "Can't create a socket $!\n";
   connect( SOCKET, pack_sockaddr_in($port, inet_aton($server)))
      or die "Can't connect to port $port! \n";

      my $line;
      while ($line = <SOCKET>) {
              print DATA2 $line;
              }
              close SOCKET or die "close: $!";
close(DATA2);
