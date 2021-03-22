### COVID-19 vaccine tracker
### Vaccine Centre, London School of Hygiene & Tropical Medicine
### Contact: Edward Parker, edward.parker@lshtm.ac.uk

### Implementation feature inputs

current_date = as.Date("2021-03-22")

### Figure --------------------------------------------------------------------

# load data
s = read.csv("input_data/VaC_LSHTM_landscape_summary.csv", stringsAsFactors = FALSE)

# set institute and platform factor levels
s$Institutes = factor(s$Institutes, levels = rev(s$Institutes))
s$Platform = factor(s$Platform, levels=c("RNA", "Vector (nr)", "Vector (r)", "Inactivated", "Live-attenuated", "Subunit", "VLP", "DNA", "Other"))

# convert input data into ggplot input dataframe (one row per record)
nvar = 7
nvac = nrow(s)
s1 = data.frame(
  Institutes = rep(as.character(s$Institutes), nvar),
  Platform = rep(s$Platform, nvar),
  Stage = c(rep("I", nvac), rep("II", nvac), rep("III", nvac), rep("I", nvac), rep("II", nvac), rep("III", nvac), rep(" ", nvac)),
  Group = c(rep("Registered trial", nvac*3), rep("Published", nvac*3), rep("In use", nvac)),
  Status = c(s$PhaseI_trial, s$PhaseII_trial, s$PhaseIII_trial, s$PhaseI_pub, s$PhaseII_pub, s$PhaseIII_pub, s$In_use)
)

# set group, platform, and institute factor levels
s1$Group = factor(s1$Group, levels=c("Registered trial", "Published", "In use"))
s1$Platform = factor(s1$Platform, levels=levels(s$Platform))
s1$Institutes = factor(s1$Institutes, levels = rev(as.character(s$Institutes)))

# convert 1s in dataframe to words corresponding to platform (enabling colour-coding in plots)
s1$Status[s1$Status==0] = NA
s1$Status[s1$Status==1 & s1$Platform=="RNA"] = "RNA"
s1$Status[s1$Status==1 & s1$Platform=="DNA"] = "DNA"
s1$Status[s1$Status==1 & s1$Platform=="Vector (nr)"] = "Vector (nr)"
s1$Status[s1$Status==1 & s1$Platform=="Vector (r)"] = "Vector (r)"
s1$Status[s1$Status==1 & s1$Platform=="Inactivated"] = "Inactivated"
s1$Status[s1$Status==1 & s1$Platform=="Live-attenuated"] = "Live-attenuated"
s1$Status[s1$Status==1 & s1$Platform=="Subunit"] = "Subunit"
s1$Status[s1$Status==1 & s1$Platform=="VLP"] = "VLP"
s1$Status[s1$Status==1 & s1$Platform=="Other"] = "Other"
s1$Status = factor(s1$Status, levels=c("RNA", "Vector (nr)", "Vector (r)", "Inactivated", "Live-attenuated", "Subunit", "VLP", "DNA", "Other"))

# create heatmap of registered and published trials (plot panel 1)
g1 = ggplot(subset(s1, !is.na(Status)), aes(Stage, Institutes, fill=factor(Status))) + theme_bw() +
  geom_tile(alpha = 0.9, colour="#f7f7f7", size=1) + 
  facet_grid(Platform~Group, scales = "free", space='free') +
  labs(fill = "Platform") + ylab("") + xlab("") + 
  scale_x_discrete(position = "top") + 
  scale_fill_manual(values = c("RNA" = pal_1[2], "DNA" = pal_2[2], "Vector (nr)" = pal_3[2], "Vector (r)" = pal_4[2], 
                               "Inactivated" = pal_5[2], "Live-attenuated" = pal_6[2], "Subunit" = pal_7[2], "VLP" = pal_8[2], "Other" = pal_9[2])) +
  theme(panel.background = element_rect(fill = "#f7f7f7",colour = "#f7f7f7", linetype = "blank"),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.border = element_blank(),
        text = element_text(size = 15), strip.background = element_blank(), strip.text.y = element_blank(), 
        strip.placement = "outside", legend.position = "bottom", legend.title = element_blank(),
        legend.text = element_text(size = 14), axis.text = element_text(size=15), strip.text = element_text(size=15))
  
