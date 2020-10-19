# COVID19_longitudinalsampling
Public repository of data and code from SARS-CoV-2 surface sampling in MA
This is code to replicate Figure 2

Files:
analysis.R
This contains all of the code for analysis, and requires the package dplyr

sample_quantities.RDS
This contains the list of all samples collected in this study, and the number of replicates in qPCR that tested positive (out of a maximum of 3) for each assay: N1 and E, testing for SARS-CoV-2, and BCoV, testing for the internal standard of bovine coronavirus. If a replicate tested positive for either E or N1, the sample is considered positive.

covid_cases_wholecity.RDS
This contains a list of new COVID-19 cases in the entire city of Somerville, MA from March-July, 2020, broken into probable, confirmed, and total cases

covid_cases_zip.RDS
This contains a list of new COVID-19 cases in the zip code specific to sampling, from March-July, 2020, broken into probable, confirmed, and total cases
