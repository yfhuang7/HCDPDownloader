#' Download HCDP Rainfall Data (Station)
#'
#' This function downloads HCDP rainfall data for a specified year, month, and optional day.
#'
#' @param year Year of the data (e.g., 2020).
#' @param month Month of the data (e.g., "03" for March) # if provided, download daily data for the month
#' @param fill Optional. Used for DAILY station data, such as "partial" or "raw". Defaults to "partial". raw: Unfilled data that has not undergone QA/QC. partial: Partially filled data that has undergone QA/QC and had statistical methods applied to it to estimate some missing values
#' @param period The period of data (default: "month"). Use "day" for daily data.
#' @param extent The geographical extent of the data (default: "statewide").
#'
#' @return The file name of the downloaded file.
#' @export
#' @examples
#' # Download daily rainfall for March 2020 to the outdir
#' get_hcdp_rainfall(year = 2020, month = 8, outdir="~/Downloads")
#' # Download monthly rainfall for 2020 to the outdir
#' get_hcdp_rainfall(year = 2020, outdir="~/Downloads")
#'
get_hcdp_rainfall <- function(year, month = NULL, fill = "partial", period = "month", extent = "statewide", outdir = "~/Downloads") {

  # Base URL for HCDP station data
  base_url <- "https://ikeauth.its.hawaii.edu/files/v2/download/public/system/ikewai-annotated-data/HCDP/production/rainfall/new"

  # Construct the URL for monthly or daily station data
  if (!is.null(month)) {
    period <- "day"
    month <- sprintf("%02d", month)  # Format month with leading zeros
    url <- paste0(base_url, "/", period, "/", extent, "/", fill, "/station_data/", year, "/", month, "/" , "/rainfall_new_", period, "_", extent, "_", fill, "_station_data_", year, "_", month,".csv")

    # Set the output filename
    file_name <- paste0(outdir, "/HCDP_station_rainfall_daily_", year, "_", month, ".csv")
  } else {
    url <- paste0(base_url, "/", period, "/", extent, "/", "partial/station_data/", year,
                  "/rainfall_new_", period, "_", extent, "_", "partial_station_data_", year, ".csv")

    # Set the output filename
    file_name <- paste0(outdir, "HCDP_station_rainfall_monthly", year, ".csv")
  }

  # Download the file using httr::GET
  response <- httr::GET(url, httr::write_disk(file_name, overwrite = TRUE))

  # Check if the download was successful
  if (httr::status_code(response) == 200) {
    message("File downloaded successfully: ", file_name)
    return(invisible(file_name))
  } else {
    stop("Failed to download the file. Status code: ", httr::status_code(response))
  }
}
