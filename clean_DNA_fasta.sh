#!/bin/bash

clear
DIR=`pwd`
echo "Program written by Abhijeet Singh (abhijeetsingh.aau@gmail.com)
"
if [ "$#" -gt 0 ]; then
	filename=$1
    file=$1
    
else
echo "Enter your multifasta file name"
read -p 'Filename: ' file

fi
    if [ -z "$file" ]
        then
            exit
    fi
    if [ ! -f $file ]; then
    echo "
ERROR: File \"$file\" not found in \"$DIR\"  
"
    exit 0
    fi
echo "
Processing: $file
"
mkdir -p ${DIR}/analysis && cd $_
cp ../${file} .
sed -e 's/ /_/g;s/-/_/g;s/,/_/g' ${file} > ${file}_2 
awk '/^>/ {if(N>0) printf("\n"); printf("%s\n",$0);++N;next;} { printf("%s",$0);} END {printf("\n");}' ${file}_2 > ${file}_3
awk 'BEGIN{RS=">"}NR>1{gsub("\n","\t");gsub("\n","");print RS$0}' ${file}_3 > ${file}_tab
awk '{ print $1 }' ${file}_tab > ${file}_tab_col1
awk '{ print $2 }' ${file}_tab > ${file}_tab_col2
sed -e 's/[^ATGC]//Ig;s/\(.*\)/\U\1/g' ${file}_tab_col2 > ${file}_tab_col2_2
paste ${file}_tab_col1 ${file}_tab_col2_2 > ${file}_tab_pros
sed -e 's/\t/\n/g' ${file}_tab_pros > ${file}_tab_pros_2
awk 'BEGIN {RS=">";FS="\n";ORS=""} $2 {print ">"$0}' ${file}_tab_pros_2 > ${file}_tab_pros_3
cp ${file}_tab_pros_3 ${DIR}/${file}_processed.fa
cd ${DIR}
rm -rf ${DIR}/analysis
echo "                 --------------------------------"
echo "Result file --->> ${file}_processed.fa           "
echo "                 --------------------------------"
