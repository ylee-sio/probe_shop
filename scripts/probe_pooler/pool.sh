#!/bin/bash
form=$1

ps="$HOME/probe_shop"
psp="$ps/probes"
pss="$ps/scripts"
pp="$pss/probe_pooler"
ppt="$pp/.tmp"
ppal="$pp/.all_probe_pools"

session_record_num=$(shuf -i 100000000-999999999 -n 1)
receipt_record_num=$(shuf -i 100000000-999999999 -n 1)
timestamp=$(date +%c)
read -p 'Username: ' username
read -p 'Supervisor/PI: ' super
echo " "
first_run_pass=$(ls $ppal | wc -l)
if [ $first_run_pass -gt 1 ]
then

ls $ppal/*/.tmp/*temp_XM* | sort | uniq > $pp/.current_total_probe_paths_list.txt
ls $ppal/*/.tmp/*temp_XM* | cut -d "/" -f 6 | sort | uniq > $pp/.current_total_probe_pools_list.txt
#rm ~/*duplicates*

else
   echo "First run."
fi
# db should be where ever all probe directories are located
db="~/probe_pooler/.probes"

cat $form | cut -d "," -f 3 | sed 1d > $ppt/temp_pool.txt
pool_length=$(cat $ppt/temp_pool.txt | sort | uniq | wc -l)

for (( p=1; p<=$pool_length; p++ ))
   
   do
   last_probe_num=$(ls $pp/.all_probe_pools | wc -w) 
   new_probe_num=$(expr $last_probe_num + 1)
   pool_id=HL_HCR_PSET_"$new_probe_num"
   
   mkdir $ppt/"subpool_000$p"
   pptsp="$ppt/subpool_000$p"

   subsession_record_num=$(shuf -i 100000000-999999999 -n 1)
   csvgrep -c pool -m "$p" $form > $ppt/"subpool_000$p"/"$subsession_record_num"_pool_map.csv
   cat $pptsp/"$subsession_record_num"_pool_map.csv | cut -d "," -f 1 | sed 1d > $pptsp/temp_acc.txt
   cat $pptsp/"$subsession_record_num"_pool_map.csv | cut -d "," -f 2 | sed 1d > $pptsp/temp_hp.txt
   cat $pptsp/"$subsession_record_num"_pool_map.csv | cut -d "," -f 3 | sed 1d > $pptsp/temp_pool.txt
   cat $pptsp/"$subsession_record_num"_pool_map.csv | cut -d "," -f 4 | sed 1d > $pptsp/temp_genenames.txt
   
   temp_acc_length=$(cat $pptsp/temp_acc.txt | wc -l)
   paste -d "_" $pptsp/temp_acc.txt $pptsp/temp_hp.txt > $pptsp/temp_combos.txt

   for (( c=1; c<=$temp_acc_length; c++ ))
      do
	     temp_acc_search_term=$(sed $c'q;d' $pptsp/temp_acc.txt)
        temp_genename=$(sed $c'q;d' $pptsp/temp_genenames.txt)
	     temp_combo_search_term=$(sed $c'q;d' $pptsp/temp_combos.txt)

        if [ $first_run_pass -gt 1 ]
            then
            if grep -q "$temp_acc_search_term" .current_total_probe_paths_list.txt
            then
            grep "$temp_acc_search_term" .current_total_probe_paths_list.txt | cut -d "/" -f 6 > "$session_record_num"_duplicates.txt
            echo "It looks like we've ordered $temp_acc_search_term in the past."
            echo "The user inputted gene name for $temp_acc_search_term is $temp_genename."
            printf "$temp_acc_search_term is currently present in the following pools: "
            cat "$session_record_num"_duplicates.txt
            read -p "Continue with pooling? (Enter y/n): " duplicate_check_answer
            
               if [ "$duplicate_check_answer" = 'y' ]
               then
               echo "Preapred $temp_combo_search_term for pooling."
               echo ""
               echo "*********************************************"
                  elif [ "$duplicate_check_answer" = 'n' ]
                  then
                  echo "Stopped."
                  echo "Your session ID is $session_record_num."
                  cp ~/probe_pooler/"$session_record_num"_duplicates.txt ~/"$session_record_num"_duplicates.txt 
                  echo "$session_record_num"_duplicates.txt has been placed in your home folder.
                  echo "Please use the info in the file to remove duplicates from your current probe request. Update your probe request sheet and try again."
                  rm -rf ~/probe_pooler/.tmp/*
                  rm -rf ~/probe_pooler/.all_probe_pools/"$session_record_num"*
                  ls ~/probe_pooler/.all_probe_pools/*/.tmp/*temp_XM* | sort | uniq > .current_total_probe_paths_list.txt
                  ls ~/probe_pooler/.all_probe_pools/*/.tmp/*temp_XM* | cut -d "/" -f 6 | sort | uniq > .current_total_probe_pools_list.txt
                  exit 0
               fi       
            fi
         else
            echo "Processed $temp_combo_search_term."
         fi
   cp $psp/$temp_acc_search_term/*/*all*/csv/*"$temp_combo_search_term"* $pptsp/temp_$temp_combo_search_term.csv
	sed 1d $pptsp/*temp_$temp_combo_search_term*.csv > $pptsp/$temp_combo_search_term.temp_cleaned.csv
   done
   
   mkdir $pptsp/.tmp
   cat $pptsp/*.temp_cleaned.csv > $pptsp/temp_subpool_1.csv
   awk -v pool_name="$pool_id" '$1=pool_name' FS=, OFS=, $pptsp/temp_subpool_1.csv > $pptsp/"$subsession_record_num"_final_subpool.csv
   sed -i '1s/^/Pool name,Sequence\n/' $pptsp/"$subsession_record_num"_final_subpool.csv
   mv $pptsp/*temp* $pptsp/.tmp
   # creating summary report of each pool
   
   num_line_final_pool=$(cat $pptsp/"$subsession_record_num"_final_subpool.csv | wc -l)
   price=$(echo "((($num_line_final_pool * 45)-3300)*0.02)+66" | bc -l)
   printf "session_record_num: $session_record_num" > $pptsp/session_record.txt
   sed -i -e '$a\subsession_record_num: '$subsession_record_num $pptsp/session_record.txt
   sed -i -e '$a\estimated_price: '$price $pptsp/session_record.txt
   sed -i -e '$a\timestamp: '"$timestamp" $pptsp/session_record.txt
   sed -i -e '$a\user: '$username $pptsp/session_record.txt
   #sed -i -e '$a\This message has been auto generated with probe_pooler_v1 on pictus-2l' ~/probe_pooler/.tmp/subpool_000$p/session_record.txt
   #sed -i -e '$a\' ~/probe_pooler/.tmp/subpool_000$p/session_record.txt
   
   echo "$price" > $pptsp/temp_pool_price.txt 
   mv $pptsp $ppal/"$session_record_num"_"$pool_id"
   cp $form $ppal/"$session_record_num"_"$pool_id"/"$session_record_num"_pool_content_mapping.csv

done

cat $ppal/$session_record_num*/temp_pool_price.txt > total_session_price.txt
rm $ppal/$session_record_num*/temp_pool_price.txt
total_session_price=$(paste -sd+ total_session_price.txt | bc)

