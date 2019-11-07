#! /bin/bash
echo "BONJOUR OLIVIER COMMENT ALLEZ VOUS AUJOURDHUI?"

# Again go create / go in the working directory
cd "/home/rstudio/disk/data/"

# Create a folder for the fastqc
directory="/home/rstudio/disk/data/fastqcheck"
mkdir -p $directory

cd "/home/rstudio/disk/data/sra_data"

# For each fastqc
SRA="SRR8795651 SRR8795649"
for filename in $SRA
do
echo $filename
fastqc $filename"_2.fastq" -o $directory

done

# Then collective analysis of all fastqc results
cd $directory
multiqc .


echo "ANALYSE TERMINEE"