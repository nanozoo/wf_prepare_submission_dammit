/*Comment section: */

process experiment_template_paired {
  label 'label'  
  //publishDir "${params.output}/", mode: 'copy', pattern: "${name}.templateSamples"
  
  input:
    tuple val(name), file(file)
  
  output:
    file("${name}.experimentsSamples")
  
  script:
    """
    md5sum_value1=\$(cat ${file[0]} | cut -f1 -d " ")
    file_name_value1=\$(cat ${file[0]} | rev | cut -f1 -d " " | rev)

    md5sum_value2=\$(cat ${file[1]} | cut -f1 -d " ")
    file_name_value2=\$(cat ${file[1]} | rev | cut -f1 -d " " | rev )

    printf "${name}-illumina\\tIllumina MiSeq\\tfastq\\tMETAGENOMIC\\tunspecified\\t" > ${name}.experimentsSamples
    printf "WGS\\t\\t\\t150\\t\${file_name_value1}\\t\${md5sum_value1}\\t\${file_name_value2}\\t\${md5sum_value2}\\n" >> ${name}.experimentsSamples
    """
}

/*
sample_alias	instrument_model	library_name	library_source	library_selection	library_strategy	design_description	library_construction_protocol	insert_size	forward_file_name	forward_file_md5	reverse_file_name	reverse_file_md5


			run_alias	library_name	library_source	library_selection	library_strategy	design_description	library_construction_protocol	instrument_model	file_type	library_layout	insert_size	forward_file_name	forward_file_md5	forward_file_unencrypted_md5	reverse_file_name	reverse_file_md5	reverse_file_unencrypted_md5
			unspecified	METAGENOMIC	unspecified	WGS			Illumina MiSeq	fastq	PAIRED	150		a7644e579867643a363a47b9d1708a11			5c0a607879f87612dd16ee01a433fdba	

*/