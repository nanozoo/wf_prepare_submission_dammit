/*Comment section: */

process create_input_wastewater_sludge {
  label 'ubuntu'  
  publishDir "${params.output}/", mode: 'copy', pattern: "INPUT_FORM.txt"
  
  output:
    file("INPUT_FORM.txt")
  
  script:
    """
    year=\$(date +"%Y")

    printf "# This files summarizes inputs needed to fill out the template files\\n" > INPUT_FORM.txt
    printf "# Dont replace the @ values, only the examples after the ';'\\n" >> INPUT_FORM.txt
    printf "@NAME;YOUR_INPUT_MODIFY_THIS_COLUMN\\n" >> INPUT_FORM.txt
    printf "@technology;illumina\\n" >> INPUT_FORM.txt
    printf "@projectname;RiB-DFG\\n" >> INPUT_FORM.txt
    printf "@year;\${year}\\n" >> INPUT_FORM.txt
    printf "@country;Sweden\\n" >> INPUT_FORM.txt
    printf "@latitude;59.858562\\n" >> INPUT_FORM.txt
    printf "@longitude;17.638927\\n" >> INPUT_FORM.txt
    printf "@environment (biome);anaerobic digester\\n" >> INPUT_FORM.txt
    printf "@environment (feature);reactor\\n" >> INPUT_FORM.txt
    printf "@environment (material);sludge\\n" >> INPUT_FORM.txt
    printf "# latitude and longitude go the googlemaps and enter the place city\\n" >> INPUT_FORM.txt
    printf "# alternatively change it later during subbmission individually\\n" >> INPUT_FORM.txt
    """
}
