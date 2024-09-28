20240926

# Description
HCDPDownloader is a R package for downloading the climate data (e.g., rainfall and temperature) in Hawaiʻi from Hawaiʻi Climate Data Portal ([HCDP](https://www.hawaii.edu/climate-data-portal/)) using its [API](https://docs.google.com/document/d/1XlVR6S6aCb7WC4ntC4QaRzdw0i6B-wDahDjsN1z7ECk/edit#heading=h.1ocj20xm1h5n)

# Available function
`get_file()`: download monthly or daily rainfall data as original file for all stations in Hawaiʻi.

API TOKEN needed (apply the token from [here](https://www.hawaii.edu/climate-data-portal/hcdp-hawaii-mesonet-api/))  

`get_timeseries()`: download monthly or daily rainfall or temperature time series data.  
`get_raster()`: download rainfall raster file.

# Installation
`devtools::install_github("yfhuang7/HCDPDownloader")`

# Licence
MIT 

