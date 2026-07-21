#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
========================================================================================
    Analysis workflow
========================================================================================
*/

// ─── Parameters ──────────────────────────────────────────────────────────────


// ─── Modules ─────────────────────────────────────────────────────────────────

include { DOWNLOAD_READS } from '../modules/download_reads.nf'
include { FASTP }          from '../modules/fastp.nf'
include { KRAKEN }         from '../modules/kraken.nf'
include { SKESA }         from '../modules/skesa.nf'
include { MLST }          from '../modules/mlst.nf'

workflow {

// download reads based on the samplesheet.tsv set in nextflow.config
    ch_samples = channel.fromPath(params.samplesheet).splitCsv(sep: '\t')
        .map { r1, r2 ->
            def run_accession = file(r1).baseName.replace('_1.fastq', '')
            tuple(run_accession, r1, r2)
        }

// pass the sample sheet to download reads
    DOWNLOAD_READS(ch_samples)

// pass the reads to fastp - faster and more comprehensive than trimmomatic + fastQC
    FASTP(DOWNLOAD_READS.out.reads)

// assign taxonomy to reads
    KRAKEN(DOWNLOAD_READS.out.reads)

// assemble genome with SKESA
    SKESA(DOWNLOAD_READS.out.reads)

// further type the samples by running MLST on the contigs
    MLST(SKESA.out.contigs)

}
