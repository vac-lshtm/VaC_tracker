### COVID-19 vaccine tracker
### Vaccine Centre, London School of Hygiene & Tropical Medicine
### Contact: Edward Parker, edward.parker@lshtm.ac.uk

### Landscape feature inputs



### Timeline --------------------------------------------------------------------

# load input data
landscape = read.csv("input_data/VaC_LSHTM_landscape.csv", stringsAsFactors = FALSE)
trials = read.csv("input_data/VaC_LSHTM_trials.csv",  stringsAsFactors = FALSE)

# combine other/unknown platforms
landscape$Platform[landscape$Platform=="Other" | landscape$Platform=="Unknown"] = "Other/Unknown"

# create timeline input dataframe
timeline_preclinical = data.frame(group = landscape$Institutes %>% str_replace_all(., "/", "<br>"),
                                  subgroup = landscape$Platform,
                                  content = paste0("<b>",landscape$Name,"</b><br>Pre-clinical development"),
                                  start = landscape$Date.started, end = NA,
                                  stage = landscape$Phase, 
                                  use = landscape$In.use)
timeline_clinical = data.frame(group = trials$Institutes %>% str_replace_all(., "/", "<br>"),
                               subgroup = trials$Platform,
                               content = paste0("<b>",trials$Name,"</b><br>",trials$Phase,", ",trials$Location, " <i>(", trials$Status,")</i><br>",
                                                '<a href="',trials$Link,'" target="_blank">',trials$Trial.number,"</a>"),
                               start = trials$Start.date, end = trials$Primary.completion.date)

# assign trials featuring multiple vaccines to first institute
timeline_clinical$group = as.character(timeline_clinical$group)
timeline_clinical$group[timeline_clinical$group=="Beijing Institute of Biological Products<br>Wuhan Institute of Biological Products<br>Sinopharm"] = "Beijing Institute of Biological Products<br>Sinopharm"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>University of Oxford<br>AstraZeneca"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$group[timeline_clinical$group=="University of Oxford<br>AstraZeneca<br>Gamaleya Research Institute"] = "University of Oxford<br>AstraZeneca"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>Moderna<br>NIAID<br>University of Oxford<br>AstraZeneca"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$subgroup[timeline_clinical$subgroup=="RNA/Vector (non-replicating)"] = "RNA"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>Sinovac<br>University of Oxford<br>AstraZeneca"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$subgroup[timeline_clinical$subgroup=="RNA/Inactivated/Vector (non-replicating)"] = "RNA"

# merge clinical and preclinical timelines
timeline_clinical = merge(timeline_clinical, timeline_preclinical[,c("group", "stage", "use")], all.x = TRUE, by = "group")
timeline = data.frame(rbind(timeline_preclinical, timeline_clinical))

