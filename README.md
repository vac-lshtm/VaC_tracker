## LSHTM Vaccine Centre COVID-19 vaccine tracker

This github page contains the code and input data for the [COVID-19 vaccine tracker](https://vac-lshtm.shinyapps.io/ncov_vaccine_landscape/) developed by the Vaccine Centre at the London School of Hygiene & Tropical Medicine.

The Shiny app, first launched in April 2020, follows candidates as they progress through the development pipeline.

## Analysis code

Key elements of the analysis code are as follows:
- *app.R* - an R script used to render the Shiny app. This consists of code for the ui (user interface) and server. The script has become more complex over time as a growing number of interactive features has been added.
- *input_data* - a folder containing input data for the tracker. Different datasets serve as input for different features of the tracker, as detailed below.
- *input_code* - a folder containing code to generate the outputs for each feature of the tracker. See details below.
- *living_review* - a folder containing input code and outputs for living systematic review.


## Sources and search strategy for each tracker feature

### Vaccine landscape
* Updated weekly from April 2020 to August 2021, then monthly thereafter
* Input data: *VaC_LSHTM_landscape.csv* and *VaC_LSHTM_trials.csv*
* Input code: *VaC_landscape.R*
* Sources:
  - [WHO COVID-19 candidate vaccine landscape](https://www.who.int/publications/m/item/draft-landscape-of-covid-19-candidate-vaccines)
  - [Milken Institute COVID-19 vaccine tracker](https://www.covid-19vaccinetracker.org)
  - US National Institute of Health’s clinical trials database ([clinicaltrials.gov](https://clinicaltrials.gov))

### Clinical trials database
* Updated weekly from April 2020 to August 2021, then monthly thereafter
* Input data: *VaC_LSHTM_trials.csv*
* Sources:
  - US National Institute of Health’s clinical trials database ([clinicaltrials.gov](https://clinicaltrials.gov))
  - [WHO COVID-19 candidate vaccine landscape](https://www.who.int/publications/m/item/draft-landscape-of-covid-19-candidate-vaccines)

### Trial map
* Updated weekly from April 2020 to August 2021, then monthly thereafter
* Input data: 
  - Trial data: *VaC_LSHTM_trials_map.csv* - data from *VaC_LSHTM_trials.csv* serve as input for this (see above)
  - Mapping data: *countries_codes_and_coordinates.csv*, *country_geoms.csv*, and *50m.geojson*
  - Country-level case counts: *VaC_map_daily_cases.csv* - obtained from [Johns Hopkins Center for Systems Science and Engineering github page](https://github.com/CSSEGISandData/COVID-19/tree/master/csse_covid_19_data/csse_covid_19_time_series)
* Input code: *VaC_efficacy_map.R* and *VaC_jhu_daily_cases.R*

### Living review
* Updated weekly from April 2020 to August 2021, then monthly thereafter
* Input data: *VaC_LSHTM_search_log.csv*, *VaC_LSHTM_eligible_studies.csv*,  and *VaC_LSHTM_living_review_data.xlsx*
* Search term: *"(coronavirus OR COVID OR SARS\*) AND vaccin\* AND (trial OR phase)"*
* Approach:
  - A search of medRxiv and Pubmed is implemented via the *VaC_LSHTM_living_review.Rmd* script (in the *living_review* folder) using the R packages *medrxivr* and *easyPubMed*
  - Titles and abstracts are screened for articles reporting outcome data from human trials of SARS-CoV-2 vaccines
  -  For eligible trials, descriptive and quantitative data on study design, participant characteristics, safety, immunogenicity, and/or efficacy are extracted by a single reviewer and verified by a second using the *VaC_LSHTM_living_review_data.xlsx*, adapted from the tool developed for a systematic review and meta-analysis by [Church et al, Lancet Infect Dis, 2019](https://www.thelancet.com/journals/laninf/article/PIIS1473-3099(18)30602-9/fulltext). 
  - **Safety**: We report all vaccine-related serious adverse events as well as non-serious adverse events with ≥25% prevalence in one or more study groups. 
  - **Immunogenicity**: We report  pre- and post-vaccination levels of antigen-specific IgG (ELISA), neutralising antibody levels against live SARS-CoV-2 and/or pseudoviruses, and/or T-cell responses. We present antibody and T-cell outcomes 28 days post-vaccination or the nearest available timepoint.
  - **Efficacy**: We report protective efficacy against COVID-19, severe COVID-19, and/or asymptomatic SARS-CoV-2 infection. Where available, we present the profile (age, ethnicity, and comorbidity prevalence) of the study population, as well as vaccine efficacy estimates stratified by relevant covariates (dose regimen, age group, ethnicity, and presence of comorbidities).

### Implementation tab
* Roll-out data updated multiple times weekly; Vaccine Access Test scores and manufacture projections updated every 3-4 weeks
* Input data: *VAC_implementation.csv* and *VaC_LSHTM_landscape_summary.csv*
* Sources:
  - Vaccine roll-out data obtained from [Our World in Data](https://ourworldindata.org/covid-vaccinations)
  - Country income data obtained from [Gapminder](https://www.gapminder.org/tools/) and [World Bank](https://data.worldbank.org)
  - Dosing, description, and efficacy data obtained from *VaC_LSHTM_living_review_data.xlsx*. Where interim efficacy estimates have been in press releases but there is no published manuscript, hyperlinks are provided.
  - Vaccine Access Test scores obtained from [ONE](https://www.one.org/international/vaccine-access-test/)
  - Manufacture projections obtained from company websites. If unavailable, we report projections stated by a company spokesperson in the mainstream media where available and provide relevant hyperlinks.

## Contact
vaccines@lshtm.ac.uk
