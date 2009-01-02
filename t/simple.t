#!/usr/bin/env perl -w
use strict;
use Test::More tests => 2;

use Parse::USDASR;

my $parser = Parse::USDASR->new;

$parser->each_line(
    \*DATA,
    sub {
        local $, = "\t";
        my (@fields) = @_;
	is 0+@fields, 14;
    }
);

__DATA__
~02041~^~0200~^~Spices, tarragon, dried~^~SPICES,TARRAGON,DRIED~^~~^~~^~~^~~^0^~Artemisia dracunculus~^6.25^2.44^8.37^3.57
~03142~^~0300~^~Babyfood, fruit, applesauce and apricots, strained~^~BABYFOOD,FRUIT,APPLSAUC&APRICOTS,STR~^~~^~~^~Y~^~~^0^~~^6.25^3.36^8.37^3.60