# add separate timeline inputs for combined Wuhan/Beijing/Sinopharm trials
timeline = timeline %>% 
  add_row(group = "Beijing Institute of Biological Products<br>Sinopharm", subgroup = "Inactivated", 
          content = '<b>WIBP/BIBP vaccines</b><br>Phase III, Bahrain, Jordan, Egypt, UAE <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04510207" target="_blank">NCT04510207</a>', 
          start = '16/07/2020', end = '16/03/2021', stage = "Phase III", use="Yes") %>% 
  add_row(group = "Wuhan Institute of Biological Products<br>Sinopharm", subgroup = "Inactivated", 
          content = '<b>WIBP/BIBP vaccines</b><br>Phase III, Peru <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04612972" target="_blank">NCT04612972</a>', 
          start = '10/09/2020', end = '31/12/2020', stage = "Phase III", use="Yes") %>%
  
  # add separate timeline inputs for Oxford/Pfizer prime-boost trial 
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162/ChAdOx1-S prime-boost</b><br>Phase II, UK <i>(No longer recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN69254139" target="_blank">ISRCTN69254139</a>', 
          start = '08/02/2021', end = '05/11/2022', stage = "Phase III", use="Yes") %>% 
  
  # add separate timeline inputs for combined Oxford/Gamaleya trials
  add_row(group = "Gamaleya Research Institute", subgroup = "Vector (non-replicating)", 
          content = '<b>ChAdOx1-S/Gam-COVID-Vac prime-boost</b><br>Phase I/II, Pending <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04684446" target="_blank">NCT04684446</a>', 
          start = '30/03/2021', end = '12/10/2021', stage = "Phase III", use="Yes") %>% 
  add_row(group = "Gamaleya Research Institute", subgroup = "Vector (non-replicating)", 
          content = '<b>ChAdOx1-S/Gam-COVID-Vac prime-boost</b><br>Phase II, Azerbaijan <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04686773" target="_blank">NCT04686773</a>', 
          start = '10/02/2021', end = '09/04/2021', stage = "Phase III", use="Yes") %>% 
  add_row(group = "Gamaleya Research Institute", subgroup = "Vector (non-replicating)", 
          content = '<b>ChAdOx1-S/Gam-COVID-Vac prime-boost</b><br>Phase II, Azerbaijan <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04760730" target="_blank">NCT04760730</a>', 
          start = '17/03/2021', end = '01/05/2021', stage = "Phase III", use="Yes") %>% 
  
  # add timeline input for terminated candidates
  add_row(group = "University of Queensland<br>CSL<br>Seqirus", subgroup = "Protein subunit", 
        content = '<b>Molecular clamp vaccine</b><br>Programme halted<br><a href="https://www.csl.com/news/2020/20201211-update-on-the-university-of-queensland-covid-19-vaccine" target="_blank">11 Dec 2020</a>', 
        start = '11/12/2020', stage = "Terminated", use = "No") %>% 
  add_row(group = "IAVI<br>Merck", subgroup = "Vector (replicating)", 
        content = '<b>MV590</b><br>Programme halted<br><a href="https://www.merck.com/news/merck-discontinues-development-of-sars-cov-2-covid-19-vaccine-candidates-continues-development-of-two-investigational-therapeutic-candidates/" target="_blank">25 Jan 2021</a>', 
        start = '25/01/2021', stage = "Terminated", use = "No") %>%
  add_row(group = "Institut Pasteur<br>Themis<br>University of Pittsburg<br>Merck", subgroup = "Vector (replicating)", 
        content = '<b>V591/TMV-083</b><br>Programme halted<br><a href="https://www.merck.com/news/merck-discontinues-development-of-sars-cov-2-covid-19-vaccine-candidates-continues-development-of-two-investigational-therapeutic-candidates/" target="_blank">25 Jan 2021</a>', 
        start = '25/01/2021', stage = "Terminated", use = "No")  %>%
  add_row(group = "Imperial College London", subgroup = "RNA", 
          content = '<b>LNP-nCoVsaRNA</b><br>Programme halted<br><a href="https://www.imperial.ac.uk/news/213313/imperial-vaccine-tech-target-covid-mutations/" target="_blank">26 Jan 2021</a>', 
          start = '26/01/2021', stage = "Terminated", use = "No")  %>%

  # add timeline input for phase IV NCT04760132
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273/ChAdOx1-S</b><br>Phase IV, Denmark <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04760132" target="_blank">NCT04760132</a>', 
          start = '08/02/2021', end = '31/12/2024', stage = "Phase IV", use="Yes") %>% 
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162/mRNA-1273/ChAdOx1-S</b><br>Phase IV, Denmark <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04760132" target="_blank">NCT04760132</a>', 
          start = '08/02/2021', end = '31/12/2024', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase IV NCT04775069
  add_row(group = "Sinovac", subgroup = "Inactivated", 
          content = '<b>BNT162/CoronaVac/ChAdOx1-S</b><br>Phase IV, Hong Kong <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04775069" target="_blank">NCT04775069</a>', 
          start = '15/03/2021', end = '31/12/2021', stage = "Phase IV", use="Yes") %>% 
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162/CoronaVac/ChAdOx1-S</b><br>Phase IV, Hong Kong <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04775069" target="_blank">NCT04775069</a>', 
          start = '15/03/2021', end = '31/12/2021', stage = "Phase IV", use="Yes") %>% 

# add timeline input for phase III NCT04800133
add_row(group = "Sinovac", subgroup = "Inactivated", 
        content = '<b>BNT162/CoronaVac/ChAdOx1-S</b><br>Phase III, Hong Kong <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04800133" target="_blank">NCT04800133</a>', 
        start = '21/03/2021', end = '31/03/2025', stage = "Phase III", use="Yes") %>% 
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162/CoronaVac/ChAdOx1-S</b><br>Phase III, Hong Kong <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04800133" target="_blank">NCT04800133</a>', 
          start = '21/03/2021', end = '31/03/2025', stage = "Phase III", use="Yes")
  
# set factor levels
timeline$subgroup = factor(timeline$subgroup, levels=c("RNA", "DNA", "Vector (non-replicating)", "Vector (replicating)", "Inactivated", "Live-attenuated",
                                                       "Protein subunit", "Virus-like particle", "Other/Unknown"))

