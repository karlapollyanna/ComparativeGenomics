#!/bin/bash

###################################################################################################

### Script: Artemis/Act analysis 
### Version: 0
### Date: 05/06/2016
### Sponsor: Karla Pollyanna Vieira de Oliveira
### Cellphone: +55 (48) 9133-9078 || +55 (31) 987-677-667
### Email: karla@intelab.ufsc.br || karla.biotecnologia@gmail.com
### Lattes: http://lattes.cnpq.br/7673656510731331

###################################################################################################



######### Help Option

while getopts ":h:" h
do 
	echo "\n\n Script to Artemis/Act analysis "
	echo " It must be run in a GUI environment \n"
	echo " Usage: ./ArtemisScript.sh <Complete path of genome> <Complete path of blast output directory> <Complete path of Artemis/Act> "
	echo " Genome file must be in .fna format \n\n"
done


######### Arguments

path_genomes=$1      # Fasta files in .fna format
BlastDir=$2	     # Where to save Blast Outputs
artemis=$3	     # Where is act script

######### Checking users parameters 

if [ ! -d "$path_genomes" ]
then
        exit
fi


if [ ! -e $BlastDir ] # Check the existence of Blast Output directory
then

    mkdir $BlastDir   # Creates the directory if does not exist

fi


######### Blast Script

cd $path_genomes

list=`ls *.fna`
for i in $list
do
        makeblastdb -in $i -dbtype nucl -out temp	# Creates Blast db for each file and armazenates on temporary variable
        for j in $list
        do
                blastn -query $j -db temp -out ${j}_vs_${i}.out -outfmt 6 -num_threads 4  # Run blastn
                mv *.out $BlastDir
done 
done


######### Artemis

cd $artemis
comparison=$BlastDir

./act $path_genomes/K.europaeus.fna $comparison/K.hansenii.fna_vs_K.europaeus.fna.out $path_genomes/K.hansenii.fna $comparison/K.intermedius.fna_vs_K.hansenii.fna.out $path_genomes/K.intermedius.fna $comparison/K.kakiaceti.fna_vs_K.intermedius.fna.out $path_genomes/K.kakiaceti.fna $comparison/K.oboediens.fna_vs_K.kakiaceti.fna.out $path_genomes/K.oboediens.fna $comparison/K.rhaeticus.fna_vs_K.oboediens.fna.out $path_genomes/K.rhaeticus.fna $comparison/K.xylinus.fna_vs_K.rhaeticus.fna.out $path_genomes/K.xylinus.fna $comparison/K.medellinensis.fna_vs_K.xylinus.fna.out $path_genomes/K.medellinensis.fna		# Runs ./act script by Artemis that compares genomes previously runned on blast and opens a display of this comparison
