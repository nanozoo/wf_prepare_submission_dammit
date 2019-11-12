/*Comment section: */

process create_input_basic_yml {
  label 'ubuntu'  
  publishDir "${params.output}/", mode: 'copy', pattern: "INPUT_FORM.yml"
  
  input:
    file(illumina_file_list)
    file(illumina_md5_list)
    file(nanopore_file_list)
    file(nanopore_md5_list)
    //tuple val(nano_name), file(nano_reads), file(nano_md5)
    //tuple val(illumina_name), file(illumina_reads), file(illumina_md5)

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
for FILE in \$(ls *R1*.gz); do
BN=\$(basename \${FILE} .R1.fastq.gz)
cat >>INPUT_FORM.yml <<EOF
  sample_set:
    alias: '\${BN}'
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

for FILE in \$(ls *R1*.gz); do
BN=\$(basename \${FILE} .R1.fastq.gz)
cat >>INPUT_FORM.yml <<EOF
  experiment_set:
    alias: 'exp_\${BN}'
    study_refname: 'STUDY_ALIAS'
    design:
      sample_refname: \${BN}
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

for FILE in \$(ls *R1*.gz); do
BN=\$(basename \${FILE} .R1.fastq.gz)
cat >>INPUT_FORM.yml <<EOF
  run_set:
    alias: 'run_\${BN}'
    experiment_ref: 'exp_\${BN}'
    data_block:
      files:
        file:
          filename: '\${FILE}'
          filetype: 'fastq'
          checksum_method: 'md5'
          checksum: '\$(cat \${BN}*R1*checksum | cut -f1 -d " ")'
        file:
          filename: '\$(echo \${FILE} | sed 's/R1/R2/g')'
          filetype: 'fastq'
          checksum_method: 'md5'
          checksum: '\$(cat \${BN}*R2*checksum | cut -f1 -d " ")'
EOF
done

"""
}


/*




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
          checksum: '\$(cat ${nano_md5} | cut -f1 -d " ")'
        file:
          filename: 'fast5.tar.gz'
          filetype: 'OxfordNanopore_native'
          checksum_method: 'md5'
          checksum: ''
EOF
done

*/