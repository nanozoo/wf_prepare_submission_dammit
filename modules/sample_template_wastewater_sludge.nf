/*Comment section: */

process sample_template_wastewater_sludge {
  label 'label'  
  //publishDir "${params.output}/", mode: 'copy', pattern: "${name}.templateSamples"
  
  input:
    tuple val(name), file(inputform)
  
  output:
    file("${name}.templateSamples")
  
  script:
    """
    
    technology=\$(grep "@technology;" ${inputform} | cut -f2 -d";")
    projectname=\$(grep "@projectname;" ${inputform} | cut -f2 -d";")
    year=\$(grep "@year;" ${inputform} | cut -f2 -d";")
    country=\$(grep "@country;" ${inputform} | cut -f2 -d";")
    latitude=\$(grep "@latitude;" ${inputform} | cut -f2 -d";")
    longitude=\$(grep "@longitude;" ${inputform} | cut -f2 -d";")
    biome=\$(grep "@environment (biome);" ${inputform} | cut -f2 -d";")
    feature=\$(grep "@environment (feature);" ${inputform} | cut -f2 -d";")
    material=\$(grep "@environment (material);" ${inputform} | cut -f2 -d";")

    printf "${name}-\${technology}\\t256318\\tmetagenome\\t\\t${name}\\tmetagenome\\t\${projectname}\\t\${technology}\\tmetagenome\\t\${year}" >>${name}.templateSamples
    printf "\\t\${country}\\t\${latitude}\\t\${longitude}\\twastewater/sludge\\t\${biome}\\t\${feature}\\t\${material}\n" >>${name}.templateSamples
    """
}

