/*Comment section: */

process md5sum_single_entry {
  label 'ubuntu'  
  input:
    tuple val(name), file(read)

  output:
    tuple val(name), file("${name}_single.checksum")

  script:
    """
    if hash md5sum 2>/dev/null; then
      md5sum ${read}  > ${name}_single.checksum
    else
      md5 ${read}  > ${name}_single.checksum
    fi
    """
}