# create plot of manufacture projections (plot panel 2)
g2 = ggplot(s, aes(as.numeric(Manufacture), Institutes, fill = Platform)) + 
  geom_bar(stat = "identity") + theme_bw() +
  scale_fill_manual(values = c("RNA" = pal_1[2], "DNA" = pal_2[2], "Vector (nr)" = pal_3[2], "Vector (r)" = pal_4[2], 
                               "Inactivated" = pal_5[2], "Live-attenuated" = pal_6[2], "Subunit" = pal_7[2], "VLP" = pal_8[2], "Other" = pal_9[2])) + 
  facet_grid(Platform~., scales = "free", space='free') + 
  ylab("") + xlab("") + ggtitle("N doses\navailable, 2021\n") + 
  scale_x_log10(limits=c(10^6,10^10), labels = trans_format("log10", math_format(10^.x)), oob = rescale_none) +
  theme(legend.position = "none", text = element_text(size = 15), axis.text.y = element_blank(), title = element_text(size = 12), 
        axis.text = element_text(size=15), 
        strip.background = element_blank(), strip.text.y = element_blank(), strip.placement = "outside",
        panel.border = element_blank(), panel.grid.major.y = element_blank(), panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(size = 0.5, linetype = 'solid', colour = "white"), 
        panel.background = element_rect(fill = "#f7f7f7",colour = "#f7f7f7", linetype = "blank"))
  

# import Our Wolrd in Data country reporting statistics
#owid = read.csv("input_data/owid_26Jan21.csv", stringsAsFactors = FALSE)
owid <- as.data.frame(data.table::fread("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/locations.csv"))
owid = subset(owid, iso_code!="")

#write.csv(owid, "owid.csv")
#unique(owid$vaccines)

# calculate N reporting countries reporting use for each vaccine candidate
s$n_country = NA
s$n_country[s$Institutes=="Bharat Covaxin/BBV152"] = sum(grepl("Covaxin", owid$vaccines))
s$n_country[s$Institutes=="BioNTech/Pfizer BNT162b2"] = sum(grepl("Pfizer/BioNTech", owid$vaccines))
s$n_country[s$Institutes=="Moderna mRNA-1273"] = sum(grepl("Moderna", owid$vaccines))
s$n_country[s$Institutes=="Gamaleya Gam-COVID-Vac/Sputnik V"] = sum(grepl("Sputnik V", owid$vaccines))
s$n_country[s$Institutes=="Beijing/Sinopharm BBIBP-CorV"] = sum(grepl("Sinopharm/Beijing", owid$vaccines))
s$n_country[s$Institutes=="Wuhan/Sinopharm vaccine"] = sum(grepl("Sinopharm/Wuhan", owid$vaccines))
s$n_country[s$Institutes=="Sinovac CoronaVac"] = sum(grepl("Sinovac", owid$vaccines))
s$n_country[s$Institutes=="Oxford/AstraZeneca ChAdOx1-S"] = sum(grepl("Oxford/AstraZeneca", owid$vaccines) | grepl("Covishield", owid$vaccines))
s$n_country[s$Institutes=="Janssen Ad26.COV2.S"] = sum(grepl("Johnson&Johnson", owid$vaccines))
s$n_country[s$Institutes=="Vector Institute EpiVacCorona"] = sum(grepl("EpiVacCorona", owid$vaccines))

