#!/bin/bash
# Use this script to check whether or not accessions in a probe request form are available to order.

# User input for probe request form
form=$1
# accessions
acc=$(cat $1 | cut -d "," -f 1 | sed 1d)

# hairpin for each probe/accession
hp=$(cat $1 | sed 1d | cut -d "," -f 2 | sed 1d)

# temp_pool unique id
pool=$(cat $1 | sed 1d | cut -d "," -f 3 | sed 1d)

for i in $acc
do
if [ -d "$HOME/probe_pooler/.probes/$i" ]
   then
   echo "$i exists"
else
   echo "$i does not exist"
fi
done
