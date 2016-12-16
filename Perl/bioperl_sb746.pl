#!/usr/bin/perl -w
use Bio::Tools::Run::RemoteBlast;
use Bio::DB::GenPept;
use Bio::SearchIO;
use Bio::SeqIO;
use strict;
# by sb746
# a program that will call upon a remote blast of a specified fasta sequence
# record the result. Pass the top ten searches to MUSCLE to peform an aligment
# finally open up in clustalx

#file to store the raw resut of the remote blast search
my $filename = "sp|P11802|CDK4_HUMAN.out";

#make sequence object useing Bioperl class SeqIO useing a fasta sequence
my $seqioObj = Bio::SeqIO->new(
    -file => 'P11802.fasta',
    -format => 'fasta');

# parmeters in an array to be used in remote blast
my @searchparams = ( 
    '-prog' => 'blastp',
    '-data' => 'swissprot',
    '-expect' => '1e-10',
    '-readmethod' => 'SearchIO');

# set up of a remote blast  object useing the paparmeters described earlier and bioperl
#classes
my $remote_blast = Bio::Tools::Run::RemoteBlast->new(@searchparams);

#to tract the waiting bar
my $msg = 1;

# set $input = to the 1st sequence in the sequence object 
my $input = $seqioObj->next_seq();

# use this input sequence for an argument for the remote balst object created eariler
# with the command submit_blast
my $command_submit = $remote_blast->submit_blast($input);

# print waiting while wainting for results from server
print STDERR "waiting#" if( $msg > 0 );

#code edited from CPAN website http://search.cpan.org/dist/BioPerl/Bio/Tools/Run/RemoteBlast.pm
#iterate through remote blast object setting the array rid = to each of the ids
while ( my @rids = $remote_blast->each_rid){
    foreach my $rid ( @rids ){
#itrate trhough this array for each element
#look for blast object for each id in swprott servers
        my $rc = $remote_blast->retrieve_blast($rid);
        if( !ref($rc) ){
          if( $rc < 0 ){
# move onto the next id
            $remote_blast->remove_rid($rid);
          }
          print STDERR "#" if ( $msg > 0 );
# sleep for 5sec before asking server for next id to prevent being blocked
          sleep 5;
        } else {
#store raw output in the file print out if hit was found continue to irate through array
          my $result = $rc->next_result();
          $filename = $result->query_name()."\.out";
          $remote_blast->save_output($filename);
          $remote_blast->remove_rid($rid);
          print "\nQuery Name: ", $result->query_name(), "\n";
          while ( my $hit = $result->next_hit ) {
            next unless ( $msg > 0);
            print "\thit name is ", $hit->name, "\n";
            while( my $hsp = $hit->next_hsp ) {
              print "\t\tscore is ", $hsp->score, "\n";
            }
          }
        }
      }
    print("plz wait");
    }
# code edited from CPAN end here

# make new Search IO object for creating the multiclustal files  useing the raw output #from before
my $searchio = new Bio::SearchIO(
    -format => 'blast', 
    -file => $filename);

#load the first sequnce in this set
my $searchobj = $searchio->next_result;

# names of file to be written
my $newfilehits = "hits.txt";
my $newfilemulti = "hits.fa";
my $newfileali = "hits.afa";

#open/ create files
open (HITFILE, ">$newfilehits");
open (MULTIFILE, ">$newfilemulti");
open (ALIFILE, ">$newfileali");

# put in subheadings for a file to store reults
print HITFILE "ID\tScore\tE-value\tIdendity";

#for the top ten results from the rawout put of the blast put the following information
#for the top ten hits. Also put threre sequences in a fasta format in a multifile
for (my $i=0; $i <=9; $i++){
    my $topten = $searchobj->next_hit;
    print HITFILE ("\n",$topten->accession());
    print HITFILE ("\t",$topten->bits);
    print HITFILE ("\t",$topten->significance());
    print HITFILE ("\t",$topten->frac_identical());

    my $gb = Bio::DB::GenPept->new();
    my $seq = $gb->get_Seq_by_acc($topten->accession());
    my $seqio = $gb->get_Stream_by_acc($topten->accession());
    while(my $seq = $seqio->next_seq){
        print MULTIFILE (">", $topten->accession(),"\n", $seq->seq, "\n");
        }
}
close(MULTIFILE);
close(HITFILE); 

#peform a muscle anlysis useing the multifile from before insure the MUSCLE program is 
# in the directory the command is run and the addtionle files his script creates
system './muscle3.8.31_i86linux64 -in hits.fa -out hits.afa';

#open in clustax the resultant muscle output
system 'clustalx hits.afa';












