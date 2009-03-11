#!/usr/bin/env perl
use strict;
use warnings;
use feature ':5.10';

use Parse::USDASR;
use IO::All;
use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=sr21.sqlite3", "", "") or die $@;

sub file_to_table {
    my $file = shift;
    local $" = ", ";

    my $table = lc($file);
    $table =~ s/\.txt$//;
    
    my @field_names = Parse::USDASR->field_names_for($file);
    if ( !@field_names ) {
        warn "Unknown $file\n";
        return;
    }
    
    $dbh->do("begin transaction;");
    $dbh->do("CREATE TABLE $table (@field_names);");
    say "Table $table created... ";

    my $insert = $dbh->prepare("INSERT INTO $table VALUES (" . join(",", map {'?'} @field_names )  . ");");
    
    my $parser = Parse::USDASR->new;
    $parser->io( io($file)->tie );
    $parser->each_line(
        sub {
            my @fields = @_;
            $insert->execute(@fields);
        }
    );
    $dbh->do("commit;");
}


for (qw(DATA_SRC.txt DATSRCLN.txt DERIV_CD.txt FD_GROUP.txt
    FOOD_DES.txt FOOTNOTE.txt NUTR_DEF.txt NUT_DATA.txt SRC_CD.txt
    WEIGHT.txt ABBREV.txt)) {
    file_to_table($_);
}
