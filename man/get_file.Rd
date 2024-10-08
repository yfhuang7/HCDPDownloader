% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_file.R
\name{get_file}
\alias{get_file}
\title{Download HCDP Rainfall Data (Station)}
\usage{
get_file(
  year,
  month = NULL,
  fill = "partial",
  period = "month",
  extent = "statewide",
  outdir = "~/Downloads"
)
}
\arguments{
\item{year}{Year of the data (e.g., 2020).}

\item{month}{Month of the data (e.g., "03" for March) # if provided, download daily data for the month}

\item{fill}{Optional. Used for DAILY station data, such as "partial" or "raw".
Defaults to "partial". raw: Unfilled data that has not undergone QA/QC.
partial: Partially filled data that has undergone QA/QC and had statistical methods applied to it to estimate some missing values}

\item{period}{The period of data (default: "month"). Use "day" for daily data.}

\item{extent}{The geographical extent of the data (default: "statewide").}
}
\value{
The file name of the downloaded file.
}
\description{
This function downloads HCDP monthly/daily rainfall data for a specified year/month.
Currently function only can apply on one file at a time.
}
\examples{
# Download daily rainfall for March 2020 to the outdir
get_file(year = 2020, month = 8, outdir="~/Downloads")
# Download monthly rainfall for 2020 to the outdir
get_file(year = 2020, outdir="~/Downloads")

20240925 Yu-Fen Huang

}
