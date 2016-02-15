#!/usr/bin/env perl
use warnings;
use strict;
use Test::More;
use Dist::HomeDir;
use lib 't/lib';
use Test::DistHome;
diag Dist::HomeDir::dist_home->relative;
# unfortunately running with make test results in blib rather than the dist root
# This is actually irelevant for the use case of this module so here's a crude workaround.
like Dist::HomeDir::dist_home->relative, qr/^\.|blib$/, "Got dist root from test";
like Test::DistHome::test_get_home->relative, qr/^\.|blib$/, "Got dist home from support file";

done_testing;
