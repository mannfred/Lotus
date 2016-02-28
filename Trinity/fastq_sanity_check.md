If attempting to run Trinity spaces in the .fastq header may cause trouble. Replace spaces with / in the header:
```
awk '{ if (NR%4==1) { print $1"_"$2"/1" } else { print } }' All_GN_R1.fastq > nospaces_All_GN_R1.fastq
awk '{ if (NR%4==1) { print $1"_"$2"/2" } else { print } }' All_GN_R2.fastq > nospaces_All_GN_R2.fastq
```

This perl script was written by [Simon Andrews](https://github.com/s-andrews) to sanity check fastq files and filter corrupted regions.

allow script to be executable:
``` 
chmod 755 fastqfilter.pl
```
run script:
```
./fastqfilter.pl All_GN_R1.fastq > filter_All_GN_R1.fastq

```
copy the following script to a text file and save as .pl
```
#!/usr/bin/perl
use warnings;
use strict;

while (<>) {

  unless (/^\@/) {
    warn "$_ should have had an \@ at the start and it didn't\n";
    next;
  }
  my $id1 = $_;
  my $seq = <>;
  my $id2 = <>;
  my $qual = <>;

  if ($seq =~/^[@+]/) {
    warn "Sequence '$seq' looked like an id";
    next;
  }
  if ($qual =~/^[@+]/) {
    warn "Quality '$qual' looked like an id";
    next;
  }
  if ($id2 !~ /^\+/) {
    warn "Midline '$id2' didn't start with a +";
    next;
  }

  if ($qual =~ /[GATCN]{20,}/) {
    warn "Quality '$qual' looked like sequence";
    next;
  }

  if (length($seq) != length($qual)) {
    warn "Seq $seq and Qual $qual weren't the same length";
    next;
  }

  print $id1,$seq,$id2,$qual;


}
```
