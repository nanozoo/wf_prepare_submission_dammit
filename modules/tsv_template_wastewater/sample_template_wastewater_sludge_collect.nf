/*Comment section: */

process sample_template_header_metagenome {
  label 'ubuntu'  
  publishDir "${params.output}/", mode: 'copy', pattern: "sample_template.tsv"
  
  input:
    file(combined)
  
  output:
    file("sample_template.tsv")
  
  script:
    """
    # header 1
    printf "#checklist_accession\\tERC000023\\n" > sample_template.tsv	
    printf "#unique_name_prefix\\n" >> sample_template.tsv	
    
    # header 2														
    printf "sample_alias\\ttax_id\\tscientific_name\\tcommon_name\\tsample_title\\tsample_description\\tproject name\\tsequencing method" >> sample_template.tsv
    printf "\\tinvestigation type\\tcollection date\\tgeographic location (country and/or sea)\\tgeographic location (latitude)\\tgeographic location (longitude)" >> sample_template.tsv
    printf "\\twastewater/sludge environmental package\\tenvironment (biome)\\tenvironment (feature)\\tenvironment (material)\\n" >> sample_template.tsv
    
    # units
    printf "#units\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\tDD\\tDD\\n" >> sample_template.tsv	
    cat *.templateSamples >> sample_template.tsv	 
    """
}


/*
\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t
\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t1
\\t\\t\\t\\t1

*/