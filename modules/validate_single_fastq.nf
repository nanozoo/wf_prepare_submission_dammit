/*Comment section: */

process validate_single_fastq {
  label 'ubuntu'  
    publishDir "${params.output}/", mode: 'copy', pattern: "${name}_ENA_qc_check.txt"
  input:
    tuple val(name), file(read)

  output:
    tuple val(name), file("${name}_ENA_qc_check.txt") optional true

  script:
    """
    fastq_lines=\$(gzip -d -c ${read} | wc -l)

    if (( \${fastq_lines} % 4 == 0 ))         
    then
      echo "${read} passed ENA qc check" 
    else
      echo "${read} FASTQ check NOT passed, lines: \${fastq_lines}" >> ${name}_ENA_qc_check.txt
    fi
    """
}
