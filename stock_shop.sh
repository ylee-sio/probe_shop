#!/bin/bash

#gene_name
gn=$1

#PATHS

#probe shop
ps="$HOME/probe_shop"

#probe shop probes
psp="$ps/probes"

#gene item
gi="$psp/$gn"

# creates directories for subsequent files related to this probe target
mkdir -p "$gi/primary_reports"
mkdir -p "$gi/processed_report_components"
mkdir -p "$gi/hcr_probegen_reports"
mkdir -p "$gi/hcr_probes_all_hairpins"

# shortened 
pr="$gi/primary_reports"
prc="$gi/processed_report_components"
hpr="$gi/hcr_probegen_reports"
hpa="$gi/hcr_probes_all_hairpins"

# obtains ncbi report
bio fetch $gn > $pr/$gn.ncbi_report.txt

# obtains annotation for this probe target
bio fetch $gn --format gff > $gi/lp.v2.$pr.annotation_report.gff3

# obtains CDS sequence of probe target
bio fetch $gn | bio fasta --type CDS > $pr/$gn.cds_report.txt

# remove headers and whitespace from cds_report
cat $pr/$gn.cds_report.txt | tail -n +2 | tr -d " \t\n\r" > $prc/$gn.cleaned.txt

#cp ~/yl_pictus-2/lp_transcriptome/csv_to_xlsx.py ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv_to_xlsx.py

for i in "b1" "b2" "b3" "b4" "b5"
do
   python "$ps"/ipg/make_probe.py "sp" $gn $i $prc/$gn.cleaned.txt > $hpr/$i.$gene_name.probegen_standard_report.txt
   begin=$(cat $hpr/$i.$gene_name.probegen_standard_report.txt | grep -Fn "Pool name, Sequence" | cut -d ":" -f 1)
   end_num=$(cat $hpr/$i.$gene_name.probegen_standard_report.txt | grep -Fn "Figure Layout of Probe Sequences" | cut -d ":" -f 1)
   end=$(expr "$end_num" - 3)
   cat $hpr/lp.v2.$gene_name.$i.probegen_standard_report.txt | sed -n "$begin","$end"p | sed 's/ *, */,/' > $hpa/lp.v2.$gene_name.$i.opools_order.csv
   python ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv_to_xlsx.py ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/lp.v2.$gene_name.$i.opools_order.csv "$gene_name" "$i"
#done

#mv ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/lp*order.csv ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv
#mv ~/yl_pictus-2/lp_transcriptome/lp.v2.$gene_name*opools_order.xlsx ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins
#rm ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv_to_xlsx.py
#echo "***** Probes generated for $gene_name *****"


