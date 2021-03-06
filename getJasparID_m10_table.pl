use strict;
use FileHandle;
# I manualy added the missed TF, but found that either they are not deposited in German
# TF database, like Spi1,Tcfcp2l1,Spz1; or Hoxc9 have no homology record in the database.

my $input_file1 = 'jaspar_id_taxonomy.table';
my $input_file2 = 'mouse_human_geneID_name.final.table';
my $output_file = 'mouse_jaspar.table';

my $input_handle1 = FileHandle->new("$input_file1");
my $input_handle2 = FileHandle->new("$input_file2");
my $output_handle = FileHandle->new(">$output_file");


my $jaspar_hash_ref = undef;
while(my $line = $input_handle1->getline) {
	  chomp($line);
	  my @array = split(/\t/,$line);
	  $jaspar_hash_ref->{$array[0]} = [$array[1],$array[2]];  
}

$input_handle1->close;

my $mouse_human_hash_ref = undef;
while(my $line = $input_handle2->getline) {
	  chomp($line);
	  my @array = split(/\t/,$line);
	  $mouse_human_hash_ref->{$array[0]} = $array[3];
}
$input_handle2->close;

foreach my $jaspar_id(keys %{$jaspar_hash_ref}) {
	 if($jaspar_hash_ref->{$jaspar_id}->[1] =~ /Mus/) {
	 	   my $state = 0;
	     foreach my $tf_name(keys %{$mouse_human_hash_ref}){
	 	       if(lc($jaspar_hash_ref->{$jaspar_id}->[0]) eq lc($tf_name)) {
	 	           $state = 1;
	 	           $output_handle->print("$jaspar_id\t$tf_name\t$mouse_human_hash_ref->{$tf_name}\n");
	 	           
	 	       } 
	     }
	     if($state == 0) {
	     	    print "we do not have corrsonding record\t",$jaspar_id,"\t$jaspar_hash_ref->{$jaspar_id}->[0]\n";
	     }
	 }

}

$output_handle->close;