# convert start and end columns to Date format
timeline$start = format(as.Date(timeline$start, format="%d/%m/%Y"),"%Y-%m-%d") 
timeline$end = format(as.Date(timeline$end, format="%d/%m/%Y"),"%Y-%m-%d") 

# sort by platform (subgroup) then Institutes (group)
timeline = timeline %>% arrange(subgroup, group)

# create group- and subgroup-specific dataframes
groups_df = data.frame(id = unique(timeline$group), content = unique(timeline$group))
subgroups_df = data.frame(id = unique(timeline$subgroup), content = unique(timeline$subgroup))

# set colour palettes for each platform
pal_1 = brewer.pal(9, "Blues")[c(3:6,9)] # RNA
pal_2 = brewer.pal(9, "Blues")[c(6:9,3)] # DNA
pal_3 = brewer.pal(9, "Oranges")[c(3:6,9)] # Vector (non-replicating)
pal_4 = brewer.pal(9, "Oranges")[c(6:9,3)] # Vector (replicating)
pal_5 = brewer.pal(9, "Greens")[c(3:6,9)] # Inactivated 
pal_6 = brewer.pal(9, "Greens")[c(6:9,3)] # Live-attenuated
pal_7 = brewer.pal(9, "Purples")[c(3:6,9)] # Protein subunit
pal_8 = brewer.pal(9, "Purples")[c(6:9,3)] # Virus-like particle
pal_9 = brewer.pal(9, "Greys")[c(3:6,9)] # Other/unknown

# add styles for preclinical timeline rows
timeline$style = NA
timeline$style[timeline$subgroup=="RNA"] = paste0("font-size:12px;border-color:",pal_1[5],";background-color:",pal_1[1],";color:",pal_1[5],";")
timeline$style[timeline$subgroup=="DNA"] = paste0("font-size:12px;border-color:",pal_2[5],";background-color:",pal_2[1],";color:",pal_2[5],";")
timeline$style[timeline$subgroup=="Vector (non-replicating)"] = paste0("font-size:12px;border-color:",pal_3[5],";background-color:",pal_3[1],";color:",pal_3[5],";")
timeline$style[timeline$subgroup=="Vector (replicating)"] = paste0("font-size:12px;border-color:",pal_4[5],";background-color:",pal_4[1],";color:",pal_4[5],";")
timeline$style[timeline$subgroup=="Inactivated"] = paste0("font-size:12px;border-color:",pal_5[5],";background-color:",pal_5[1],";color:",pal_5[5],";")
timeline$style[timeline$subgroup=="Live-attenuated"] = paste0("font-size:12px;border-color:",pal_6[5],";background-color:",pal_6[1],";color:",pal_6[5],";")
timeline$style[timeline$subgroup=="Protein subunit"] = paste0("font-size:12px;border-color:",pal_7[5],";background-color:",pal_7[1],";color:",pal_7[5],";")
timeline$style[timeline$subgroup=="Virus-like particle"] = paste0("font-size:12px;border-color:",pal_8[5],";background-color:",pal_8[1],";color:",pal_8[5],";")
timeline$style[timeline$subgroup=="Other/Unknown"] = paste0("font-size:12px;border-color:",pal_9[5],";background-color:",pal_9[1],";color:",pal_9[5],";")

# add style for phase I timeline rows
timeline$style[timeline$subgroup=="RNA" & grepl("Phase I", timeline$content)] = paste0("font-size:12px;border-color:",pal_1[5],";background-color:",pal_1[2],";color:",pal_1[5],";")
timeline$style[timeline$subgroup=="DNA" & grepl("Phase I", timeline$content)] = paste0("font-size:12px;border-color:",pal_2[5],";background-color:",pal_2[2],";color:",pal_2[5],";")
timeline$style[timeline$subgroup=="Vector (non-replicating)" & grepl("Phase I", timeline$content)] = paste0("font-size:12px;border-color:",pal_3[5],";background-color:",pal_3[2],";color:",pal_3[5],";")
timeline$style[timeline$subgroup=="Vector (replicating)" & grepl("Phase I", timeline$content)] = paste0("font-size:12px;border-color:",pal_4[5],";background-color:",pal_4[2],";color:",pal_4[5],";")
timeline$style[timeline$subgroup=="Inactivated" & grepl("Phase I", timeline$content)] = paste0("font-size:12px;border-color:",pal_5[5],";background-color:",pal_5[2],";color:",pal_5[5],";")
timeline$style[timeline$subgroup=="Live-attenuated" & grepl("Phase I", timeline$content)] = paste0("font-size:12px;border-color:",pal_6[5],";background-color:",pal_6[2],";color:",pal_6[5],";")
timeline$style[timeline$subgroup=="Protein subunit" & grepl("Phase I", timeline$content)] = paste0("font-size:12px;border-color:",pal_7[5],";background-color:",pal_7[2],";color:",pal_7[5],";")
timeline$style[timeline$subgroup=="Virus-like particle" & grepl("Phase I", timeline$content)] = paste0("font-size:12px;border-color:",pal_8[5],";background-color:",pal_8[2],";color:",pal_8[5],";")
timeline$style[timeline$subgroup=="Other/Unknown" & grepl("Phase I", timeline$content)] = paste0("font-size:12px;border-color:",pal_9[5],";background-color:",pal_9[2],";color:",pal_9[5],";")

