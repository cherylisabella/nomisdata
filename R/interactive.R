
#' Browse Dataset Online
#' 
#' @importFrom utils head
#' 
#' @description Opens the Nomis web interface for a dataset in your browser.
#' 
#' @param id Dataset ID (e.g., "NM_1_1")
#' @param page Which page to open: "dataset", "download", "metadata"
#' 
#' @return Invisible TRUE if successful. Called for side effects (opening browser).
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' browse_dataset("NM_1_1")
#' browse_dataset("NM_1_1", page = "download")
#' }
#' @importFrom utils head
browse_dataset <- function(id, page = c("dataset", "download", "metadata")) {
  page <- match.arg(page)
  
  base_url <- "https://www.nomisweb.co.uk"
  
  url <- switch(page,
                dataset = paste0(base_url, "/datasets/", id),
                download = paste0(base_url, "/query/select/getdatasetbytheme.asp?opt=3&theme=&subgrp="),
                metadata = paste0(base_url, "/api/v01/dataset/", id, "/def.htm")
  )
  
  if (interactive()) {
    utils::browseURL(url)
    cli::cli_alert_success("Opening {.url {url}}")
  } else {
    cli::cli_alert_info("URL: {.url {url}}")
  }
  
  invisible(TRUE)
}



#' Interactive Dataset Explorer
#' 
#' @description Opens an interactive menu to explore dataset dimensions and codes.
#'   Only works in interactive R sessions.
#' 
#' @param id Dataset ID
#' 
#' @return Selected codes as a list, or NULL if not interactive.
#' 
#' @export
#' 
#' @examples
#' \dontrun{
#' # Only works in interactive sessions
#' explore_dataset("NM_1_1")
#' }
explore_dataset <- function(id) {
  if (!interactive()) {
    cli::cli_abort("This function requires an interactive session")
  }
  
  cli::cli_h1("Exploring dataset: {id}")
  
  # Get concepts
  concepts <- get_codes(id)
  
  cli::cli_h2("Available dimensions:")
  for (i in seq_len(nrow(concepts))) {
    cli::cli_alert_info("{i}. {concepts$conceptref[i]}")
  }
  
  choice <- as.integer(readline("Select dimension (number): "))
  
  if (choice > 0 && choice <= nrow(concepts)) {
    concept <- concepts$conceptref[choice]
    codes <- get_codes(id, concept)
    
    cli::cli_h2("First 10 codes for {concept}:")
    print(utils::head(codes, 10))
    
    return(list(concept = concept, codes = codes))
  }
  
  invisible(NULL)
}
