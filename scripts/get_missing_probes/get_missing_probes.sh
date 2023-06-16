#!/bin/bash

ps="$HOME/probe_shop"
psp="$ps/probes"
pspmpc="$psp/missing_probes_check"

# get list of failed probes due to http 429 error
mkdir "$pspmpc"

ls $psp > $pspmpc/all_present_accessions.txt
touch $pspmpc/missing_probes.txt

cat all_present_accessions.txt | parallel -j 12 "bash .get_missing_probes.sh {}"

missing=$(cat $pspmpc/missing_probes.txt) 

for n in $missing
do
  bash $ps/scripts/probe_pooler/pool.sh $n
done