# add style for phase II timeline rows
timeline$style[timeline$subgroup=="RNA" & grepl("II", timeline$content)] = paste0("font-size:12px;border-color:",pal_1[5],";background-color:",pal_1[3],";color:",pal_1[5],";")
timeline$style[timeline$subgroup=="DNA" & grepl("II", timeline$content)] = paste0("font-size:12px;border-color:",pal_2[5],";background-color:",pal_2[3],";color:",pal_2[5],";")
timeline$style[timeline$subgroup=="Vector (non-replicating)" & grepl("II", timeline$content)] = paste0("font-size:12px;border-color:",pal_3[5],";background-color:",pal_3[3],";color:",pal_3[5],";")
timeline$style[timeline$subgroup=="Vector (replicating)" & grepl("II", timeline$content)] = paste0("font-size:12px;border-color:",pal_4[5],";background-color:",pal_4[3],";color:",pal_4[5],";")
timeline$style[timeline$subgroup=="Inactivated" & grepl("II", timeline$content)] = paste0("font-size:12px;border-color:",pal_5[5],";background-color:",pal_5[3],";color:",pal_5[5],";")
timeline$style[timeline$subgroup=="Live-attenuated" & grepl("II", timeline$content)] = paste0("font-size:12px;border-color:",pal_6[5],";background-color:",pal_6[3],";color:",pal_6[5],";")
timeline$style[timeline$subgroup=="Protein subunit" & grepl("II", timeline$content)] = paste0("font-size:12px;border-color:",pal_7[5],";background-color:",pal_7[3],";color:",pal_7[5],";")
timeline$style[timeline$subgroup=="Virus-like particle" & grepl("II", timeline$content)] = paste0("font-size:12px;border-color:",pal_8[5],";background-color:",pal_8[3],";color:",pal_8[5],";")
timeline$style[timeline$subgroup=="Other/Unknown" & grepl("II", timeline$content)] = paste0("font-size:12px;border-color:",pal_9[5],";background-color:",pal_9[3],";color:",pal_9[5],";")

# add style for phase III timeline rows
timeline$style[timeline$subgroup=="RNA" & grepl("III", timeline$content)] = paste0("font-size:12px;border-color:",pal_1[5],";background-color:",pal_1[4],";color:",pal_1[5],";")
timeline$style[timeline$subgroup=="DNA" & grepl("III", timeline$content)] = paste0("font-size:12px;border-color:",pal_2[5],";background-color:",pal_2[4],";color:",pal_2[5],";")
timeline$style[timeline$subgroup=="Vector (non-replicating)" & grepl("III", timeline$content)] = paste0("font-size:12px;border-color:",pal_3[5],";background-color:",pal_3[4],";color:",pal_3[5],";")
timeline$style[timeline$subgroup=="Vector (replicating)" & grepl("III", timeline$content)] = paste0("font-size:12px;border-color:",pal_4[5],";background-color:",pal_4[4],";color:",pal_4[5],";")
timeline$style[timeline$subgroup=="Inactivated" & grepl("III", timeline$content)] = paste0("font-size:12px;border-color:",pal_5[5],";background-color:",pal_5[4],";color:",pal_5[5],";")
timeline$style[timeline$subgroup=="Live-attenuated" & grepl("III", timeline$content)] = paste0("font-size:12px;border-color:",pal_6[5],";background-color:",pal_6[4],";color:",pal_6[5],";")
timeline$style[timeline$subgroup=="Protein subunit" & grepl("III", timeline$content)] = paste0("font-size:12px;border-color:",pal_7[5],";background-color:",pal_7[4],";color:",pal_7[5],";")
timeline$style[timeline$subgroup=="Virus-like particle" & grepl("III", timeline$content)] = paste0("font-size:12px;border-color:",pal_8[5],";background-color:",pal_8[4],";color:",pal_8[5],";")
timeline$style[timeline$subgroup=="Other/Unknown" & grepl("III", timeline$content)] = paste0("font-size:12px;border-color:",pal_9[5],";background-color:",pal_9[4],";color:",pal_9[5],";")

