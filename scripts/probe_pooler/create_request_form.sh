#!/bin/bash

ps="$HOME/probe_shop"
psp="$ps/probes"
pss="$ps/scripts"
pooler="$pss/probe_pooler"

echo " "
printf 'accession,hairpin,pool,common_gene_name,ref_species' > $pooler/ready_pool_request_form.csv

proceed_probe='y'
probe_num=1
while [ $proceed_probe == 'n' ]

echo "********** PROBE $probe_num **********" 
  do
    test_probe="fail"
    while [ $test_probe != "pass" ]
    do
      read -p 'Enter accession: ' accession
      if [ -d "$psp/$accession" ]; then
        test_probe="pass"
        let "probe_num+=1"
      else
        test_probe="fail"
	echo " "
        echo "A probe for $accession does not exist."
        echo "Alternatives may include accessions numbers for transcript isoforms."
        echo "If not, then add another gene instead."
        echo "You are currently on probe $probe_num."
        echo " "
      fi
    done

    read -p 'Enter hairpin: ' hairpin
    if [[ "$hairpin" != b[0-9] ]]; then
      while [ "$hairpin" != b[0-9] ]
      do
	echo " "
        echo "$hairpin is not a valid entry for hairpin."
	echo "Enter b1, b2, b3, b4, or b5."
        echo " "
        read -p 'Enter hairpin: ' hairpin
	if [[ "$hairpin" =~ ^b+[0-9] ]]; then break; else echo "$hairpin" ; fi
      done
    fi

    read -p 'Enter pool: ' pool
    read -p 'Enter common gene name (no symbols): ' cgn
    read -p 'Enter reference organism: ' refspecies
    sed -i -e '$a\'$accession,$hairpin,$pool,$cgn,$refspecies ready_pool_request_form.csv
    echo " "
    echo "Your probe request form currently looks like this: "
    echo " "
    cat ready_pool_request_form.csv
    echo " "
    read -p 'Add another probe? (Enter y/n): ' proceed_probe
    echo " "
    if [ $proceed_probe == 'n' ]; then 
      break 
    fi
done

echo "A new ready_pool_request_form.csv has been created."
