# Workflow ENA Read Upload

![](https://img.shields.io/badge/nextflow-19.10.0-brightgreen)
![](https://img.shields.io/badge/uses-docker-blue.svg)



![](https://github.com/nanozoo/wf_template/workflows/Syntax_check/badge.svg)

Maintainer: Christian & Martin

Email: christian@nanozoo.org || martin@nanozoo.org

# Whats this?

* This is a current work in progress pipeline to simplify Read uploads to ENA
* why? because its f**ing annoying if you need to handle huge files

## Supported Sample types (extending soon)

* wastewater_sludge (metagenomic samples like anaerobic digester)


# Whats it doing (TLDR)?

* it creates a super simple input form to fill
* you give him your reads you want to upload
* it creates the template experiment and template run for your upload


# Normal Installation

**Dependencies**

>   * docker (add docker to your Usergroup, so no sudo is needed)
>   * nextflow + java runtime 
>   * git (should be allready installed)
>   * wget (should be allready installed)
>   * tar (should be allready installed)

* Docker installation [here](https://docs.docker.com/v17.09/engine/installation/linux/docker-ce/ubuntu/#install-docker-ce)
* Nextflow installation [here](https://www.nextflow.io/)
* move or add the nextflow executable to a bin path
* add docker to ypur User group via `sudo usermod -a -G docker $USER`


# How to use it:

```help
This Workflow contains two possible upload types. 

      TSV tables  (ready to use templates during the graphical ENA webinterface)
      XML files  (command line subbmission of samples/experiments via upload)
    _____________________________

    TSV TABLES GENERATOR
    
    Step 1: Choose a sample template and fill out the INPUT_FORM.txt
              nextflow run main.nf --wastewater_sludge
            Hint: file is located in results/INPUT_FORM.txt

    Step 2: create ENA tsv templates for file submission 
              nextflow run main.nf --nano '*.fastq.gz' --wastewater_sludge --template results/INPUT_FORM.txt
            Hint: needs read files (--nano '*.fastq.gz' or --illumina '*.R{1,2}.fastq.gz')
                          the sample template type (e.g. --wastewater_sludge)
                          and --template results/INPUT_FORM.txt

    Step 3: Upload everything to ENA (help available via nextflow run main.nf --help4ENA) 
            Hint: you can still adjust the tsv tables now
    _____________________________

    __WIP__ XML GENERATOR:

    nextflow run main.nf --basic --nano data/h52_nanopore.fastq.gz --illumina 'data/h52_miseq*.R{1,2}.fastq.gz'
    nextflow run main.nf --basic --xml --yml results/INPUT_FORM.yml --nano data/some.fasta --illumina 'data/some_illumina_pe/sample1*.R{1,2}*.gz'

```


# Flowchart TSV
![chart](figures/chart.png)