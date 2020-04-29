#!/bin/bash

# specify a sequencing run directory
RUN=$1

# get known directory names
DIR="/home/idies/workspace/covid19/sequencing_runs/$RUN/artic-pipeline/4-draft-consensus"

# make and save output directory
outdir="/home/idies/workspace/covid19/sequencing_runs/$RUN/artic-pipeline/6-post-filter/"

# save path to NTC bamfile
ntc_bamfile="/home/idies/workspace/covid19/sequencing_runs/$RUN/artic-pipeline/4-draft-consensus/NTC*primertrimmed.rg.sorted.bam"

# save path to nextstrain vcf
vcf_next="/home/idies/workspace/covid19/sequencing_runs/$RUN/artic-pipeline/5-nextstrain/*alignments.vcf"

for consfile in $DIR/*.consensus.fasta; do

	sample=${consfile##*/}
	samplename=${sample%%_*}

	# loop through all NTC samples
	if [ ! "$samplename" = "NTC" ]; then

		echo $samplename

		vcffile=$DIR/$samplename*allcallers.combined.vcf
		bamfile="$DIR/$samplename*nanopolish.primertrimmed.rg.sorted.bam"
		consensus="$DIR/$samplename*nanopolish.consensus.fasta"
		prefix=`echo $consensus`
		prefix=${prefix##*/}
		prefix=${prefix%%.*}

		# run script
		python /home/idies/workspace/Storage/swohl/persistent/covid/vcf_postfilter.py --vcffile $vcffile --bamfile $bamfile --consensus $consensus --ntc-bamfile $ntc_bamfile --vcf-nextstrain $vcf_next --ns-snp-threshold 2 -o $outdir --prefix $prefix --maf-flag 15
	fi
done
