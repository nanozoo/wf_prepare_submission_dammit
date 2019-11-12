#!/usr/bin/env nextflow
nextflow.preview.dsl=2

/*
Nextflow
Author: contact@nanozoo.org
*/

/************************** 
* META & HELP MESSAGES 
**************************/

/* 
Comment section: First part is a terminal print for additional user information,
followed by some help statements (e.g. missing input) Second part is file
channel input. This allows via --list to alter the input of --nano & --illumina
to add csv instead. name,path   or name,pathR1,pathR2 in case of illumina 
*/

// terminal prints
if (params.help) { exit 0, helpMSG() }

println " "
println "\u001B[32mProfile: $workflow.profile\033[0m"
println " "
println "\033[2mCurrent User: $workflow.userName"
println "Nextflow-version: $nextflow.version"
println "Starting time: $nextflow.timestamp"
println "Workdir location:"
println "  $workflow.workDir\u001B[0m"
println " "
if (workflow.profile == 'standard') {
println "\033[2mCPUs to use: $params.cores"
println "Output dir name: $params.output\u001B[0m"
println " "}

if (params.profile) { exit 1, "--profile is WRONG use -profile" }
//if (params.nano == '' &&  params.illumina == '' ) { exit 1, "input missing, use [--nano] or [--illumina]"}
//if (params.xml && params.yml == '') { exit 1, "--yml is required if XML output is activated" }

/************************** 
* READ FILE INPUT CHANNELS
**************************/

// nanopore reads input & --list support
if (params.nano && params.list) { nano_input_ch = Channel
    .fromPath( params.nano, checkIfExists: true )
    .splitCsv()
    .map { row -> ["${row[0]}", file("${row[1]}", checkIfExists: true)] }
    .view() }
else if (params.nano) { nano_input_ch = Channel
    .fromPath( params.nano, checkIfExists: true)
    .map { file -> tuple(file.simpleName, file) }
    .view() }

// illumina reads input & --list support
if (params.illumina && params.list) { illumina_input_ch = Channel
    .fromPath( params.illumina, checkIfExists: true )
    .splitCsv()
    .map { row -> ["${row[0]}", [file("${row[1]}", checkIfExists: true), file("${row[2]}", checkIfExists: true)]] }
    .view() }
else if (params.illumina) { illumina_input_ch = Channel
    .fromFilePairs( params.illumina , checkIfExists: true )
    .view() }



/************************** 
* INPUT CHANNELS TEMPLATES
**************************/
/******** 
* TSV
********/

if (!params.xml) {
  // nanopore based templates
  if (params.nano) { template_input_ch = Channel
      .fromPath( params.nano, checkIfExists: true)
      .map { file -> (file.simpleName) }
      .combine( tmp_ch = Channel.fromPath(params.template, checkIfExists: true ))
      .view() }
  else if (params.nano && !params.list) { template_input_ch = Channel
      .fromPath( params.nano, checkIfExists: true)
      .map { file -> (file.simpleName) }
      .combine( tmp_ch = Channel.fromPath(params.template, checkIfExists: true ))
      .view() }
  // illumina based templates
  if (params.illumina && params.list) { template_input_ch = Channel
      .fromPath( params.illumina, checkIfExists: true)
      .splitCsv()
      .map { row -> ["${row[0]}"] }
      .combine( tmp_ch = Channel.fromPath(params.template, checkIfExists: true ))
      .view() }
  else if (params.illumina && !params.list) { template_input_ch = Channel
      .fromPath( params.illumina, checkIfExists: true)
      .map { file -> (file.simpleName) }
      .combine( tmp_ch = Channel.fromPath(params.template, checkIfExists: true ))
      .view() }
}

/******** 
* XML
********/

