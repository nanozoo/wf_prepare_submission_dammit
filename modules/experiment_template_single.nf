/*Comment section: */

process experiment_template_single {
  label 'label'  
  //publishDir "${params.output}/", mode: 'copy', pattern: "${name}.templateSamples"
  
  input:
    tuple val(name), file(file)
  
  output:
    file("${name}.experimentsSamples")
  
  script:
    """
    md5sum_value=\$(cat ${file} | cut -f1 -d " ")
    file_name_value=\$(cat ${file} | rev | cut -f1 -d " " | rev)

    printf "${name}-nanopore\\tMinION\\tLSK-109\\tMETAGENOMIC\\tunspecified\\tWGS\\t\\t\\t\${file_name_value}\\t\${md5sum_value}\\n" > ${name}.experimentsSamples
    """
}

