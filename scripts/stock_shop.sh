#!/bin/bash

#for parallelization and http429 error
#r1=$(shuf -i 0-1 -n1)
#r2=$(shuf -i 1000-9999 -n1)
#echo "$r1.$r2"
#sleep $r1.$r2


#gene_name
gn=$1

#PATHS

#probe shop
ps="$HOME/probe_shop"
#probe shop probes
psp="$ps/probes"
#probe shop scripts
pss="$ps/scripts"

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
bio fetch $gn --format gff > $pr/$gn.annotation_report.gff3 

# obtains CDS sequence of probe target
bio fetch $gn | bio fasta --type CDS > $pr/$gn.cds_report.txt

# remove headers and whitespace from cds_report
cat $pr/$gn.cds_report.txt | tail -n +2 | tr -d " \t\n\r" > $prc/$gn.cleaned.txt

mkdir -p "$hpa/csv"

for i in "b1" "b2" "b3" "b4" "b5"
do
   python "$ps"/ipg/make_probe.py "sp" $gn $i $prc/$gn.cleaned.txt > $hpr/$i.$gn.probegen_report.txt
   begin=$(cat $hpr/$i.$gn.probegen_report.txt | grep -Fn "Pool name, Sequence" | cut -d ":" -f 1)
   end_num=$(cat $hpr/$i.$gn.probegen_report.txt | grep -Fn "Figure Layout of Probe Sequences" | cut -d ":" -f 1)
   end=$(expr "$end_num" - 3)
   cat $hpr/$i.$gn.probegen_report.txt | sed -n "$begin","$end"p | sed 's/ *, */,/' > $hpa/csv/$i.$gn.opools_order.csv
   python "$pss"/csv_to_xlsx.py $hpa/csv/$i.$gn.opools_order.csv "$gn" "$i" "$hpa/"
done

echo "***** Probes generated for $gn *****"