read -p "Notes of these/this pool: " message
echo "$message" > message.txt
sed -i -e '$a\ ' message.txt
sed -i '1s/^/Notes:\n/' message.txt
sed -i -e '$a\ ' message.txt
sed -i -e '$a\Receipt ID: '$receipt_record_num message.txt
sed -i -e '$a\Session record: '$session_record_num message.txt
sed -i -e '$a\Timestamp: '"$timestamp" message.txt
sed -i -e '$a\Requestor: '$username message.txt
sed -i -e '$a\Supervisor/PI: '$super message.txt
sed -i -e '$a\*****************************************************************************************************' message.txt
sed -i -e '$a\Estimated price: '$total_session_price message.txt
num_pools=$(ls ~/probe_pooler/.all_probe_pools | grep "$session_record_num" | wc -l)
sed -i -e '$a\Number of pools generated: '$num_pools message.txt
num_genes=$(ls $ppal/$session_record_num*/"$session_record_num"_pool_content_mapping.csv | parallel "sed 1d {}" | sort | uniq | wc -l)
sed -i -e '$a\Total number of probes pooled in session: '$num_genes message.txt
sed -i -e '$a\ ' message.txt
sed -i -e '$a\You can check the attached probe_inventory_update.txt to see which probes we currently have in stock.' message.txt
sed -i -e '$a\probe_inventory_update.txt includes the probes submitted in this run.' message.txt
sed -i -e '$a\' message.txt
sed -i -e '$a\*****************************************************************************************************' message.txt
sed -i -e '$a\ ' message.txt
sed -i -e '$a\Correctly formatted oPools files are attached in the zipped folder. Probe mappings to each order are included as well.' message.txt
sed -i -e '$a\Unique numbers and IDs generated at this point in the pipeline will be linked to all metadata related the experiments using these oligos. ' message.txt
sed -i -e '$a\DO NOT attempt to rename or reorganize files in this directory.' message.txt
sed -i -e '$a\This message has been auto generated with probe_pooler_v1 on pictus-2l.' message.txt

