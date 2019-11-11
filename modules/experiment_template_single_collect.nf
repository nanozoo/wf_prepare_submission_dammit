/*Comment section: */

process experiment_template_single_collect {
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
    printf "\\tlibrary_strategy\\tdesign_description\\tlibrary_construction_protocol\\tfile_name\\tfile_md5\\n" >> experiment_template.tsv


    # collect and add
    cat *.experimentsSamples >> experiment_template.tsv 
    """
}