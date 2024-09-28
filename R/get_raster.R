#' Download Raster Data (GeoTIFF) from the HCDP API
#'
#' This function queries the HCDP API to retrieve a raster GeoTIFF file for a specified date, datatype, and extent.
#'
#' @param date An ISO-8601 formatted date string indicating the date of the data map to retrieve (e.g., "2022-02").
#' @param extent The spatial extent of the raster (e.g., "bi", "statewide").
#' @param datatype The type of data to retrieve (e.g., "rainfall" or "temperature").
#' @param production Optional. Specifies data production type if required (e.g., "new").
#' @param period Optional. Specifies the period of data (e.g., "month", "day").
#' @param returnEmptyNotFound Boolean indicating whether to return an empty GeoTIFF if the requested file is not found. If `FALSE`, returns 404 if not found.
#' @param token Your personal access token for authentication.
#' @param output_path Path to the folder where the GeoTIFF file will be saved (default: current working directory).
#'
#' @return A message indicating the success or failure of the file download. Geotiff file saved in outdir.
#' @export
#' @examples
#' \dontrun{
#'   get_raster(
#'     date = "2022-02",
#'     extent = "bi",
#'     datatype = "rainfall",
#'     production = "new",
#'     period = "month",
#'     token = "YOUR_ACCESS_TOKEN",
#'     output_path = "~/Downloads"
#'   )
#' }
get_raster <- function(date, extent, datatype, production = NULL, period = NULL, returnEmptyNotFound = FALSE, token, output_path = getwd()) {
  # Load required libraries
  if (!requireNamespace("httr", quietly = TRUE)) install.packages("httr")
  if (!requireNamespace("jsonlite", quietly = TRUE)) install.packages("jsonlite")
  library(httr)

  # Construct the query parameters
  query_params <- list(
    date = date,
    extent = extent,
    datatype = datatype,
    returnEmptyNotFound = tolower(as.character(returnEmptyNotFound))
  )

  # Add optional parameters to the query if specified
  if (!is.null(production)) query_params$production <- production
  if (!is.null(period)) query_params$period <- period

  # Construct the API URL with query parameters
  base_url <- "https://api.hcdp.ikewai.org/raster"
  full_url <- modify_url(base_url, query = query_params)

  # Construct the file path for saving the GeoTIFF file
  output_filename <- paste0("raster_", datatype, "_", date, "_", extent, ".tif")
  file_path <- file.path(output_path, output_filename)

  # Make the GET request using httr
  response <- GET(
    url = full_url,
    add_headers(Authorization = paste("Bearer", token)),
    write_disk(file_path, overwrite = TRUE)
  )

  # Check if the download was successful
  if (status_code(response) == 200) {
    message("File downloaded successfully: ", file_path)
    return(file_path)
  } else {
    # Handle errors based on the returnEmptyNotFound parameter
    if (status_code(response) == 404 && !returnEmptyNotFound) {
      stop("Requested file not found. Status code: 404.")
    } else {
      stop("Failed to retrieve data. Status code: ", status_code(response), "\nMessage: ", content(response, "text"))
    }
  }
}
