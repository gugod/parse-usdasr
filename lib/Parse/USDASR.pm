use strict;
use warnings;
use Rubyish;

class Parse::USDASR {
    use 5.008;
    our $VERSION = '0.01';

    attr_accessor "io";

    my %field_name = (
        FOOD_DES  => [qw(NDB_No FdGrp_Cd Long_Desc Shrt_Desc ComName ManufacName Survey Ref_desc Refuse SciName N_Factor Pro_Factor Fat_Factor CHO_Factor)],
        FD_GROUP  => [qw(FdGrp_Cd FdGrp_Desc)],
        NUT_DATA  => [qw(NDB_No Nutr_No Nutr_Val Num_Data_Pts Std_Error Src_Cd Deriv_Cd Ref_NDB_No Add_Nutr_Mark Num_Studies Min Max DF Low_EB Up_EB Stat_cmt CC)],
        NUTR_DEF  => [qw(Nutr_No Units Tagname NutrDesc Num_Desc SR_Order)],
        SRC_CD    => [qw(Src_Cd SrcCd_Desc)],
        DERIV_CD  => [qw(Deriv_Cd Deriv_Desc)],
        WEIGHT    => [qw(NDB_No Seq Amount Msre_Desc Gm_Wgt Num_Data_Pts Std_Dev)],
        FOOTNOTE  => [qw(NDB_No Footnt_No Footnt_Typ Nutr_No Footnt_Txt)],
        DATASRCLN => [qw(NDB_No Nutr_No DataSrc_ID)],
        DATA_SRC  => [qw(DataSrc_ID Authors Title Year Journal Vol_City Issue_State Start_Page End_Page)],
        ABBREV    => [qw(NDB_No Shrt_Desc Water Energ_Kcal Protein Lipit_Tot Ash Carbonhydrt Fiber_TD Sugar_Tot Calcium Iron Magnesium Phosphorus Potassium Sodium Zinc Copper Manganese Selenium Vit_C Thiamin Riboflavin Niacin Panto_acid Vit_B6 Folate_Tot Folic_acid Food_Folate Folate_DFE Choline_total Vit_B12 Vit_A_IU Vit_A_RAE Retinol Alpha_Carot Beta_Carot Beta_Crypt Lycopene Lut_and_Zea Vit_E Vit_K FA_Sat FA_Mono FA_Poly Cholestrl GmWt_1 GmWt_Desc1 GmWt_2 GmWt_Desc2 Refuse_Pct)]
    );

    def field_names_for {
        my ($filename) = @_;
        $filename =~ s/.txt$//;
        $filename = uc($filename);
        @{$field_name{$filename}};
    }

    def parse_line {
        my ($line) = @_;
        map {
            $a = $_;
            $a =~ s/^\~//;
            $a =~ s/\~$//;
            $a;
        } split /\^/, $line;
    };

    def each_line {
        my $io = $self->io;
        my ($sub) = @_;
        while (my $line = <$io>) {
            chomp($line);
            my $ret = $sub->( $self->parse_line($line) );
            last if defined($ret) && !$ret;
        }
    }
};

1;
__END__

=head1 NAME

Parse::USDASR - Parse USDA Food nutrition standard reference data files.

=head1 SYNOPSIS

  use Parse::USDASR;

  my $parser = Parse::USDASR->new;
  $parser->io(\*STDIN);
  $parser->each_line(
      sub {
          my @fields = @_;
          # ... 
      }
  );

=head1 DESCRIPTION

This module helps you parse the SR21 data files download-able from:

L<http://www.ars.usda.gov/Services/docs.htm?docid=8964>

=head1 METHODS

=over

=item new

Constructor. Takes no args, returns a parser object. The next thing
you should do is to call its C<io> method and assign an IO stream.

=item io( \*FH | $handle )

Attribute accessor. You need to assign an io stream object before
start parsing. You can pass an reference to file handle:

    open FH, "< FOOD_DES.txt";
    $parser->io( \*FH );

Or anything that can be placed inside of the diamond operator (C<< <> >>):

    # An tied IO::All object
    $parser->io( io("FOOD_DES.txt")->tie );

=item each_line(sub { ... })

For each line read from the io stream, call your call back with parsed
fields in C<@_>. Consult the sr21_doc.pdf file for field definition.


  $parser->each_line(
      sub {
          my @fields = @_;
          # ... 
      }
  );

=item field_names_for( $file_name )

Returns the list of field names for the given file. The field definition
is looked up by file name:

    @field_names = Parse::USDASR->field_names_for('WEIGHT.txt');
    # NDB_No, Seq, Amount, Msre_Desc, Gm_Wgt, Num_Data_Pts, Std_Dev

Again, consult the sr21_doc.pdf file for field definition.

=back

=head1 AUTHOR

Kang-min Liu E<lt>gugod@gugod.orgE<gt>

=head1 SEE ALSO

L<http://www.usda.gov/>, L<http://www.nal.usda.gov/fnic/foodcomp/Data/SR21/dnload/>

=head1 LICENSE

Copyright (c) 2009, Kang-min Liu C<< <gugod@gugod.org> >>.

This is free software, licensed under:

    The MIT (X11) License

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENSE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

=cut
