/*Comment section: */

process validate_paired_fastq {
  label 'ubuntu'  

  input:
    tuple val(name), file(read)

  output:
    tuple val(name), file("${name}_ENA_qc_check.txt") optional true

  script:
    """
    fastq0_lines=\$(gzip -d -c ${read[0]} | wc -l)
    fastq1_lines=\$(gzip -d -c ${read[1]} | wc -l)

    if (( \${fastq0_lines} % 4 == 0 ))         
    then
      echo "${read[0]} passed ENA qc check" 
    else
      echo "${read[0]} FASTQ check NOT passed, lines: \${fastq0_lines}" >> ${name}_ENA_qc_check.txt
    fi

    if (( \${fastq1_lines} % 4 == 0 ))         
    then
      echo "${read[1]} passed ENA qc check" 
    else
      echo "${read[1]} FASTQ check NOT passed, lines: \${fastq1_lines}" >> ${name}_ENA_qc_check.txt
    fi
    """
}