# create plot of N countries reporting use (plot panel 3)
g3 = ggplot(s, aes(as.numeric(n_country), Institutes, fill = Platform, label = n_country)) + geom_bar(stat = "identity") + theme_bw() +
  scale_fill_manual(values = c("RNA" = pal_1[2], "DNA" = pal_2[2], "Vector (nr)" = pal_3[2], "Vector (r)" = pal_4[2], 
                               "Inactivated" = pal_5[2], "Live-attenuated" = pal_6[2], "Subunit" = pal_7[2], "VLP" = pal_8[2], "Other" = pal_9[2])) +  
  facet_grid(Platform~., scales = "free", space='free') + 
  geom_text(nudge_x = 10, nudge_y = 0.05, show.legend = FALSE, size=5) +
  ylab("") + xlab("") + ggtitle("N countries\nreporting use\n") + 
  scale_x_continuous(limits=c(0,100), breaks=c(0,50,100)) +
  theme(text = element_text(size = 15), axis.text = element_text(size=15), legend.position="none",
        axis.text.y = element_blank(), title = element_text(size = 12),
        strip.background = element_blank(), strip.text.y = element_blank(), strip.placement = "outside",
        panel.border = element_blank(), panel.grid.major.y = element_blank(), panel.grid.minor = element_blank(),
        panel.grid.major.x = element_line(size = 0.5, linetype = 'solid', colour = "white"), 
        panel.background = element_rect(fill = "#f7f7f7",colour = "#f7f7f7", linetype = "blank"))
  
# create multi-panel plot
summary_matrix = plot_grid(g1, g2, g3, align = "h", axis = "bt", rel_widths = c(4,1,1), ncol=3)

# pdf("myplot.pdf", width = 13.5, height = 10)
# print(summary_matrix)
# dev.off()

### Table --------------------------------------------------------------------

# load data
imp = read.csv("input_data/VAC_LSHTM_implementation.csv")
imp = subset(imp, Metric!="")
imp_list = as.character(unique(imp$Vaccine))

### Bubble plot --------------------------------------------------------------------

gdp = read.csv("input_data/equity_data.csv")
owid_vac <- as.data.frame(data.table::fread("https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.csv"))
owid_vac = subset(owid_vac, iso_code!="")
owid_vac$date = as.Date(owid_vac$date)
owid_vac = merge(owid_vac, owid[,c("iso_code", "vaccines")], by = "iso_code")
date = seq(as.Date("2021-01-01"), current_date, by="days")
country_list = unique(owid_vac$location) 

equity = NULL
for (i in 1:length(country_list)) {
  country_sub = data.frame(date = date)
  country_sub$location = country_list[i]
  owid_sub = subset(owid_vac, location==country_list[i])
  country_sub = merge(country_sub, owid_sub[,c("date", "total_vaccinations", "people_vaccinated", "people_fully_vaccinated",
                                               "total_vaccinations_per_hundred", "people_vaccinated_per_hundred", "people_fully_vaccinated_per_hundred")], by = "date", all.x = TRUE)
  # replace NAs with 0s  
  country_sub[is.na(country_sub)] = 0 
  # for each row use maximum value observed up until that point (i.e. replace 0s with rolling total)
  for (j in 1:nrow(country_sub)) {
    rows = country_sub[1:j,]
    country_sub$total_vaccinations[j] = max(rows$total_vaccinations) 
    country_sub$people_vaccinated[j] = max(rows$people_vaccinated) 
    country_sub$people_fully_vaccinated[j] = max(rows$people_fully_vaccinated) 
    country_sub$total_vaccinations_per_hundred[j] = max(rows$total_vaccinations_per_hundred) 
    country_sub$people_vaccinated_per_hundred[j] = max(rows$people_vaccinated_per_hundred) 
    country_sub$people_fully_vaccinated_per_hundred[j] = max(rows$people_fully_vaccinated_per_hundred) 
  }
  equity = rbind(equity, country_sub)
}
equity = merge(equity, owid[,c("location", "iso_code", "vaccines")], by = "location")
countries_sub = countries[!duplicated(countries$iso_code),]
equity = merge(equity, countries_sub[,c("iso_code", "latitude", "longitude", "population")], by = "iso_code", all.y=TRUE)
equity_full = merge(equity, gdp, by = "iso_code")

equity_slider = seq(as.Date("2021-01-01"), current_date, by="weeks")
if(max(equity_slider != current_date)) { equity_slider = c(equity_slider, current_date) }

# equity = equity_full
# equity$date[is.na(equity$date)] = current_date
# equity <- equity %>% filter(date == current_date
