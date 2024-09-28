#' Download Station Timeseries Data from the HCDP API
#'
#' This function queries the HCDP API to retrieve station timeseries data (e.g., rainfall or temperature) for a specific station.
#'
#' @param station_id The station ID for which data is to be retrieved (e.g., "1094.2").
#' @param datatype The type of data to retrieve (e.g., "rainfall" or "temperature").
#' @param period The time period for the data (e.g., "month", "day").
#' @param fill The fill type for the data (e.g., "partial", "complete").
#' @param start_date Start date for the data query (format: "YYYY-MM-DD").
#' @param end_date End date for the data query (format: "YYYY-MM-DD").
#' @param production Optional. Specifies data production type if required (e.g., "new").
#' @param aggregation Optional. Specifies the aggregation method if applicable.
#' @param limit Number of records to return (default: 10000).
#' @param offset Offset in the records returned (default: 0).
#' @param token Your personal access token for authentication.
#'
#' @return A data frame containing the station timeseries data.
#' @export
#' @examples
#' \dontrun{
#'   download_station_timeseries(
#'     station_id = "1094.2",
#'     datatype = "rainfall",
#'     period = "month",
#'     fill = "partial",
#'     start_date = "1994-01-01",
#'     end_date = "1995-01-01",
#'     token = "YOUR_ACCESS_TOKEN"
#'   )
#' }
get_timeseries_st <- function(station_id, datatype, period, fill, start_date, end_date, token, 
                                        production = NULL, aggregation = NULL, limit = 10000, offset = 0) {
  # Load required libraries
  if (!requireNamespace("httr", quietly = TRUE)) install.packages("httr")
  if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")
  library(httr)
  library(jsonlite)

  # Construct the query parameter list
  query_list <- list(
    name = "hcdp_station_value",
    `value.station_id` = station_id,
    `value.datatype` = datatype,
    `value.period` = period,
    `value.fill` = fill
  )
  
  # Add optional parameters to the query if specified
  if (!is.null(production)) query_list$`value.production` <- production
  if (!is.null(aggregation)) query_list$`value.aggregation` <- aggregation

  # Construct the full query
  query_param <- list(
    `$and` = list(
      query_list,
      list(`value.date` = list(`$gte` = start_date)),
      list(`value.date` = list(`$lte` = end_date))
    )
  )

  # Convert query parameter to JSON and URL encode it
  encoded_query <- URLencode(toJSON(query_param, auto_unbox = TRUE))

  # Construct the full API URL
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
    # Parse the JSON response
    data <- content(response, "parsed", simplifyDataFrame = TRUE)
    return(data)
  } else {
    # Print error message if failed
    stop("Failed to retrieve data. Status code: ", status_code(response), "\nMessage: ", content(response, "text"))
  }
}
