
# Implementation of conversational tools for TCGA data access

#' List Available TCGA Cancer Types
#'
#' @return A data.frame with disease codes, names, and subtype availability
list_cancer_types_df <- function() {
  data('diseaseCodes', package = "TCGAutils")
  available_codes <- diseaseCodes[diseaseCodes$Available == "Yes", ]
  
  result <- data.frame(
    Code = available_codes$Study.Abbreviation,
    Name = available_codes$Study.Name,
    Subtype_Data = available_codes$SubtypeData,
    stringsAsFactors = FALSE
  )
  
#  message(sprintf("Found %d available TCGA cancer types", nrow(result)))
  return(result)
}

#> data('diseaseCodes', package = "TCGAutils")
#> head(diseaseCodes)
#  Study.Abbreviation Available SubtypeData
#1                ACC       Yes         Yes


#' Produce list of code-name pairs for available TCGA Cancer Types
#'
#' @return A data.frame with disease codes, names, and subtype availability
list_cancer_types_li <- function() {
  data('diseaseCodes', package = "TCGAutils")
  dca = diseaseCodes |> dplyr::filter(Available == "Yes")
  ans = vector("list", nrow(dca))
  ans = lapply(seq_len(nrow(dca)), function(x) c(code=dca$Study.Abbreviation[x], name=dca$Study.Name[x]))
#  names(ans) = cda$Study.Abbreviation
  ans
}


#' type object for use with cancer types
#' @note use in chat_structured
#' @export
cantypes_str = function() {
type_array(type_object(codes = type_string(description = "TCGA tumor type codes"),
         types = type_string(description = "TCGA tumor study names"), .description="list of codes and study names"))
}

#
#' List Available Assays for a Disease
#'
#' @param diseaseCode TCGA disease code (e.g., "BRCA", "COAD")
#' @return List with disease code, version, and available assays
#' @note we hard code version to 2.1.1
#' @export
list_assays_for_disease_li <- function(diseaseCode) {
  if (!requireNamespace("curatedTCGAData", quietly = TRUE)) {
    stop("Package 'curatedTCGAData' is required but not installed.")
  }
  version = "2.1.1"
  
  # Use dry.run to get available assays without downloading
  result <- curatedTCGAData::curatedTCGAData(
    diseaseCode = diseaseCode,
    assays = "*",
    version = version,
    dry.run = TRUE,
    verbose = FALSE
  )
  
  # Extract and format assay names
  assay_names <- unique(gsub(paste0("^", diseaseCode, "_"), "", result$title))
  assay_names <- gsub("-\\\\d{8}.*$", "", assay_names)
  assay_names <- sort(unique(assay_names))
  
  message(sprintf("Disease: %s (version %s)", diseaseCode, version))
  message(sprintf("Available assays: %d", length(assay_names)))
  message(paste(assay_names, collapse = ", "))
  
  return(list(
    diseaseCode = diseaseCode,
    version = version,
    available_assays = assay_names,
    count = length(assay_names)
  ))
}

