## LSHTM Vaccine Centre COVID-19 vaccine tracker

This github page contains the code and input data for the [COVID-19 vaccine tracker](https://vac-lshtm.shinyapps.io/ncov_vaccine_landscape/) developed by the Vaccine Centre at the London School of Hygiene & Tropical Medicine.

The Shiny app, first launched in April 2020, follows candidates as they progress through the development pipeline.

## Analysis code

Key elements of the analysis code are as follows:
- *app.R* - an R script used to render the Shiny app. This consists of several plotting functions as well as the ui (user interface) and server code required to render the Shiny app. The script has become more complex over time as a growing number of interactive features has been added.
- *jhu_data_full.R* – an R script that extracts and reformats time-series data from the [Johns Hopkins Center for Systems Science and Engineering github page](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series). The output files are saved in the *input_data* folder.

- *input_data* - a folder containing dynamic input data relating to the evolving COVID-19 pandemic (updated by *jhu_data_full.R* and  *ny_data_us.R*) and static input data relating to past epidemics and country mapping coordinates.

## Sources and search strategy for each tracker feature

### Vaccine landscape
* Updated weekly
* File: *VaC_LSHTM_landscape.csv*
* Sources:
  - [WHO COVID-19 candidate vaccine landscape](https://www.who.int/publications/m/item/draft-landscape-of-covid-19-candidate-vaccines)
  - [Milken Institute COVID-19 vaccine tracker](https://www.covid-19vaccinetracker.org)
  - US National Institute of Health’s clinical trials database ([clinicaltrials.gov](https://clinicaltrials.gov))

### Clinical trials database
* Updated weekly
* File: *VaC_LSHTM_trials.csv*
* Sources:
  - US National Institute of Health’s clinical trials database ([clinicaltrials.gov](https://clinicaltrials.gov))
  - [WHO COVID-19 candidate vaccine landscape](https://www.who.int/publications/m/item/draft-landscape-of-covid-19-candidate-vaccines)

### Trial map
* Updated weekly
* File: *VaC_LSHTM_trials_map.csv* 
* Trial data are obtained from *VaC_LSHTM_trials.csv* (see above)
* Country-level case counts are obtained from the [Johns Hopkins Center for Systems Science and Engineering github page](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series) using the *jhu_data_daily_cases.R* script

### Living review
* Updated weekly
* Files: *VaC_search_log.csv*, *VaC_eligible_studies.csv*,  and *living_review_data_collection_tool.xlsx*
* Search term: *"(coronavirus OR COVID OR SARS*) AND vaccin* AND (trial OR phase)"*
* Approach:
  - A search of medRxiv and Pubmed is implemented via the *living_review.Rmd* script using the R packages *medrxivr* and *easyPubMed*
  - Titles and abstracts are screened for articles reporting outcome data from human trials of SARS-CoV-2 vaccines
  -  For eligible trials, descriptive and quantitative data on study design, participant characteristics, safety, immunogenicity, and/or efficacy are extracted by a single reviewer and verified by a second using the *living_review_data_collection_tool.xlsx*, adapted from the tool developed for a systematic review and meta-analysis by [Church et al, Lancet Infect Dis, 2019](https://www.thelancet.com/journals/laninf/article/PIIS1473-3099(18)30602-9/fulltext). 
  - **Safety**: We report all vaccine-related serious adverse events as well as non-serious adverse events with ≥25% prevalence in one or more study groups. 
  - **Immunogenicity**: We report  pre- and post-vaccination levels of antigen-specific IgG (ELISA), neutralising antibody levels against live SARS-CoV-2 and/or pseudoviruses, and/or T-cell responses. We present antibody and T-cell outcomes 28 days post-vaccination or the nearest available timepoint.
  - **Efficacy**: We report protective efficacy against COVID-19, severe COVID-19, and/or asymptomatic SARS-CoV-2 infection. Where available, we present the profile (age, ethnicity, and comorbidity prevalence) of the study population, as well as vaccine efficacy estimates stratified by relevant covariates (dose regimen, age group, ethnicity, and presence of comorbidities).

### Implementation tab
* Updated weekly
* File: *VAC_implementation.csv*
* Sources:
  - Number of countries reporting use of each vaccine obtained from [Our World in Data](https://ourworldindata.org/covid-vaccinations)
  - Number enrolled in registered trials obtained from *VaC_LSHTM_trials.csv*
  - Dosing, description, and efficacy data obtained from *living_review_data_collection_tool.xlsx*. Where interim efficacy estimates have been in press releases but there is no published manuscript, hyperlinks links to the relevant press releases are provided.
  - Vaccine Access Test scores obtained from [ONE](https://www.one.org/international/vaccine-access-test/)
  - Manufacture projections obtained from  Access Test scores obtained from [ONE](https://www.one.org/international/vaccine-access-test/)

## Contact
vaccines@lshtm.ac.uk