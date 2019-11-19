#! /bin/bash
#CE SCRIPT A POUR BUT DE:
#> TELECHARGER LE GENOME DE LA SOURIS SUR LESQUELLES ON VA MAPPER NOS DONNEES DE SEQ
#> RECUPERER LES DONNEES DANNOTATIONS TRANSCRIPTOMIQUES DU GENOME
#> AVEC AWK ON CREE ENSUITE DEUX TYPES DE FICHIER: transcript_ref.txt -> permet d'associer le nom de référence d'un transcrit avec la séquence
#                                                   transcript_names.txt -> associe le nom de référence d'un transcrit avec la gène correspondant

#CONSTRUCTION DE L'INDEX AVEC SALMON (kmer = 31)
#MAPPING DE NOS DONNES DE SEQUENCAGE A PARTIR DE L'INDEX QUE LON A CONSTRUIT ET NOS DONNEES DE SEQUENCAGES AVEC ALEVIN.

# Création du dossier de travail pour ce script et aller dans ce dossier
mkdir -p "/home/rstudio/disk/data/genome"
cd "/home/rstudio/disk/data/genome"

# Téléchargement du génome de la souris depuis gencode, version M23, et dézippage
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.pc_transcripts.fa.gz

gunzip gencode.vM23.pc_transcripts.fa.gz



# Récupération des données d'annotations transcriptomiques 
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.primary_assembly.annotation.gtf.gz

gunzip -c gencode.vM23.primary_assembly.annotation.gtf.gz > gencode.vM23.primary_assembly.annotation.gtf

#AWK time :'(

#Création d'un fichier associant référence d'un transcrit au nom de gène correspondant
# "Séparateur est |", "Si la colonne 1 commence par >","Print nom de la ref, tabulation, nom du gène", "fichier source", "ficher target"
awk 'BEGIN{FS="|"}{if($1~">"){print substr($1,2,length($1)),"\t",$6}}' gencode.vM23.pc_transcripts.fa > transcripts_names.txt

#Création d'un fichier associant référence d'un transcrit à sa séquence
# "Séparateur est |", "print la colonne 1","fichier source", "fichier target"
awk 'BEGIN{FS="|"}{print $1}' gencode.vM23.pc_transcripts.fa > transcripts_ref.txt


#Construction de l'index
salmon index -t transcripts_ref.txt -i transcripts_index -k 31

#Mapping avec alevin
SRA="SRR8795651 SRR8795649"


for file in $SRA
do

CBUMI="/home/rstudio/disk/data/sra_data/"$file"_1.fastq"
READS="/home/rstudio/disk/data/sra_data/"$file"_2.fastq"
INDEX="/home/rstudio/disk/data/genome/transcripts_index"
MAP="/home/rstudio/disk/data/genome/transcripts_names.txt"
OUTPUT="/home/rstudio/disk/data/genome/alevin_output/"$file

salmon alevin -l ISR -1 $CBUMI -2 $READS --chromium  -i $INDEX -p 10 -o ./alevin_output_$file --tgMap $MAP

done

