#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
========================================================================================
    RUN SKESA

    Genome assembly tool to produce downstream consensus genomes for typing

    Requirements:
    - 4 GB memory
    - 4 CPUs for faster completion

    Inputs:
	  - tuple		:
		  * sample	: Sample ID (string).
		  * R1		: paired-end read 1 (path).
		  * R2		: paired-end read 2 (path).

    Output:
    - ${sample}.contigs.fa: assembled genome
========================================================================================
*/

process SKESA {

	publishDir "${params.outdir}/${sample}/", mode: 'copy', overwrite: true

  memory '4 GB'
  cpus 4

	input:
	tuple val(sample), path(R1), path(R2)

	output:
	tuple val(sample), path("${sample}.contigs.fa"), emit: contigs

	script:
	"""
  source ${params.minicondapath}/bin/activate ${params.minicondapath}/envs/skesa

	skesa --fastq ${R1},${R2} --cores 4 --vector_percent 1.0 --contigs_out ${sample}.contigs.fa
	"""
}
