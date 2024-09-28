#' Download Raster Timeseries Data from the HCDP API
#'
#' This function queries the HCDP API to retrieve a timeseries of raster data (e.g., rainfall or temperature) 
#' for a specified location and date range.
#'
#' @param start Start date for the timeseries (format: "YYYY-MM").
#' @param end End date for the timeseries (format: "YYYY-MM").
#' @param datatype The type of data to retrieve (e.g., "rainfall" or "temperature").
#' @param extent The spatial extent of the raster (e.g., "bi", "statewide").
#' @param row Optional. The row index for the grid cell to produce a timeseries.
#' @param col Optional. The column index for the grid cell to produce a timeseries.
#' @param index Optional. The 1D index of the value to produce a timeseries (width * row + col).
#' @param lat Optional. Latitude of the location to produce a timeseries.
#' @param lon Optional. Longitude of the location to produce a timeseries.
#' @param production Optional. Specifies data production type if required (e.g., "new").
#' @param period Optional. Specifies the period of data (e.g., "month", "day").
#' @param token Your personal access token for authentication.
#'
#' @return A data frame containing datetime-value pairs for the specified timeseries.
#' @export
#' @examples
#' \dontrun{
#'   get_timeseries_raster(
#'     start = "2020-01",
#'     end = "2023-06",
#'     datatype = "rainfall",
#'     extent = "statewide",
#'     lat = 21.539576,
#'     lon = -157.965820,
#'     production = "new",
#'     period = "month",
#'     token = "YOUR_ACCESS_TOKEN"
#'   )
#' }
get_timeseries_raster <- function(start, end, datatype, extent, row = NULL, col = NULL, index = NULL, lat = NULL, lon = NULL, production = NULL, period = NULL, token) {
  # Load required libraries
  if (!requireNamespace("httr", quietly = TRUE)) install.packages("httr")
  if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")
  library(httr)
  library(jsonlite)

  # Construct the query parameters
  query_params <- list(
    start = start,
    end = end,
    datatype = datatype,
    extent = extent
  )

  # Add optional parameters to the query if specified
  if (!is.null(production)) query_params$production <- production
  if (!is.null(period)) query_params$period <- period
  if (!is.null(index)) {
    query_params$index <- index
  } else if (!is.null(row) && !is.null(col)) {
    query_params$row <- row
    query_params$col <- col
  } else if (!is.null(lat) && !is.null(lng)) {
    query_params$lat <- lat
    query_params$lng <- lng
  } else {
    stop("You must specify either `row` and `col`, `index`, or `lat` and `lng` for location.")
  }

  # Construct the API URL with query parameters
  base_url <- "https://api.hcdp.ikewai.org/raster/timeseries"
  full_url <- modify_url(base_url, query = query_params)

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

    # Convert to a data frame with datetime and value columns
    if (!is.null(data) && "timeseries" %in% names(data)) {
      timeseries_df <- as.data.frame(data$timeseries)
      colnames(timeseries_df) <- c("datetime", "value")
      return(timeseries_df)
    } else {
      warning("No timeseries data found in the response.")
      return(data)
    }
  } else {
    # Print error message if failed
    stop("Failed to retrieve data. Status code: ", status_code(response), "\nMessage: ", content(response, "text"))
  }
}
