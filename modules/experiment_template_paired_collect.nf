/*Comment section: */

process experiment_template_paired_collect {
  label 'ubuntu'  
  publishDir "${params.output}/", mode: 'copy', pattern: "experiment_template.tsv"
  
  input:
    file(combined)
  
  output:
    file("experiment_template.tsv")
  
  script:
    """
    # header
    printf "sample_alias\\tinstrument_model\\tlibrary_name\\tlibrary_source\\tlibrary_selection" >> experiment_template.tsv
    printf "\\tlibrary_strategy\\tdesign_description\\tlibrary_construction_protocol\\tinsert_size" >> experiment_template.tsv
    printf "\\tforward_file_name\\tforward_file_md5\\treverse_file_name\\treverse_file_md5\\n" >> experiment_template.tsv
    
    # collect and add
    cat *.experimentsSamples >> experiment_template.tsv 
    """
}


/*
\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t
\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t\\t1
\\t\\t\\t\\t1

*/