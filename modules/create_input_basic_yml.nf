/*Comment section: */

process create_input_basic_yml {
  label 'ubuntu'  
  publishDir "${params.output}/", mode: 'copy', pattern: "INPUT_FORM.yml"
  
  input:
    tuple val(nano_name), file(nano_reads), file(nano_md5)
    tuple val(illumina_name), file(illumina_reads), file(illumina_md5)

  output:
    file("INPUT_FORM.yml")
  
  script:
"""
#!/usr/bin/env bash

year=\$(date +"%Y")

# STUDY
cat >INPUT_FORM.yml <<EOF
study:
  alias: 'STUDY_ALIAS'
  title: 'STUDY_TITLE'
  description: 'STUDY_DESC'  

samples:
EOF

# SAMPLE
for FILE in \$(ls ${nano_reads}); do
cat >>INPUT_FORM.yml <<EOF
  sample_set:
    alias: '${nano_name}'
    title: 'SAMPLE_TITLE'
    sample_name: 
      taxon_id: 'ID, see standard taxonomies: https://ena-docs.readthedocs.io/en/latest/faq/taxonomy.html and environmental taxonomies: https://ena-docs.readthedocs.io/en/latest/faq/taxonomy.html#environmental-taxonomic-classifications'
      scientific_name: 'NAME ACCORDING TO taxon_id'
    sample_attributes:
      sample_attribute:
        tag: 'collection date'
        value: 'yyyy-mm-dd'
      sample_attribute:
        tag: 'sequencing method'
        value: 'Oxford Nanopore Technologies'
EOF
done
for FILE in \$(ls ${illumina_name}*R1*); do
cat >>INPUT_FORM.yml <<EOF
  sample_set:
    alias: '${illumina_name}'
    title: 'SAMPLE_TITLE'
    sample_name: 
      taxon_id: 'ID, see standard taxonomies: https://ena-docs.readthedocs.io/en/latest/faq/taxonomy.html and environmental taxonomies: https://ena-docs.readthedocs.io/en/latest/faq/taxonomy.html#environmental-taxonomic-classifications'
      scientific_name: 'NAME ACCORDING TO taxon_id'
    sample_attributes:
      sample_attribute:
        tag: 'collection date'
        value: 'yyyy-mm-dd'
      sample_attribute:
        tag: 'sequencing method'
        value: 'Illumina'
EOF
done

# EXPERIMENTS
cat >>INPUT_FORM.yml <<EOF

experiments:
EOF

for FILE in \$(ls ${nano_reads}); do
cat >>INPUT_FORM.yml <<EOF
  experiment_set:
    alias: 'exp_${nano_name}'
    study_refname: 'STUDY_ALIAS'
    design:
      sample_refname: ${nano_name}
      library_descriptor:
        library_strategy: 'WGS'
        library_source: 'METAGENOMIC'
        library_selection: 'size fractionation'
        library_layout:
          single: 
        library_construction_protocol: 'We performed Nanopore sequencing ...'
    platform: 
      nanopore:
        instrument_model: 'Oxford Nanopore Technologies MinION'
    experiment_attributes:
      experiment_attribute:
        tag: 'library preparation date'
        value: 'yyyy-mm'
EOF
done
for FILE in \$(ls ${illumina_name}*R1*); do
cat >>INPUT_FORM.yml <<EOF
  experiment_set:
    alias: 'exp_${illumina_name}'
    study_refname: 'STUDY_ALIAS'
    design:
      sample_refname: ${illumina_name}
      library_descriptor:
        library_strategy: 'WGS'
        library_source: 'METAGENOMIC'
        library_selection: 'size fractionation'
        library_layout:
          paired: 
            nominal_length: '300'
        library_construction_protocol: 'Illumina libraries ...'
    platform: 
      illumina:
        instrument_model: 'Illumina MiSeq'
    experiment_attributes:
      experiment_attribute:
        tag: 'library preparation date'
        value: 'yyyy-mm'
EOF
done

# RUNS
cat >>INPUT_FORM.yml <<EOF

runs:
EOF

for FILE in \$(ls ${nano_reads}); do
cat >>INPUT_FORM.yml <<EOF
  run_set:
    alias: 'run_${nano_name}'
    experiment_ref: 'exp_${nano_name}'
    data_block:
      files:
        file:
          filename: '${nano_reads}'
          filetype: 'fastq'
          checksum_method: 'md5'
          checksum: '35739c52e8d4f62fdf705af09d912c37'
        file:
          filename: 'fast5.tar.gz'
          filetype: 'OxfordNanopore_native'
          checksum_method: 'md5'
          checksum: ''
EOF
done
for FILE in \$(ls ${illumina_name}*R1*); do
cat >>INPUT_FORM.yml <<EOF
  run_set:
    alias: 'run_${illumina_name}'
    experiment_ref: 'exp_${illumina_name}'
    data_block:
      files:
        file:
          filename: '${illumina_reads[0]}'
          filetype: 'fastq'
          checksum_method: 'md5'
          checksum: '5458d0fc235571bb0aa5ca89d5f24144'
        file:
          filename: '${illumina_reads[1]}'
          filetype: 'fastq'
          checksum_method: 'md5'
          checksum: '43f76e73175fbe9587ca9e447a2ad0b8'
EOF
done


    """
}
