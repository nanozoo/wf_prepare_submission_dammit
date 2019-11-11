/*Comment section: */

process xml_get_study {
  label 'label'  
  publishDir "${params.output}/", mode: 'copy', pattern: "project.xml"
  
  input:
    file(yml)
    file(script)
  
  output:
    file("project.xml")
  
  script:
    """
    #!/usr/bin/env bash

    source ${script}
    eval \$(parse_yml ${yml} "CONF_")

    cat >project.xml <<EOL
<PROJECT_SET>
   <PROJECT alias="\${CONF_study_alias}">
      <TITLE>"\${CONF_study_title}"</TITLE>
      <DESCRIPTION>"\${CONF_study_description}"</DESCRIPTION>
      <SUBMISSION_PROJECT>
         <SEQUENCING_PROJECT/>
      </SUBMISSION_PROJECT>
   </PROJECT>
</PROJECT_SET>

    """
}