/*
if (params.xml) {
    // nanopore based templates
  if (params.nano) { template_input_ch = Channel
      .fromPath( params.nano, checkIfExists: true)
      .map { file -> (file.simpleName) }
      .combine( tmp_ch = Channel.fromPath(params.yml, checkIfExists: true ))
      .view() }
  else if (params.nano && !params.list) { template_input_ch = Channel
      .fromPath( params.nano, checkIfExists: true)
      .map { file -> (file.simpleName) }
      .combine( tmp_ch = Channel.fromPath(params.template, checkIfExists: true ))
      .view() }
  // illumina based templates
  if (params.illumina && params.list) { template_input_ch = Channel
      .fromPath( params.illumina, checkIfExists: true)
      .splitCsv()
      .map { row -> ["${row[0]}"] }
      .combine( tmp_ch = Channel.fromPath(params.yml, checkIfExists: true ))
      .view() }
  else if (params.illumina && !params.list) { template_input_ch = Channel
      .fromPath( params.illumina, checkIfExists: true)
      .map { file -> (file.simpleName) }
      .combine( tmp_ch = Channel.fromPath(params.yml, checkIfExists: true ))
      .view() }
}
*/

/************************** 
* MODULES
**************************/

/* Comment section: */

include './modules/experiment_template_single' params(output: params.output)
include './modules/experiment_template_single_collect' params(output: params.output)
include './modules/experiment_template_paired' params(output: params.output)
include './modules/experiment_template_paired_collect' params(output: params.output)
include './modules/md5sum_paired_entry' 
include './modules/md5sum_single_entry' 
include './modules/validate_paired_fastq' params(output: params.output)
include './modules/validate_single_fastq' params(output: params.output)

// TSV TEMPLATE BASIC
include './modules/tsv_template_basic/create_input_basic' params(output: params.output)

// TSV TEMPLATE WASTEWATER SOIL
include './modules/tsv_template_wastewater/create_input_wastewater_sludge' params(output: params.output)
include './modules/tsv_template_wastewater/sample_template_wastewater_sludge' params(output: params.output)
include './modules/tsv_template_wastewater/sample_template_wastewater_sludge_collect' params(output: params.output)

// xml stuff
include './modules/xml_get_study' params(output: params.output)

// XML TEMPLATE BASIC
include './modules/create_input_basic_yml' params(output: params.output)


/************************** 
* SUB WORKFLOWS
**************************/

/* Comment section: */

workflow wf_nanopore_experiment_template {
  get: 
    nano_input_ch
  main:
    md5sum_single_entry(nano_input_ch)
    experiment_template_single_collect(experiment_template_single(md5sum_single_entry.out).toList())
} 

workflow wf_illumina_experiment_template {
  get: 
    illumina_input_ch
  main:
    md5sum_paired_entry(illumina_input_ch)
    experiment_template_paired_collect(experiment_template_paired(md5sum_paired_entry.out).toList())
} 

workflow wf_validate_single_fastq {
  get: 
    nano_input_ch
  main:
    validate_single_fastq(nano_input_ch)
} 

workflow wf_validate_paired_fastq {
  get: 
    illumina_input_ch
  main:
    validate_paired_fastq(illumina_input_ch)
} 

workflow wf_create_template_wastewater_sludge {
  get: 
    template_input_ch
  main:
    sample_template_header_metagenome(sample_template_wastewater_sludge(template_input_ch).toList())
} 

workflow xml {
  get: 
    yml
    script
  main:
    xml_get_study(yml, script)
}



/************************** 
* WORKFLOW ENTRY POINT
**************************/

/* Comment section: */

workflow {
    // valiate fastq's
      if (params.nano && !params.illumina && params.template && !params.skipval) { wf_validate_single_fastq(nano_input_ch) }
      if (!params.nano && params.illumina && params.template && !params.skipval) { wf_validate_paired_fastq(illumina_input_ch) }

    // WIP Martin XML support
      if (params.xml) {
        if (params.yml) { 
          yml = file(params.yml)
          script = file('scripts/parse_yml.sh')
          xml(yml, script)
        }
        else {
          if (params.nano && !params.illumina) { wf_validate_single_fastq(nano_input_ch) }
          if (!params.nano && params.illumina) { wf_validate_paired_fastq(illumina_input_ch) }
          if (!params.template && params.basic) { create_input_basic_yml(nano_input_ch.join(md5sum_single_entry(nano_input_ch)), illumina_input_ch.join(md5sum_paired_entry(illumina_input_ch))) }
        }
      }
    // Christian TSV support
      else {
        // create user input form (depending on the user flag)
        if (!params.template && params.basic) { create_input_basic() }
        if (!params.template && params.wastewater_sludge) { create_input_wastewater_sludge() }

        // create experiment template
        if (params.nano && !params.illumina && params.template) { wf_nanopore_experiment_template(nano_input_ch) }
        if (!params.nano && params.illumina && params.template) { wf_illumina_experiment_template(illumina_input_ch) }
 
        // create sample template (depending on the user flag)
          // -- wastewater_sludge
          if ( (params.nano || params.illumina) && params.template && params.wastewater_sludge) { 
              wf_create_template_wastewater_sludge(template_input_ch) }
          // -- metagenome


      

      }
}


