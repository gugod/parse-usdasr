#!/usr/bin/env perl -w
use strict;
use Test::More tests => 1;

use Parse::USDASR;

my @weight_fields = Parse::USDASR->field_names_for("WEIGHT");
ok(@weight_fields > 1);

