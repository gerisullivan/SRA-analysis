#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
===========================================================================================
    RUN [MLST](https://github.com/tseemann/mlst)
    Multi-locus sequence typing

    Additional typing beyond taxonomic classification based on assembled genome from SKESA

    Input:
    - tuple
    * sample:   Sample ID
    * contigs:  Assembled contigs

    Output:
    - tuple
    * sample:             Sample ID
    * mlst.${sample}.tab: path to MLST results
===========================================================================================
*/

process MLST {

	input:
	val run_id
	val project
	tuple val(sample), path(contigs)

	output:
	tuple val(sample), path("mlst.${sample}.tab"), emit: tab

	publishDir "/mnt/data/Projects/${project}/runs/${run_id}/${sample}", mode: 'copy', overwrite: true

	script:
	"""
	source /mnt/data/miniconda3/bin/activate /mnt/data/miniconda3/envs/mlst-2.32.2

	mlst ${contigs} --exclude salmonella,ecoli,abaumannii,ypseudotuberculosis_achtman_3,cronobacter,senterica_achtman_2,aerogenes > mlst.${sample}.tab
	"""
}