unique_probes_update=$(ls $ppal/*/*content* | parallel "sed 1d {}" | sort | uniq)
printf "$unique_probes_update" > probe_inventory_update.txt
sed -i '1s/^/accession,hairpin,pool,common_gene_name,ref_species\n/' probe_inventory_update.txt
sed -i '1s/^/\n/' probe_inventory_update.txt
sed -i '1s/^/These are the current probes we have in stock (including the pools generated with this run):\n/' probe_inventory_update.txt
sed -i -e '$a\ ' probe_inventory_update.txt

#read -p "(MANDATORY) Enter your email address: " user_email_address
#read -p "(MANDATORY) Enter your PI's email address: " pi_email_address

mkdir $session_record_num
cp -r $ppal/$session_record_num* $session_record_num
cp probe_inventory_update.txt $ppal/"$session_record_num"_"$pool_id"/probe_inventory_update.txt

echo "******************** SUMMARY ********************"
for i in $session_record_num/*
do
echo ""
show_pool=$(echo $i)
basename $show_pool 
cat $i/session_record.txt
echo ""
cat $i/*pool_map*

csv_path=$(ls $i/*final*)
csv_name=$(basename $csv_path)
xlsx_name=$(echo "$csv_name" | cut -d "." -f 1)

python $pss/csv_to_xlsx.py ~/$show_pool/$csv_name ~/$show_pool/$xlsx_name 

echo "*************************************************"
done
echo ""
echo "YOUR POOL RECEIPT NUMBER: $receipt_record_num"
#echo "Your formatted IDT oPools probe pool files will be sent to $user_email_address and $pi_email_address."
#echo "It may take up to 15 minutes for arrival."

#add additional data to final data package
cp probe_inventory_update.txt $session_record_num/probe_inventory_update.txt
cat $form | sed 1d | cut -d "," -f 1 | parallel -j 2 "cp -r ~/probe_pooler/.probes/{} $session_record_num" 

mv message.txt $session_record_num
mv total_session_price.txt $session_record_num
pigz -9 -p4  $session_record_num
cp $session_record_num.gz $ps/resources/probe_pool_records
mv $session_record_num.gz ~/OneDrive/probe_pool_archives

echo "A copy of $session_record_num has been placed in HOME > probe_shop > resources > probe_pool_records."
echo "If you are generating probe pools locally, simply copy $session_record_num onto a flash drive and order probes using those files."

onedrive --no-remote-delete --upload-only --single-directory probe_pool_archives

#cat message.txt | mail -s "probe pooling receipt: $receipt_record_num" -A "$session_record_num.zip" -A probe_inventory_update.txt labhamdoun@gmail.com
#cat message.txt | mail -s "probe pooling receipt: $receipt_record_num" -A "$session_record_num.zip" -A probe_inventory_update.txt "$user_email_address"
#cat message.txt | mail -s "probe pooling receipt: $receipt_record_num" -A "$session_record_num.zip" -A probe_inventory_update.txt "$pi_email_address"

rm -rf $session_record_num*
rm -rf probe_inventory_update.txt
mv $form ~/probe_pooler/.past_request_forms/$session_record_num.$form

exit
