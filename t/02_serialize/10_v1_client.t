#!/usr/bin/perl

use lib q{./t/lib };
use strict;
use warnings;

use Communication::v1Serialization;
Communication::v1Serialization->runtests();
