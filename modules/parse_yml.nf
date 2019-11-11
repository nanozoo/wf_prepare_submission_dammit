/*Comment section: */

process parse_yml {
  label 'label'  
  publishDir "${params.output}/", mode: 'copy', pattern: "parsed.txt"
  
  input:
    file(yml)
    file(script)
  
  output:
    file("parsed.txt")
  
  script:
    """
    #!/usr/bin/env bash
    source ${script}
    parse_yml ${yml} "CONF_" > parsed.txt
    """
}
