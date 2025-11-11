# in this file, use ellmer::tool to define registerable mcp tools 

# last lines should return the list of tools


#' make tool for listing cancer types
#' @import ellmer
#' @export
list_cancer_types = tool(fun=list_cancer_types_li, 
  description="This function uses TCGAutils to list cancer types that have samples available to curatedTCGAData.",
  arguments=list(), convert=TRUE)

#' make tool for listing available assays
#' @export
list_assays_for_disease = tool(fun=list_assays_for_disease_li, description="
 This function uses curatedTCGAData to acquire a list of assay types
", arguments=list(diseaseCode=type_string()), convert=TRUE)


bioc_tcga_tools = function() list( list_cancer_types, list_assays_for_disease) 
