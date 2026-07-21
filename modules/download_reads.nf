#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
========================================================================================
    Download publicly available read data from NCBI GenBank
    
    Inputs: samplesheet.tsv
    Output: downloaded FASTQ file of biosample
========================================================================================
*/

process DOWNLOAD_READS {
    publishDir "${params.outdir}/raw_reads", mode: 'copy'

    input:
    tuple val(sample), val(url_1), val(url_2)

    output:
    tuple val(sample), path("*_R1.fq.gz"), path("*_R2.fq.gz"), emit: reads

    script:
    """
    wget -q "${url_1}" -O ${sample}_R1.fq.gz
    wget -q "${url_2}" -O ${sample}_R1.fq.gz
    """
}
