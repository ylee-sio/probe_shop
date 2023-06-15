#!/bin/bash

#gene_name
gn=$1

#PATHS

#probe shop
ps="~/probe_shop/probes"

#gene item
gi="~/probe_shop/probes/$gn"

mkdir -p "$gi"
bio fetch $gn > $gi/$gn.ncbi_report.txt


#sleep 0.5s
#bio fetch $gene_name | bio fasta --type CDS > ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.txt
#sleep 0.5s
#bio fetch $gene_name --format gff > ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.annotations.gff3
#sleep 0.5s

#removing header and whitespace from CDS. gene annotation file is stored separately as gff3
#cat ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.txt | tail -n +2 | tr -d " \t\n\r" > ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.cleaned.txt
#mkdir -p ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv
#mkdir -p ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv
#mkdir -p ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probegen_standard_report


#cp ~/yl_pictus-2/lp_transcriptome/csv_to_xlsx.py ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv_to_xlsx.py

#for i in "b1" "b2" "b3" "b4" "b5"
#do
  # python ~/yl_pictus-2/lp_transcriptome/insitu_probe_generator/make_probe.py "sp" $gene_name $i ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.cleaned.txt > ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probegen_standard_report/lp.v2.$gene_name.$i.probegen_standard_report.txt
  # begin=$(cat ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probegen_standard_report/lp.v2.$gene_name.$i.probegen_standard_report.txt | grep -Fn "Pool name, Sequence" | cut -d ":" -f 1)
  # end_num=$(cat ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probegen_standard_report/lp.v2.$gene_name.$i.probegen_standard_report.txt | grep -Fn "Figure Layout of Probe Sequences" | cut -d ":" -f 1)
  # end=$(expr "$end_num" - 3)
  # cat ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probegen_standard_report/lp.v2.$gene_name.$i.probegen_standard_report.txt | sed -n "$begin","$end"p | sed 's/ *, */,/' > ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/lp.v2.$gene_name.$i.opools_order.csv
  # python ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv_to_xlsx.py ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/lp.v2.$gene_name.$i.opools_order.csv "$gene_name" "$i"
#done

#mv ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/lp*order.csv ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv
#mv ~/yl_pictus-2/lp_transcriptome/lp.v2.$gene_name*opools_order.xlsx ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins
#rm ~/yl_pictus-2/lp_transcriptome/sp_transcripts_of_interest_test/lp.v2.$gene_name/lp.v2.$gene_name.hcr_probes_all_hairpins/csv_to_xlsx.py
#echo "***** Probes generated for $gene_name *****"


