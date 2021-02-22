### COVID-19 vaccine tracker
### Vaccine Centre, London School of Hygiene & Tropical Medicine
### Contact: Edward Parker, edward.parker@lshtm.ac.uk

### Efficacy map feature inputs



# set mapping colours
covid_col = "#cc4c02"
active_col = "#7a0177"
planned_col = "#74a9cf"

# import trial data
trials = read.csv("input_data/VaC_LSHTM_trials_map.csv")
trials = subset(trials, Developers!="")

# import case data
cv_cases = read.csv("input_data/VaC_LSHTM_map_daily_cases.csv")

# import mapping data
countries = read.csv("input_data/countries_codes_and_coordinates.csv")
countries$iso_code = as.character(countries$alpha3)
worldcountry = geojson_read("input_data/50m.geojson", what = "sp")
country_geoms = read.csv("input_data/country_geoms.csv")

# check consistency of country names across datasets
if (all(unique(cv_cases$country) %in% unique(countries$country))==FALSE) { print("Error: inconsistent country names")}

# merge case data with country data and extract key summary variables
cv_cases = merge(cv_cases, countries, by = "country")

# set format for date column and sort by increasing date
if (any(grepl("/", cv_cases$date))) { 
  cv_cases$date = format(as.Date(cv_cases$date, format="%d/%m/%Y"),"%Y-%m-%d") 
} else { cv_cases$date = as.Date(cv_cases$date, format="%Y-%m-%d") }
cv_cases$date = as.Date(cv_cases$date)
cv_cases = cv_cases[order(cv_cases$date),]
cv_cases$date = as.Date(cv_cases$date)

# calculate rolling average per million
cv_cases$rolling7permill = as.numeric(format(round(cv_cases$new_cases_rolling7/(cv_cases$population/1e6),1),nsmall=1))

# create subset of data for first trial (selected when map first loaded)
trial_layer = subset(trials, Vaccine==trials$Vaccine[1])
#trial_layer = subset(trials, Vaccine=="Janssen Ad26.COV2.S")

# create paramters for active trials layer
recruiting_countries = subset(trial_layer, Location_status=="Active/recruiting")
recruiting_countries = recruiting_countries[order(recruiting_countries$alpha3),]
plot_map_layer_1 <- worldcountry[worldcountry$ADM0_A3 %in% recruiting_countries$alpha3[1], ]
if (nrow(recruiting_countries)>1) {
  for (i in 2:nrow(recruiting_countries)) {
    plot_map_layer_1 = rbind(plot_map_layer_1, worldcountry[worldcountry$ADM0_A3 %in% recruiting_countries$alpha3[i], ])
  }
}

# create paramters for planned trials layer
pending_countries = subset(trial_layer, Location_status=="Not yet recruiting")
pending_countries = pending_countries[order(pending_countries$alpha3),]
plot_map_layer_2 <- worldcountry[worldcountry$ADM0_A3 %in% pending_countries$alpha3[1], ]
if (nrow(pending_countries)>1) {
  for (i in 2:nrow(pending_countries)) {
    plot_map_layer_2 = rbind(plot_map_layer_2, worldcountry[worldcountry$ADM0_A3 %in% pending_countries$alpha3[i], ])
  }
}

# create palette for trial status
status_pal <- colorFactor(c(active_col, planned_col), domain = c("Active/recruiting", "Not yet recruiting"))

# creat base map (subsequently updated by user selections)
basemap = leaflet(plot_map_layer_1) %>% 
  addTiles() %>% 
  addProviderTiles(providers$CartoDB.Positron) %>%
  fitBounds(~-100,-60,~60,70) %>%
  addLegend("bottomright", pal = status_pal, values = c("Not yet recruiting", "Active/recruiting"),
            title = "Status")  %>% 
  # add polygons for first trial (all active)
  addPolygons(data = plot_map_layer_1, smoothFactor = 0.1, fillOpacity = 0.2, fillColor = active_col, 
            group = 'Active/recruiting', weight = 1, color = active_col, 
            label = sprintf("<strong>%s: </strong><i>%s</i>", recruiting_countries$Location, recruiting_countries$Location_status) %>% lapply(htmltools::HTML),
            labelOptions = labelOptions(
              style = list("font-weight" = "normal", padding = "3px 8px", "color" = active_col),
              textsize = "15px", direction = "auto")) %>%
  # add circle markers for all recruiting countries
  addCircleMarkers(data = recruiting_countries, lat = ~ Latitude, lng = ~ Longitude, weight = 1,
            fillOpacity = 0.5, color = active_col, 
            label = sprintf("<strong>%s: </strong><i>%s</i>", recruiting_countries$Location, recruiting_countries$Location_status) %>% lapply(htmltools::HTML),
            labelOptions = labelOptions(
              style = list("font-weight" = "normal", padding = "3px 8px", "color" = active_col),
              textsize = "15px", direction = "auto")) %>%
  # add circle markers for selected country (first row when initially loaded)
  addCircleMarkers(data = trial_layer[1,], lat = ~ Latitude, lng = ~ Longitude, weight = 1,
            fillOpacity = 1, color = ~status_pal(Location_status),
            label = sprintf("<strong>%s: </strong><i>%s</i>", trial_layer$Location[1], trial_layer$Location_status[1]) %>% lapply(htmltools::HTML),
            labelOptions = labelOptions(
              style = list("font-weight" = "normal", padding = "3px 8px", "color" = ~status_pal(Location_status)),
              textsize = "15px", direction = "auto"))

