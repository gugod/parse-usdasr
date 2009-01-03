#!/usr/bin/env perl -w
use strict;
use Test::More tests => 3;

use Parse::USDASR;

my $pos = tell(DATA);

my $parser = Parse::USDASR->new;
$parser->io(\*DATA);

my $i = 0;
$parser->each_line(sub { $i ++ ; return 0; });
is($i, 1);

seek(DATA, $pos, 0);

$i = 0;
$parser->each_line(sub { $i++ ; return 1; });
is($i, 2);

seek(DATA, $pos, 0);

$i = 0;
$parser->each_line(sub { $i++; return });
is($i, 2);

__DATA__
~02041~^~0200~^~Spices, tarragon, dried~^~SPICES,TARRAGON,DRIED~^~~^~~^~~^~~^0^~Artemisia dracunculus~^6.25^2.44^8.37^3.57
~03142~^~0300~^~Babyfood, fruit, applesauce and apricots, strained~^~BABYFOOD,FRUIT,APPLSAUC&APRICOTS,STR~^~~^~~^~Y~^~~^0^~~^6.25^3.36^8.37^3.60
