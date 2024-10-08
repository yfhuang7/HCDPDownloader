% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_raster.R
\name{get_raster}
\alias{get_raster}
\title{Download Raster Data (GeoTIFF) from the HCDP API}
\usage{
get_raster(
  date,
  extent,
  datatype,
  production = NULL,
  period = NULL,
  returnEmptyNotFound = FALSE,
  token,
  output_path = getwd()
)
}
\arguments{
\item{date}{An ISO-8601 formatted date string indicating the date of the data map to retrieve (e.g., "2022-02").}

\item{extent}{The spatial extent of the raster (e.g., "bi", "statewide").}

\item{datatype}{The type of data to retrieve (e.g., "rainfall" or "temperature").}

\item{production}{Optional. Specifies data production type if required (e.g., "new").}

\item{period}{Optional. Specifies the period of data (e.g., "month", "day").}

\item{returnEmptyNotFound}{Boolean indicating whether to return an empty GeoTIFF if the requested file is not found. If \code{FALSE}, returns 404 if not found.}

\item{token}{Your personal access token for authentication.}

\item{output_path}{Path to the folder where the GeoTIFF file will be saved (default: current working directory).}
}
\value{
A message indicating the success or failure of the file download.
}
\description{
This function queries the HCDP API to retrieve a raster GeoTIFF file for a specified date, datatype, and extent.
}
\examples{
\dontrun{
  get_raster(
    date = "2022-02",
    extent = "bi",
    datatype = "rainfall",
    production = "new",
    period = "month",
    token = "YOUR_ACCESS_TOKEN",
    output_path = "~/Downloads"
  )
}
}
