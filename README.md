# SRA-analysis

### A Nextflow DSL2 pipeline for downloading public paired-end sequencing reads and analysing.

## Overview

Downloads a defined set of paired-end fastq files from the European Nucleotide Archive (ENA), given a simple three-column samplesheet of fastq IDs and URLs. Built as a self-contained example of Nextflow DSL2 module structure.

Sample data used in development is drawn from [PRJNA1128840](https://www.ncbi.nlm.nih.gov/bioproject/PRJNA1128840), a public *Salmonella enterica* whole-genome sequencing BioProject.

## Current Workflow

- Read a samplesheet of ENA fastq URLs (`testdata/samplesheet.tsv`)
- Download R1/R2 for each run in parallel
- Publish results per sample to `results/raw_reads/`
- Run [fastp](https://github.com/opengene/fastp) on samples for trimming and quality control
- Run [kraken2](https://github.com/DerrickWood/kraken2) for taxonomic classification of samples
- Assemble genomes using [SKESA](https://github.com/ncbi/SKESA)
- Type genomes using [MLST](https://github.com/tseemann/mlst)

## Project Structure

```
SRA-analysis/
├── modules/
│   └──  download_testdata.nf   # Download
│   └──  fastp.nf               # Assess FASTQ file quality and trim
│   └──  kraken.nf              # Taxonomic classification
│   └──  skesa.nf               # De novo genome assembly
│   └──  mlst.nf                # Multi-locus sequence typing on contigs
├── testdata/
│   └── samplesheet.tsv         # Fastq URL pairs (tab-separated, no header)
├── workflow/
│   └── main.nf                 # Workflow
│   └── nextflow.config         # Default parameters
```

## Usage

```bash
nextflow run main.nf --samplesheet testdata/samplesheet.tsv --outdir results
```

Samplesheet format (tab-separated, no header):

```
<ID1>  <url_1>	<url_2>
<ID2>  <url_1>	<url_2>
```

## Technologies

- **Nextflow** (DSL2) - Workflow orchestration
- **wget** - File download
- **ENA** - Public read data source

## Prerequisites

- Nextflow (23.x or later)
- Internet access to `ftp.sra.ebi.ac.uk`
- Miniconda3 or equivalent, with the path specified in [nextflow.config](workflow/nextflow.config)

## Dependencies
- [fastp](https://github.com/opengene/fastp)
- [kraken2](https://github.com/DerrickWood/kraken2)
- [SKESA](https://github.com/ncbi/SKESA)
- [MLST](https://github.com/tseemann/mlst)

## License

MIT
