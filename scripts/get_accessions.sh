#!/bin/bash

# Get the assembly report if you dont already have one. This contains summaries of all genomes on NCBI. This is used to find relevant information desired species.
#wget https://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt -O ~/probe_shop/resources/assembly_summary_refseq.txt 

#genus=$1
#species=$2

# refseq summary
#ftp_link=$(cat ~/probe_shop/resources/assembly_summary_refseq.txt | grep "$genus $species" | cut -f 20)
#wget -r -A '$ftp_link/*gff.gz' "$ftp_link" 


#annotation file can be gtf or gff
anno=~/probe_shop/resources/*gtf
species_initial=$1
gffread --table @id $anno | grep XM > ~/probe_shop/resources/"$species_initial".transcript.accessions.txt 
