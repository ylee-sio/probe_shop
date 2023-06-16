#!/bin/bash

ps="$HOME/probe_shop"
psp="$ps/probes"
#pspmpc="$psp/missing_probes_check"

# make list of failed probes due to http 429 error

accession=$1
num_hairpin_file_check=$(ls $psp/$accession/*all* | wc -l)

if [ $num_hairpin_file_check -lt 6 ]
then
  echo $accession >> missing_probes.txt
fi
