/*Comment section: */

process md5sum_paired_entry {
  label 'ubuntu'  
  input:
    tuple val(name), file(read)

  output:
    tuple val(name), file("${name}*.checksum")

  script:
    """
    if hash md5sum 2>/dev/null; then
      md5sum ${read[0]}  > ${name}_R1.checksum
      md5sum ${read[1]}  > ${name}_R2.checksum
    else
      md5 ${read[0]}  > ${name}_R1.checksum
      md5 ${read[1]}  > ${name}_R2.checksum
    fi
    """
}
