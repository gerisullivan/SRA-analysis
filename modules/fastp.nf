#!/usr/bin/env nextflow

nextflow.enable.dsl=2

/*
========================================================================================
    FASTP

    Run fastp for QC and trimming of paired-end reads.

    Inputs:
    - sample: sample identifier
    - R1, R2: raw fastq files

    Outputs:
    - trimmed paired fastq files for downstream processing
========================================================================================
*/

process FASTP {
    
    cpus 4

    input:
    tuple val(sample), path(R1), path(R2)

    output:
    tuple val("${sample}"), path("${sample}_trimmed.paired_R1.fq.gz"), path("${sample}_trimmed.paired_R2.fq.gz"), emit: trimmed, optional: true
    path "${sample}.reads.tsv", emit: reads
    path "tools.csv"

    script:
    """
    source /mnt/data/miniconda3/bin/activate /mnt/data/miniconda3/envs/fastp

    echo "Stage,Software_version" > tools.csv
    echo "fastp,\$(fastp --version)" >> tools.csv

    fastp \
    -i ${R1} -I ${R2} \
    -o ${sample}_trimmed.paired_R1.fq.gz -O ${sample}_trimmed.paired_R2.fq.gz \
    --json ${sample}.fastp.json --html ${sample}.fastp.html \
    --detect_adapter_for_pe \
    --cut_right --cut_right_window_size 4 --cut_right_mean_quality 20 \
    --length_required 75 \
    --thread 4

    """
    }
