#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
========================================================================================
	RUN KRAKEN
========================================================================================

Overview:
    - Runs kraken2 on paired-end fastq reads to identify taxonomy of samples.

Inputs:
	- tuple		:
		* sample	: Sample ID (string).
		* R1		: paired-end read 1 (path).
		* R2		: paired-end read 2 (path).

Outputs:
    - ${sample}.kraken.tab (emit: kraken)
		Kraken2 tab-delimited classification report.

========================================================================================
*/

process KRAKEN {
	
  publishDir "${params.outdir}/${sample}/", mode: 'copy', overwrite: 'true'

	cpus 4
	memory '24 GB'

	input:
	tuple val(sample), path(R1), path(R2)

	output:
	path "${sample}.kraken.tab", emit: kraken

	script:
	"""
	source ${params.minicondapath}/bin/activate ${params.minicondapath}/envs/kraken2

	kraken2 --db /mnt/data/PGRepo/kraken2_db/Standard-16 --threads 4 --quick --output - --report ${sample}.kraken.tab --memory-mapping --paired ${R1} ${R2}
	"""
}