/**************************  
* --help
**************************/
def helpMSG() {
    c_green = "\033[0;32m";
    c_reset = "\033[0m";
    c_yellow = "\033[0;33m";
    c_blue = "\033[0;34m";
    c_dim = "\033[2m";
    log.info """
    ____________________________________________________________________________________________
    
    Workflow: ENA Template generator

    How to use it:

    Step 1: Choose a sample template, and create INPUT_FORM.txt:
       ${c_yellow}nextflow run main.nf --wastewater_sludge${c_reset} 

    Step 2: adjust the input form (located in ${params.output}/INPUT_FORM.txt)

    Step 3: create now templates for ENA by adding reads, sample type and template file:
      ${c_yellow}nextflow run main.nf --nano '*.fastq.gz' --wastewater_sludge --template ${params.output}/INPUT_FORM.txt${c_reset} 
    
    Step 4: upload reads via ${c_yellow}ftp webin.ebi.ac.uk${c_reset} 
    ${c_dim}Hint: The workflow creates "${params.output}/*_ENA_qc_check.txt" files if the fastq is corrupt.${c_reset}

    Step 5: register a PROJECT on ENA

    Step 6: "Submit sequence reads and experiments" -> "next" -> click on your project -> "next"

    Step 7: click on "Submit Completed Spreadsheet" an upload ${params.output}/sample_template.tsv -> "next"

    Step 8: click on "Oxford Nanopore" or "Two Fastq files (Paired)" -> "Upload Completed Spreadsheet"

    Step 9: check that "[Sample reference suggestions]" is correctly linking to your reads, select missing inputs. DONE

    __WIP__ XML example execution:

    nextflow run main.nf --basic --nano data/h52_nanopore.fastq.gz --illumina 'data/h52_miseq*.R{1,2}.fastq.gz'
    nextflow run main.nf --basic --xml --yml results/INPUT_FORM.yml --nano data/some.fasta --illumina 'data/some_illumina_pe/sample1*.R{1,2}*.gz'
    
    ${c_yellow}Usage example:${c_reset}
    

    ${c_yellow}Sample:${c_reset}
    ${c_green} --nano ${c_reset}            '*.fastq.gz'         -> one sample per file
    ${c_green} --illumina ${c_reset}        '*.R{1,2}.fastq.gz'  -> file pairs
    ${c_dim}  ..change above input to csv:${c_reset} ${c_green}--list ${c_reset}
    ${c_green} --yml ${c_reset}             '*.yml'  -> one file per study
  
    ${c_green} --template ${c_reset}        '${params.output}/INPUT_FORM.txt' -> location of your template file   
    ${c_green} --skipval ${c_reset}          skips file validation

    ${c_yellow}Sample templates:${c_reset}
    --basic
    --wastewater_sludge


    ${c_yellow}Options:${c_reset}
    --cores             max cores for local use [default: $params.cores]
    --memory            max memory for local use [default: $params.memory]
    --output            name of the result folder [default: $params.output]

    ${c_yellow}Parameters:${c_reset}
    --xml               generate XMLs for submission [default: $params.xml]

    ${c_dim}Nextflow options:
    -with-report rep.html    cpu / ram usage (may cause errors)
    -with-dag chart.html     generates a flowchart for the process tree
    -with-timeline time.html timeline (may cause errors)

    Profile:
    -profile                 standard (local, pure docker) [default]
                             conda (mixes conda and docker)
                             nanozoo (googlegenomics and docker)  
                             gcloudAdrian (googlegenomics and docker)
                             gcloudChris (googlegenomics and docker)
                             gcloudMartin (googlegenomics and docker)
                             ${c_reset}
    """.stripIndent()
}
