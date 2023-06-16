#!/bin/bash

# Get the assembly report if you dont already have one. This contains summaries of all genomes on NCBI. This is used to find relevant information desired species.
#wget https://ftp.ncbi.nlm.nih.gov/genomes/ASSEMBLY_REPORTS/assembly_summary_refseq.txt -O ~/probe_shop/resources/assembly_summary_refseq.txt 

#for example, the taxon id number for Lytechinus pictus is 7653
taxon_id_number=$1
species_initial=$2

# get gtf file of interest. for some reason, cant get ncbi datasets to specify output path
cd ~/probe_shop/resources
datasets download genome taxon $taxon_id_number --include gff3
unzip ncbi_dataset.zip
gtf_location=$(find ncbi_dataset -name *.gff)
mv $gtf_location ~/probe_shop/resources
rm -rf ncbi_dataset*

agat_convert_sp_gff2gtf.pl --gff genomic.gff -o genomic.gtf
gffread --table @id genomic.gtf | grep XM > ~/probe_shop/resources/"$species_initial".transcript.accessions.txt 
