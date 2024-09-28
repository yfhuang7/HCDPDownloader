#' Download Station Metadata from the HCDP API
#'
#' This function queries the HCDP API to retrieve station metadata documents, providing information about the available sensor stations.
#'
#' @param limit Number of records to return (default: 10000).
#' @param offset Offset in the records returned (default: 0).
#' @param token Your personal access token for authentication.
#'
#' @return A data frame containing the station metadata.
#' @export
#' @examples
#' \dontrun{
#'   # Download station metadata with your API token
#'   get_metadata_st(token = "YOUR_ACCESS_TOKEN")
#' }
get_metadata_st <- function(limit = 10000, offset = 0, token) {
  # Load required libraries
  if (!requireNamespace("httr", quietly = TRUE)) install.packages("httr")
  if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")
  library(httr)
  library(jsonlite)

  # Construct the query parameter for station metadata
  query_param <- list(name = "hcdp_station_metadata")

  # Convert query to JSON and URL encode it
  encoded_query <- URLencode(toJSON(query_param, auto_unbox = TRUE))

  # Construct the API URL with query parameters
  base_url <- "https://api.hcdp.ikewai.org/stations"
  full_url <- paste0(base_url, "?q=", encoded_query, "&limit=", limit, "&offset=", offset)

  # Make the GET request using httr
  response <- GET(
    url = full_url,
    add_headers(Authorization = paste("Bearer", token)),
    encode = "json"
  )

  # Check for successful request
  if (status_code(response) == 200) {
    # Parse the JSON response into a data frame
    data <- content(response, "parsed", simplifyDataFrame = TRUE)
    metadata <- data$result$value
    return(as.data.frame(metadata))
  } else {
    # Print error message if failed
    stop("Failed to retrieve station metadata. Status code: ", status_code(response), "\nMessage: ", content(response, "text"))
  }
}
