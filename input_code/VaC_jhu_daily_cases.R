### COVID-19 vaccine tracker
### Vaccine Centre, London School of Hygiene & Tropical Medicine
### Contact: Edward Parker, edward.parker@lshtm.ac.uk

### Coronavirus case counts for mapping feature 
# Code originally developed by E Parker and Q Leclerc for LSHTM case mapper (https://vac-lshtm.shinyapps.io/ncov_tracker/)
# Full code available on Github: https://github.com/eparker12/nCoV_tracker

## Covid-2019 interactive mapping tool: script to reformat JHU data from scratch
## Edward Parker and Quentic Leclerc, London School of Hygiene & Tropical Medicine, March 2019

# function to update jhu input data according to mapping base format
update_jhu = function(input_df, tag) {
  names(input_df)[1:2] = c("Province", "Country")
  input_df$Country[input_df$Province=="Hong Kong"] = "Hong Kong"
  input_df$Country[input_df$Province=="Macau"] = "Macao"
  input_df$Country[input_df$Country=="Taiwan*"] = "Taiwan"
  input_df$Country[input_df$Country=="Korea, South"] = "RepublicofKorea"
  input_df$Country[input_df$Country=="Congo (Brazzaville)" | input_df$Country=="Republic of the Congo"] = "Congo"
  input_df$Country[input_df$Country=="Congo (Kinshasa)"] = "Democratic Republic of the Congo"
  input_df$Country[input_df$Country=="Cote d'Ivoire"] = "CotedIvoire"
  input_df$Country[input_df$Country=="Gambia, The"] = "TheGambia"
  input_df$Country[input_df$Country=="Bahamas, The"] = "TheBahamas"
  input_df$Country[input_df$Country=="Cabo Verde"] = "CapeVerde"
  input_df$Country[input_df$Country=="Timor-Leste"] = "TimorLeste"
  input_df$Country[input_df$Country=="Guinea-Bissau"] = "GuineaBissau"
  input_df$Country = input_df$Country %>% str_replace_all(., " ", "") 
  dates = names(input_df)[which(names(input_df)=="1/22/20"):ncol(input_df)]
  input_df = input_df %>% 
    select(-c(Province, Lat, Long)) %>% 
    group_by(Country) %>% 
    summarise_each(funs(sum)) %>%
    data.frame()
  rownames(input_df) = input_df$Country
  rownames(input_df) = paste0(input_df$Country,"_",tag)
  input_df = input_df %>% select(-c(Country)) %>% t()
  input_df = data.frame(input_df)
  input_df$Date = dates
  rownames(input_df) = 1:nrow(input_df)
  input_df$Date = format(as.Date(input_df$Date,"%m/%d/%y"))
  input_df
}

# import latest Covid-2019 data: confirmed cases
jhu_cases <- as.data.frame(data.table::fread("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"))
jhu_cases = subset(jhu_cases, !is.na(Lat))
jhu_cases[is.na(jhu_cases)]=0
total_cases <- sum(jhu_cases[,ncol(jhu_cases)])
jhu_cases = update_jhu(jhu_cases, "cases")
if (total_cases!=sum(jhu_cases[nrow(jhu_cases),1:(ncol(jhu_cases)-1)])) { stop(paste0("Error: incorrect processing - total counts do not match")) }

# set date format
jhu_cases$Date = as.Date(jhu_cases$Date, format="%Y-%m-%d")
jhu_cases$update = 1:nrow(jhu_cases)

# load country data
countries = read.csv("input_data/countries_codes_and_coordinates.csv")

# check all jhu country names have corresponding country data
jhu_country_list = names(jhu_cases)[grepl("_cases", names(jhu_cases))] %>% str_replace_all(., "_cases", "") 
if (all(jhu_country_list %in% countries$jhu_ID)==FALSE) {
  stop(paste0("Error: mapping data lacking for the following countries: ",jhu_country_list[(jhu_country_list %in% countries$jhu_ID)==FALSE]))
}

# loop to add new data for each new situation report
collated_data = NULL
for (i in c(1:nrow(jhu_cases))) {
  
  # extract subset of data for date in row i
  jhu_subset = jhu_cases[i,]
  jhu_subset_cases = jhu_subset[,which(grepl("_cases", names(jhu_subset)))]
  jhu_subset_cases = jhu_subset_cases[,colSums(jhu_subset_cases)>0]

  # build new dataframe to add updated data
  new_data = data.frame(jhu_ID = names(jhu_subset_cases) %>% str_replace_all(., "_cases", ""),
                        date = format(as.Date(jhu_subset$Date[1],"%Y-%m-%d")),
                        update = i,
                        cases = NA, new_cases = 0)
  
  # update column names in new_jhu dataframes to include country names only
  colnames(jhu_subset_cases) = colnames(jhu_subset_cases) %>% str_replace_all(., "_cases", "") 

  # loop to update cases
  for (j in 1:nrow(new_data)) {
    # update case numbers
    country_name = as.character(new_data$jhu_ID[j])
    new_data$cases[j] = jhu_subset_cases[,country_name]
  }
  
  # append new data to collated dataframe
  collated_data = rbind(collated_data, new_data)
  collated_data$jhu_ID = as.character(collated_data$jhu_ID)
  
  # calculate new cases
  if (i == 1) {
    collated_data$new_cases = collated_data$cases
  }
  
  if (i > 1) {
    # split it into date i and date i-1
    today = subset(collated_data, update==i)
    yesterday = subset(collated_data, update==(i-1))
    
    for (k in 1:nrow(today)) {
      country_name = today$jhu_ID[k]
      
      # if present in yesterday's data, calculate new cases by subtraction
      if (country_name %in% yesterday$jhu_ID) {
        collated_data$new_cases[collated_data$jhu_ID==country_name & collated_data$update==i] = today$cases[today$jhu_ID==country_name] - yesterday$cases[yesterday$jhu_ID==country_name] 
      } else {
        # if absent from yesterday's data, new observations = total observations
        collated_data$new_cases[collated_data$jhu_ID==country_name & collated_data$update==i] = today$cases[today$jhu_ID==country_name] 
      }
    }
  }
}

# allow for repatriation or reassigned cases without negative new_cases counts
collated_data$new_cases[collated_data$new_cases<0] = 0

# update country names
collated_data = merge(collated_data, countries[,c("jhu_ID", "country")], by = "jhu_ID")

# re-order
collated_data = collated_data[order(as.Date(collated_data$date, format="%Y-%m-%d"), -collated_data$cases, collated_data$country),]

# add rolling 7-day average for new cases
collated_data$new_cases_rolling7 = NA
country_list = unique(collated_data$jhu_ID)

for (i in 1:length(country_list)) {
  country_sub = subset(collated_data, jhu_ID==country_list[i])
  
  # add rolling 7-day average from 7th day onwards
  if (nrow(country_sub)>=7) {
    for (j in 7:nrow(country_sub)) {
      country_sub$new_cases_rolling7[j] = round(mean(country_sub[(j-6):j,"new_cases"]),0)
    }
  }
  
  # integrate with parent dataframe
  collated_data$new_cases_rolling7[collated_data$jhu_ID==country_list[i]] = country_sub$new_cases_rolling7
}

# save file
write.csv(collated_data, "input_data/VaC_map_daily_cases.csv", row.names=F)
rm(list = ls())
