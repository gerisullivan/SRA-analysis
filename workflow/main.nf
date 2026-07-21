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

workflow {

# download reads based on the samplesheet.tsv set in nextflow.config
    ch_samples = channel.fromPath(params.samplesheet).splitCsv(sep: '\t')
        .map { r1, r2 ->
            def run_accession = file(r1).baseName.replace('_1.fastq', '')
            tuple(run_accession, r1, r2)
        }

    DOWNLOAD_READS(ch_samples)
}
