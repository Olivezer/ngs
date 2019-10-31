#! /bin/bash

# create dir


# fasta sequences whole mouse transcriptome
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.pc_transcripts.fa.gz
gunzip ...

# add spike ins ?
wget https://assets.thermofisher.com/TFS-Assets/LSG/manuals/ERCC92.zip
unzip ERCC92.zip
cat 

# get annotation using Gencode
wget ..
gunzip -c gencode.vM23.primary_assembly.annotation.gtf.gz > gencode.vM23.primary_assembly.annotation.gtf
awk '{if($3=="transcript"){print substr($12,2,length($12)-3),"\t",substr($10,2,length($10)-3)}}' gencode.vM23.primary_assembly.annotation.gtf > tx2gene.txt
awk '{print $1,"\t",$1}' ERCC92.gtf > ercc.txt
cat tx2gene.txt ercc.txt > tx2geneercc.txt

# salmon index 
/softwares/salmon-latest_linux_x86_64/bin/salmon index 