# add style for phase IV timeline rows
timeline$style[timeline$subgroup=="RNA" & grepl("IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_1[1],";background-color:",pal_1[5],";color:",pal_1[1],";")
timeline$style[timeline$subgroup=="DNA" & grepl("IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_2[1],";background-color:",pal_2[5],";color:",pal_2[1],";")
timeline$style[timeline$subgroup=="Vector (non-replicating)" & grepl("IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_3[1],";background-color:",pal_3[5],";color:",pal_3[1],";")
timeline$style[timeline$subgroup=="Vector (replicating)" & grepl("IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_4[1],";background-color:",pal_4[5],";color:",pal_4[1],";")
timeline$style[timeline$subgroup=="Inactivated" & grepl("IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_5[1],";background-color:",pal_5[5],";color:",pal_5[1],";")
timeline$style[timeline$subgroup=="Live-attenuated" & grepl("IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_6[1],";background-color:",pal_6[5],";color:",pal_6[1],";")
timeline$style[timeline$subgroup=="Protein subunit" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_7[1],";background-color:",pal_7[5],";color:",pal_7[1],";")
timeline$style[timeline$subgroup=="Virus-like particle" & grepl("IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_8[1],";background-color:",pal_8[5],";color:",pal_8[1],";")
timeline$style[timeline$subgroup=="Other/Unknown" & grepl("IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_9[1],";background-color:",pal_9[5],";color:",pal_9[1],";")

# add style for terminated timeline row
timeline$style[grepl("Programme halted", timeline$content)] = paste0("font-size:12px;border-color:",pal_9[5],";background-color:",pal_9[1],";color:",pal_9[5],";")


### Summary plot --------------------------------------------------------------------

# summary inputs for ui
landscape_all = landscape
landscape = subset(landscape_all, Phase!="Terminated")
total_count = nrow(landscape)
clinical_count = sum(landscape$Phase!="Pre-clinical")

# combine phases II/III with phase III for plotting purposes
landscape$Phase[landscape$Phase=="Phase II/III"] = "Phase III"

# create summary dataframe with one row per platform/phase/status
ntypes = length(levels(timeline$subgroup))
summary = data.frame(Group = rep(levels(timeline$subgroup),7),
                     Phase = c(rep("Pre-clinical",ntypes),rep("Phase I",ntypes),rep("Phase I/II",ntypes),rep("Phase II",ntypes),rep("Phase III",ntypes),rep("Phase IV",ntypes),rep("In use",ntypes)),
                     N = 0)
summary$Stage = "Testing"
summary$Stage[summary$Phase=="In use"] = "Use"
summary$Stage = factor(summary$Stage, levels = c("Testing", "Use"))
for (i in 1:nrow(summary)) { summary$N[i] = nrow(subset(landscape, Platform==as.character(summary$Group[i]) & Phase==as.character(summary$Phase[i]))) }
for (i in 1:ntypes) { summary$N[summary$Phase=="In use"][i] = nrow(subset(landscape, Platform==as.character(summary$Group[i]) & In.use=="Yes")) }
summary$N[summary$N==0] = NA

# set levels
summary$Group = factor(summary$Group, levels=rev(c("RNA", "DNA", "Vector (non-replicating)", "Vector (replicating)", "Inactivated", "Live-attenuated",
                                                   "Protein subunit", "Virus-like particle", "Other/Unknown")))
summary$Phase = factor(summary$Phase, levels=c("Pre-clinical", "Phase I", "Phase I/II", "Phase II", "Phase III", "Phase IV", "In use"))

# generate summary plot
summary_plot = ggplot(summary, aes(x=Phase, y=Group, colour=Group, label=N)) + geom_point(alpha = 0.8, aes(size=N)) + theme_bw() +
  scale_colour_manual(values = c("RNA" = pal_1[1], "DNA" = pal_2[1], "Vector (non-replicating)" = pal_3[1], "Vector (replicating)" = pal_4[1], 
                                 "Inactivated" = pal_5[1], "Live-attenuated" = pal_6[1], "Protein subunit" = pal_7[1], "Virus-like particle" = pal_8[1],
                                 "Other/Unknown" = pal_9[1])) +
  xlab("") + ylab("") + 
  scale_size(range = c(1, 12)) + geom_text(color="black", size=5) +
  facet_grid(.~Stage,  scales = "free", space='free') + theme(strip.background = element_blank()) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), legend.position = "", text = element_text(size=15), 
        axis.text = element_text(size=15), strip.text = element_text(size=15))
