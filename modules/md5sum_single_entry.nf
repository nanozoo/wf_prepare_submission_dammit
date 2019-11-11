/*Comment section: */

process md5sum_single_entry {
  label 'ubuntu'  
  input:
    tuple val(name), file(read)

  output:
    tuple val(name), file("${name}_single.checksum")

  script:
    """
    md5sum ${read}  > ${name}_single.checksum
    """
}
