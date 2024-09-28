20240926

# Description
HCDPDownloader is a R package for downloading the climate data (e.g., rainfall and temperature) in Hawaiʻi from Hawaiʻi Climate Data Portal ([HCDP](https://www.hawaii.edu/climate-data-portal/)) using its [API](https://docs.google.com/document/d/1XlVR6S6aCb7WC4ntC4QaRzdw0i6B-wDahDjsN1z7ECk/edit#heading=h.1ocj20xm1h5n)

# Available function  
### Open to public
`get_file()`: download monthly or daily rainfall data as original file for all stations in Hawaiʻi.

### API TOKEN needed (apply the token from [here](https://www.hawaii.edu/climate-data-portal/hcdp-hawaii-mesonet-api/))  

`get_metadata_st()`: download metadata for all stations.  
`get_timeseries_st()`: download a timeseires of station data.  
`get_raster()`: download rainfall raster file.  
`get_timeseries_raster()`: download a timeseries of raster data (e.g., rainfall or temperature) for a specified location and date range.

# Installation
`devtools::install_github("yfhuang7/HCDPDownloader")`

# Citation
Depends on the data you download, please look for the corresponding data citation in this [page](https://www.hawaii.edu/climate-data-portal/how-to-cite-3/)

# Licence
MIT 

