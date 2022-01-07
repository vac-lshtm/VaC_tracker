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
                                  use = landscape$In.use, 
                                  pub = NA)
timeline_clinical = data.frame(group = trials$Institutes %>% str_replace_all(., "/", "<br>"),
                               subgroup = trials$Platform,
                               content = paste0("<b>",trials$Name,"</b><br>",trials$Phase,", ",trials$Location, " <i>(", trials$Status,")</i><br>",
                                                '<a href="',trials$Link,'" style="color:#006d2c" target="_blank">',trials$Trial.number,"</a><br>",trials$Paper),
                               start = trials$Start.date, end = trials$Primary.completion.date, 
                               pub = trials$Published)

timeline_clinical$content = str_remove(timeline_clinical$content, "<br>NA")

# assign trials featuring multiple vaccines to first institute
timeline_clinical$group = as.character(timeline_clinical$group)
timeline_clinical$group[timeline_clinical$group=="Beijing Institute of Biological Products<br>Wuhan Institute of Biological Products<br>Sinopharm"] = "Beijing Institute of Biological Products<br>Sinopharm"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>Janssen Pharmaceutical Companies<br>Moderna<br>NIAID"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>Janssen Pharmaceutical Companies<br>Moderna<br>NIAID<br>University of Oxford<br>AstraZeneca"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>Moderna<br>NIAID"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>Moderna<br>NIAID<br>University of Oxford<br>AstraZeneca"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>Moderna<br>NIAID<br>University of Oxford<br>AstraZeneca<br>Novavax"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>Sinovac"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>Sinovac<br>University of Oxford<br>AstraZeneca"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>University of Oxford<br>AstraZeneca"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
#timeline_clinical$group[timeline_clinical$group=="Erciyes University (inactivated)<br>Sinovac"] = "Erciyes University (inactivated)"
timeline_clinical$group[timeline_clinical$group=="University of Oxford<br>AstraZeneca<br>Beijing Institute of Biological Products<br>Sinopharm"] = "University of Oxford<br>AstraZeneca"
timeline_clinical$group[timeline_clinical$group=="Valneva<br>Dynavax<br>University of Oxford<br>AstraZeneca"] = "Valneva<br>Dynavax"
# timeline_clinical$group[timeline_clinical$group=="BioNTech<br>Pfizer<br>Fosun Pharma<br>CureVac<br>Moderna<br>NIAID<br>Novavax<br>University of Oxford<br>AstraZeneca<br>Valneva<br>Dynavax"] = "BioNTech<br>Pfizer<br>Fosun Pharma"
# timeline_clinical$group[timeline_clinical$group=="CanSino Biological Inc<br>Beijing Institute of Biotechnology<br>Anhui Zhifei Longcom Biopharmaceutical<br>Chinese Academy of Sciences"] = "CanSino Biological Inc<br>Beijing Institute of Biotechnology"
# timeline_clinical$group[timeline_clinical$group=="CanSino Biological Inc<br>Beijing Institute of Biotechnology<br>Sinovac"] = "CanSino Biological Inc<br>Beijing Institute of Biotechnology"
# timeline_clinical$group[timeline_clinical$group=="University of Oxford<br>AstraZeneca<br>Gamaleya Research Institute"] = "University of Oxford<br>AstraZeneca"
# timeline_clinical$group[timeline_clinical$group=="Institute of Medical Biology,<br>Chinese Academy of Medical Sciences<br>Stemirna Therapeutics Co Ltd<br>Shanghai East Hospital"] = "Institute of Medical Biology,<br>Chinese Academy of Medical Sciences"
# timeline_clinical$group[timeline_clinical$group=="Beijing Institute of Biological Products<br>Sinopharm<br>CanSino Biological Inc<br>Beijing Institute of Biotechnology"] = "Beijing Institute of Biological Products<br>Sinopharm"
# timeline_clinical$group[timeline_clinical$group=="Janssen Pharmaceutical Companies<br>Moderna<br>NIAID"] = "Janssen Pharmaceutical Companies"
# timeline_clinical$group[timeline_clinical$group=="Gamaleya Research Institute<br>University of Oxford<br>AstraZeneca<br>Beijing Institute of Biological Products<br>Sinopharm"] = "Gamaleya Research Institute"

timeline_clinical$subgroup = as.character(timeline_clinical$subgroup)
timeline_clinical$subgroup[timeline_clinical$subgroup=="RNA/Vector (non-replicating)"] = "RNA"
timeline_clinical$subgroup[timeline_clinical$subgroup=="Inactivated/Vector (non-replicating)"] = "Inactivated"
timeline_clinical$subgroup[timeline_clinical$subgroup=="Vector (non-replicating)/Inactivated"] = "Vector (non-replicating)"
timeline_clinical$subgroup[timeline_clinical$subgroup=="RNA/Inactivated"] = "RNA"
timeline_clinical$subgroup[timeline_clinical$subgroup=="RNA/Inactivated/Vector (non-replicating)"] = "RNA"
timeline_clinical$subgroup[timeline_clinical$subgroup=="RNA/Vector (non-replicating)/Protein subunit"] = "RNA"
# timeline_clinical$subgroup[timeline_clinical$subgroup=="RNA/Protein subunit/Vector (non-replicating)/Inactivated"] = "RNA"
# timeline_clinical$subgroup[timeline_clinical$subgroup=="Vector (non-replicating)/Inactivated"] = "Vector (non-replicating)"
# timeline_clinical$subgroup[timeline_clinical$subgroup=="RNA/Vector (non-replicating)"] = "RNA"
# timeline_clinical$subgroup[timeline_clinical$subgroup=="Vector (non-replicating)/Protein subunit"] = "Vector (non-replicating)"
# timeline_clinical$subgroup[timeline_clinical$subgroup=="Vector (non-replicating)/Inactivated"] = "Vector (non-replicating)"
# timeline_clinical$subgroup[timeline_clinical$subgroup=="Vector (non-replicating)/RNA"] = "Vector (non-replicating)"
# timeline_clinical$subgroup[timeline_clinical$subgroup=="Inactivated/RNA"] = "Inactivated"

# merge clinical and preclinical timelines
timeline_hetero = timeline_clinical[timeline_clinical$subgroup=="Heterologous",]
timeline_hetero$stage = "Heterologous"
timeline_hetero$use = "No"
timeline_clinical = merge(timeline_clinical[timeline_clinical$subgroup!="Heterologous",], timeline_preclinical[,c("group", "stage", "use")], all.x = TRUE, by = "group")
timeline = data.frame(rbind(timeline_preclinical, timeline_clinical, timeline_hetero))
timeline$group = as.character(timeline$group)
timeline$subgroup = as.character(timeline$subgroup)

# add separate timeline inputs for combined Wuhan/Beijing/Sinopharm trials
timeline = timeline %>% 
  add_row(group = "Wuhan Institute of Biological Products<br>Sinopharm", subgroup = "Inactivated", 
          content = '<b>WIBP/BIBP vaccines</b><br>Phase III, Bahrain, Jordan, Egypt, UAE <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04510207" style="color:#006d2c" target="_blank">NCT04510207</a><br><a href="https://jamanetwork.com/journals/jama/fullarticle/2780562" style="color:#006d2c" target="_blank">Al Kaabi; JAMA 2021</a>', 
          start = '16/07/2020', end = '16/06/2021', stage = "Phase IV", use="Yes", pub="yes") %>% 
  add_row(group = "Wuhan Institute of Biological Products<br>Sinopharm", subgroup = "Inactivated", 
          content = '<b>WIBP/BIBP vaccines</b><br>Phase III, Peru <i>(Active, not recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04612972" style="color:#006d2c" target="_blank">NCT04612972</a>', 
          start = '09/09/2020', end = '19/02/2021', stage = "Phase III", use="Yes") %>%

  # add timeline input for NCT05000216
  add_row(group = "Janssen Pharmaceutical Companies", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162 (b2)/Ad26.COV2.S/mRNA-1273</b><br>Phase II, USA <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT05000216" style="color:#006d2c" target="_blank">NCT05000216</a>', 
          start = '13/08/2021', end = '31/01/2022', stage = "Phase IV", use="Yes") %>% 
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162 (b2)/Ad26.COV2.S/mRNA-1273</b><br>Phase II, USA <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT05000216" style="color:#006d2c" target="_blank">NCT05000216</a>', 
          start = '13/08/2021', end = '31/01/2022', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for EUCTR2021-002327-38-NL
  add_row(group = "Janssen Pharmaceutical Companies", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162/Ad26.COV2.S/mRNA-1273/ChAdOx1-S</b><br>Phase IV, Netherlands <i>(Ongoing)</i><br><a href="https://www.clinicaltrialsregister.eu/ctr-search/trial/2021-002327-38/NL" style="color:#006d2c" target="_blank">EUCTR2021-002327-38-NL</a>', 
          start = '26/05/2021', end = '26/05/2022', stage = "Phase IV", use="Yes") %>% 
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/Ad26.COV2.S/mRNA-1273/ChAdOx1-S</b><br>Phase IV, Netherlands <i>(Ongoing)</i><br><a href="https://www.clinicaltrialsregister.eu/ctr-search/trial/2021-002327-38/NL" style="color:#006d2c" target="_blank">EUCTR2021-002327-38-NL</a>', 
          start = '26/05/2021', end = '26/05/2022', stage = "Phase IV", use="Yes") %>% 
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162/Ad26.COV2.S/mRNA-1273/ChAdOx1-S</b><br>Phase IV, Netherlands <i>(Ongoing)</i><br><a href="https://www.clinicaltrialsregister.eu/ctr-search/trial/2021-002327-38/NL" style="color:#006d2c" target="_blank">EUCTR2021-002327-38-NL</a>', 
          start = '26/05/2021', end = '26/05/2022', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for NCT04969263
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273</b><br>Phase II, USA <i>(Active, not recruiting)</i><br><a https://clinicaltrials.gov/ct2/show/NCT04969263" style="color:#006d2c" target="_blank">NCT04969263</a>', 
          start = '10/08/2021', end = '30/11/2021', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase IV EUCTR2021-000893-27-BE
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273</b><br>Phase IV, Belgium <i>(Ongoing)</i><br><a href="https://www.clinicaltrialsregister.eu/ctr-search/trial/2021-000893-27/BE" style="color:#006d2c" target="_blank">EUCTR2021-000893-27-BE</a>', 
          start = '27/04/2021', end = '27/10/2021', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for EUCTR2021-003618-37-NO
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
           content = '<b>BNT162/mRNA-1273</b><br>Phase IV, Norway <i>(Ongoing)</i><br><a https://www.clinicaltrialsregister.eu/ctr-search/trial/2021-003618-37/NO" style="color:#006d2c" target="_blank">EUCTR2021-003618-37-NO</a>', 
           start = '29/06/2021', end = '29/09/2023', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for NCT04969250
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273</b><br>Phase IV, USA, Spain <i>(Recruiting)</i><br><a https://clinicaltrials.gov/ct2/show/NCT04969250" style="color:#006d2c" target="_blank">NCT04969250</a>', 
          start = '25/08/2021', end = '31/07/2022', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase IV EUCTR2021-000930-32-BE
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273</b><br>Phase IV, Belgium <i>(Ongoing)</i><br><a href="https://www.clinicaltrialsregister.eu/ctr-search/trial/2021-000930-32/BE" style="color:#006d2c" target="_blank">EUCTR2021-000930-32-BE</a>', 
          start = '27/04/2021', end = '27/10/2021', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase III NCT04805125
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273</b><br>Phase III, Switzerland <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04805125" style="color:#006d2c" target="_blank">NCT04805125</a>', 
          start = '19/04/2021', end = '31/07/2022', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for EUCTR2021-003388-90-NL
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273</b><br>Phase IV, Netherlands <i>(Pending)</i><br><a href="https://www.clinicaltrialsregister.eu/ctr-search/trial/2021-003388-90/NL" style="color:#006d2c" target="_blank">EUCTR2021-003388-90-NL</a>', 
          start = '21/06/2021', end = '04/09/2022', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase I NCT04839315
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273</b><br>Phase I, USA <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04839315" style="color:#006d2c" target="_blank">NCT04839315</a>', 
          start = '15/02/2021', end = '31/12/2021', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase IV NCT04760132
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273/ChAdOx1-S</b><br>Phase IV, Denmark <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04760132" style="color:#006d2c" target="_blank">NCT04760132</a>', 
          start = '08/02/2021', end = '31/12/2024', stage = "Phase IV", use="Yes") %>% 
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162/mRNA-1273/ChAdOx1-S</b><br>Phase IV, Denmark <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04760132" style="color:#006d2c" target="_blank">NCT04760132</a>', 
          start = '08/02/2021', end = '31/12/2024', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase IV NCT04775069
  add_row(group = "Sinovac", subgroup = "Inactivated", 
          content = '<b>BNT162/CoronaVac/ChAdOx1-S</b><br>Phase IV, Hong Kong <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04775069" style="color:#006d2c" target="_blank">NCT04775069</a>', 
          start = '21/05/2021', end = '31/12/2021', stage = "Phase IV", use="Yes") %>% 
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162/CoronaVac/ChAdOx1-S</b><br>Phase IV, Hong Kong <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04775069" style="color:#006d2c" target="_blank">NCT04775069</a>', 
          start = '21/05/2021', end = '31/12/2021', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase III NCT04800133
  add_row(group = "Sinovac", subgroup = "Inactivated", 
          content = '<b>BNT162/CoronaVac</b><br>Phase II, Hong Kong <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04800133" style="color:#006d2c" target="_blank">NCT04800133</a>', 
          start = '08/05/2021', end = '31/03/2025', stage = "Phase IV", use="Yes") %>% 

  # add timeline input for ACTRN12621000661875
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>BNT162/ChAdOx1-S</b><br>Phase IV, Australia <i>(Recruiting)</i><br><a href="https://anzctr.org.au/Trial/Registration/TrialReview.aspx?ACTRN=12621000661875" style="color:#006d2c" target="_blank">ACTRN12621000661875</a>', 
          start = '10/05/2021', end = '', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase II/III NCT04885764
  add_row(group = "Beijing Institute of Biological Products<br>Sinopharm", subgroup = "Inactivated", 
          content = '<b>ChAdOx1-S/BBIBP-CorV</b><br>Phase II/III, Egypt <i>(Recruiting)</i><br><a href=""https://clinicaltrials.gov/ct2/show/NCT04885764" style="color:#006d2c" target="_blank">NCT04885764</a>', 
          start = '23/02/2021', end = '01/10/2021', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase III NCT04864561
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>VLA2001/ChAdOx1-S</b><br>Phase III, UK <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04864561" style="color:#006d2c" target="_blank">NCT04864561</a>', 
          start = '26/04/2021', end = '28/02/2022', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase III NCT05047718
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BNT162/mRNA-1273</b><br>Phase IV, France <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT05047718" style="color:#006d2c" target="_blank">NCT05047718</a>', 
          start = '05/10/2021', end = '01/09/2022', stage = "Phase IV", use="Yes") %>% 
  
  # add timeline input for phase III NCT05047718
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
          content = '<b>BBNT162/mRNA-1273/ChAdOx1-S/NVX-CoV2373</b><br>Phase II, UK <i>(Recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN15279830" style="color:#006d2c" target="_blank">ISRCTN15279830</a>', 
          start = '01/06/2021', end = '01/08/2023', stage = "Phase IV", use="Yes") %>% 
  add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
          content = '<b>BBNT162/mRNA-1273/ChAdOx1-S/NVX-CoV2373</b><br>Phase II, UK <i>(Recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN15279830" style="color:#006d2c" target="_blank">ISRCTN15279830</a>', 
          start = '01/06/2021', end = '01/08/2023', stage = "Phase IV", use="Yes") %>% 
  add_row(group = "Novavax", subgroup = "Protein subunit", 
          content = '<b>BBNT162/mRNA-1273/ChAdOx1-S/NVX-CoV2373</b><br>Phase II, UK <i>(Recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN15279830" style="color:#006d2c" target="_blank">ISRCTN15279830</a>', 
          start = '01/06/2021', end = '01/08/2023', stage = "Phase III", use="No") %>% 

  # add timeline input for phase II NCT05160766
  add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
        content = '<b>BNT162/mRNA-1273</b><br>Phase II, Germany <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT05047718" style="color:#006d2c" target="_blank">NCT05047718</a>', 
        start = '08/11/2021', end = '30/04/2022', stage = "Phase IV", use="Yes")
  
  # add timeline input for phase III NCT05077176
  # add_row(group = "Sinovac", subgroup = "Inactivated", 
  #         content = '<b>TURKOVAC/CoronaVac</b><br>Phase III, Turkey <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT05077176" style="color:#006d2c" target="_blank">NCT05077176</a>', 
  #         start = '08/10/2021', end = '05/04/2022', stage = "Phase IV", use="Yes")#%>% 
  
  # add timeline input for terminated candidates
  # add_row(group = "University of Queensland<br>CSL<br>Seqirus", subgroup = "Protein subunit", 
  #       content = '<b>Molecular clamp vaccine</b><br>Programme halted<br><a href="https://www.csl.com/news/2020/20201211-update-on-the-university-of-queensland-covid-19-vaccine" style="color:#006d2c" target="_blank">11 Dec 2020</a>', 
  #       start = '11/12/2020', stage = "Terminated", use = "No") %>% 
  # add_row(group = "IAVI<br>Merck", subgroup = "Vector (replicating)", 
  #       content = '<b>MV590</b><br>Programme halted<br><a href="https://www.merck.com/news/merck-discontinues-development-of-sars-cov-2-covid-19-vaccine-candidates-continues-development-of-two-investigational-therapeutic-candidates/" style="color:#006d2c" target="_blank">25 Jan 2021</a>', 
  #       start = '25/01/2021', stage = "Terminated", use = "No") %>%
  # add_row(group = "Institut Pasteur<br>Themis<br>University of Pittsburg<br>Merck", subgroup = "Vector (replicating)", 
  #       content = '<b>V591/TMV-083</b><br>Programme halted<br><a href="https://www.merck.com/news/merck-discontinues-development-of-sars-cov-2-covid-19-vaccine-candidates-continues-development-of-two-investigational-therapeutic-candidates/" style="color:#006d2c" target="_blank">25 Jan 2021</a>', 
  #       start = '25/01/2021', stage = "Terminated", use = "No")  %>%
  # add_row(group = "Imperial College London", subgroup = "RNA", 
  #         content = '<b>LNP-nCoVsaRNA</b><br>Programme halted<br><a href="https://www.imperial.ac.uk/news/213313/imperial-vaccine-tech-target-covid-mutations/" style="color:#006d2c" target="_blank">26 Jan 2021</a>', 
  #         start = '26/01/2021', stage = "Terminated", use = "No")  %>%
  # add_row(group = "Altimmune<br>University of Alabama at Birmingham", subgroup = "Vector (non-replicating)", 
  #         content = '<b>AdCOVID</b><br>Programme halted<br><a href="https://ir.altimmune.com/news-releases/news-release-details/altimmune-announces-update-adcovidtm-phase-1-clinical-trial" style="color:#006d2c" target="_blank">29 Jun 2021</a>', 
  #         start = '29/06/2021', stage = "Terminated", use = "No") %>%
  # add_row(group = "OncoSec Medical Inc<br>Providence Cancer Institute", subgroup = "DNA", 
  #         content = '<b>CORVax12</b><br>Programme halted<br>', 
  #         start = '01/11/2021', stage = "Terminated", use = "No") 


# add separate timeline inputs for ISRCTN69254139 prime-boost trial 
# add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
#         content = '<b>BNT162/ChAdOx1-S prime-boost</b><br>Phase II, UK <i>(No longer recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN69254139" style="color:#006d2c" target="_blank">ISRCTN69254139</a><br><a href="https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3874014" style="color:#006d2c" target="_blank">Liu; Lancet preprint 2021</a>', 
#         start = '08/02/2021', end = '05/11/2022', stage = "Phase IV", use="Yes", pub="yes") %>% 
# 
# add separate timeline inputs for NCT04894435 prime-boost trial 
# add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
#         content = '<b>BNT162/mRNA-1273/ChAdOx1-S prime-boost</b><br>Phase II, Canada <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04894435" style="color:#006d2c" target="_blank">NCT04894435</a>', 
#         start = '20/05/2021', end = '31/03/2023', stage = "Phase IV", use="Yes") %>% 
# add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
#         content = '<b>BNT162/mRNA-1273/ChAdOx1-S prime-boost</b><br>Phase II, Canada <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04894435" style="color:#006d2c" target="_blank">NCT04894435</a>', 
#         start = '20/05/2021', end = '31/03/2023', stage = "Phase IV", use="Yes") %>% 
# 
# add separate timeline inputs for NCT04892459 prime-boost trial 
# add_row(group = "Sinovac", subgroup = "Inactivated", 
#         content = '<b>CanSino/Sinovac prime-boost</b><br>Phase IV, China <i>(Active, not recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04892459" style="color:#006d2c" target="_blank">NCT04892459</a>', 
#         start = '25/05/2021', end = '25/07/2021', stage = "Phase IV", use="Yes") %>% 
# 
#  add separate timeline inputs for EUCTR2021-001978-37-ES prime-boost trial
# add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
#         content = '<b>BNT162/ChAdOx1-S prime-boost</b><br>Phase II, Spain <i>(Ongoing)</i><br><a href="https://www.clinicaltrialsregister.eu/ctr-search/trial/2021-001978-37/ES" style="color:#006d2c" target="_blank">EUCTR2021-001978-37-ES</a>', 
#         start = '16/04/2021', end = '16/04/2022', stage = "Phase IV", use="Yes") %>% 
# 
# add separate timeline inputs for combined Oxford/Gamaleya trials
# add_row(group = "Gamaleya Research Institute", subgroup = "Vector (non-replicating)", 
#         content = '<b>ChAdOx1-S/Gam-COVID-Vac prime-boost</b><br>Phase I/II, Pending <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04684446" style="color:#006d2c" target="_blank">NCT04684446</a>', 
#         start = '31/08/2021', end = '08/04/2022', stage = "Phase III", use="Yes") %>% 
# add_row(group = "Gamaleya Research Institute", subgroup = "Vector (non-replicating)", 
#         content = '<b>ChAdOx1-S/Gam-COVID-Vac prime-boost</b><br>Phase II, Azerbaijan <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04686773" style="color:#006d2c" target="_blank">NCT04686773</a>', 
#         start = '10/02/2021', end = '09/04/2021', stage = "Phase III", use="Yes") %>% 
# add_row(group = "Gamaleya Research Institute", subgroup = "Vector (non-replicating)", 
#         content = '<b>ChAdOx1-S/Gam-COVID-Vac prime-boost</b><br>Phase II, Azerbaijan <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04760730" style="color:#006d2c" target="_blank">NCT04760730</a>', 
#         start = '17/03/2021', end = '01/05/2021', stage = "Phase III", use="Yes") %>% 
# add timeline input for phase IV NCT04833101
# add_row(group = "Anhui Zhifei Longcom Biopharmaceutical<br>Chinese Academy of Sciences", subgroup = "Protein subunit", 
#         content = '<b>Ad5-nCoV/ZF2001</b><br>Phase IV, China <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04833101" style="color:#006d2c" target="_blank">NCT04833101</a>', 
#         start = '07/04/2021', end = '15/06/2021', stage = "Phase IV", use="Yes") %>% 
#
# add timeline input for phase II NCT04860739
# add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
#         content = '<b>BNT162 (b2)/ChAdOx1-S</b><br>Phase II, Spain <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04860739" style="color:#006d2c" target="_blank">NCT04860739</a><br><a href="https://www.thelancet.com/journals/lancet/article/PIIS0140-6736(21)01420-3/fulltext" style="color:#006d2c" target="_blank">Borobia; Lancet 2021</a>', 
#         start = '24/04/2021', end = '20/05/2021', stage = "Phase IV", use="Yes", pub="yes") %>% 
#
# add timeline input for phase IV NCT04878211
# add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
#         content = '<b>BNT162/mRNA-1273</b><br>Phase IV, Pending <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04878211" style="color:#006d2c" target="_blank">NCT04878211</a>', 
#         start = '31/03/2021', end = '26/11/2021', stage = "Phase IV", use="Yes") %>% 
#
# add timeline input for NCT04900467
# add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
#         content = '<b>BNT162/mRNA-1273</b><br>Not specified, France <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04900467" style="color:#006d2c" target="_blank">NCT04900467</a>', 
#         start = '28/05/2021', end = '31/08/2021', stage = "Phase IV", use="Yes") %>% 
# 
# add timeline input for NCT04907331
# add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
#         content = '<b>BNT162/ChAdOx1-S</b><br>Phase II, Austria <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04907331" style="color:#006d2c" target="_blank">NCT04907331</a>', 
#         start = '10/05/2021', end = '30/11/2021', stage = "Phase IV", use="Yes") %>% 
# 
# add timeline input for ISRCTN73765130
# add_row(group = "CureVac", subgroup = "RNA", 
#         content = '<b>BNT162/CVnCoV/ChAdOx1-S/mRNA-1273/NVX-CoV2373/VLA2001</b><br>Phase II, UK <i>(Not yet recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN73765130" style="color:#006d2c" target="_blank">ISRCTN73765130</a>', 
#         start = '03/06/2021', end = '01/08/2022', stage = "Phase III", use="No") %>% 
# add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
#         content = '<b>BNT162/CVnCoV/ChAdOx1-S/mRNA-1273/NVX-CoV2373/VLA2001</b><br>Phase II, UK <i>(Not yet recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN73765130" style="color:#006d2c" target="_blank">ISRCTN73765130</a>', 
#         start = '03/06/2021', end = '01/08/2022', stage = "Phase IV", use="Yes") %>% 
# add_row(group = "Novavax", subgroup = "Protein subunit", 
#         content = '<b>BNT162/CVnCoV/ChAdOx1-S/mRNA-1273/NVX-CoV2373/VLA2001</b><br>Phase II, UK <i>(Not yet recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN73765130" style="color:#006d2c" target="_blank">ISRCTN73765130</a>', 
#         start = '03/06/2021', end = '01/08/2022', stage = "Phase III", use="No") %>% 
# add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
#         content = '<b>BNT162/CVnCoV/ChAdOx1-S/mRNA-1273/NVX-CoV2373/VLA2001</b><br>Phase II, UK <i>(Not yet recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN73765130" style="color:#006d2c" target="_blank">ISRCTN73765130</a>', 
#         start = '03/06/2021', end = '01/08/2022', stage = "Phase IV", use="Yes") %>% 
# add_row(group = "Valneva<br>Dynavax", subgroup = "Inactivated", 
#         content = '<b>BNT162/CVnCoV/ChAdOx1-S/mRNA-1273/NVX-CoV2373/VLA2001</b><br>Phase II, UK <i>(Not yet recruiting)</i><br><a href="https://www.isrctn.com/ISRCTN73765130" style="color:#006d2c" target="_blank">ISRCTN73765130</a>', 
#         start = '03/06/2021', end = '01/08/2022', stage = "Phase III", use="No") %>% 
#
# add timeline input for NCT04927936
# add_row(group = "Janssen Pharmaceutical Companies", subgroup = "Vector (non-replicating)", 
#         content = '<b>BNT162/Ad26.COV2.S/mRNA-1273</b><br>Phase II, Netherlands <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04927936" style="color:#006d2c" target="_blank">NCT04927936</a>', 
#         start = '25/06/2021', end = '30/09/2022', stage = "Phase IV", use="Yes") %>% 
# add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
#         content = '<b>BNT162/Ad26.COV2.S/mRNA-1273</b><br>Phase II, Netherlands <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04927936" style="color:#006d2c" target="_blank">NCT04927936</a>', 
#         start = '25/06/2021', end = '30/09/2022', stage = "Phase IV", use="Yes") %>% 
#
# add timeline input for NCT04944381
# add_row(group = "Stemirna Therapeutics Co Ltd<br>Shanghai East Hospital", subgroup = "RNA", 
#         content = '<b>CAMS vaccine/mRNACOVID-19</b><br>Not specified, Pending <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04944381" style="color:#006d2c" target="_blank">NCT04944381</a>', 
#         start = '02/07/2021', end = '02/08/2021', stage = "Phase I", use="No") %>% 
#
# add timeline input for NCT04952727
# add_row(group = "CanSino Biological Inc<br>Beijing Institute of Biotechnology", subgroup = "Vector (non-replicating)", 
#         content = '<b>BBIBP-CorV/Ad5-nCoV</b><br>Phase IV, China <i>(Not yet recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04952727" style="color:#006d2c" target="_blank">NCT04952727</a>', 
#         start = '30/07/2021', end = '27/08/2021', stage = "Phase IV", use="Yes") %>% 
# 
# add timeline input for NCT04889209
# add_row(group = "Moderna<br>NIAID", subgroup = "RNA", 
#         content = '<b>Ad26.COV2.S/mRNA-1273</b><br>Phase I/II, USA <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04889209" style="color:#006d2c" target="_blank">NCT04889209</a>', 
#         start = '28/05/2021', end = '28/05/2023', stage = "Phase IV", use="Yes") %>% 
# 
# add timeline input for NCT04889209
# add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
#         content = '<b>Gam-COVID-Vac/ChAdOx1-S/BBIBP-CorV</b><br>Phase II, Argentina <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04962906" style="color:#006d2c" target="_blank">NCT04962906</a>', 
#         start = '05/07/2021', end = '05/08/2021', stage = "Phase IV", use="Yes") %>% 
# add_row(group = "Beijing Institute of Biological Products<br>Sinopharm", subgroup = "Inactivated", 
#         content = '<b>Gam-COVID-Vac/ChAdOx1-S/BBIBP-CorV</b><br>Phase II, Argentina <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04962906" style="color:#006d2c" target="_blank">NCT04962906</a>', 
#         start = '05/07/2021', end = '05/08/2021', stage = "Phase IV", use="Yes") %>% 
#  
# add timeline input for NCT04983537
# add_row(group = "University of Oxford<br>AstraZeneca", subgroup = "Vector (non-replicating)", 
#         content = '<b>Gam-COVID-Vac/ChAdOx1-S/BBIBP-CorV</b><br>Phase II, Argentina <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04983537" style="color:#006d2c" target="_blank">NCT04983537</a>', 
#         start = '26/07/2021', end = '26/09/2021', stage = "Phase IV", use="Yes") %>% 
# add_row(group = "Beijing Institute of Biological Products<br>Sinopharm", subgroup = "Inactivated", 
#         content = '<b>Gam-COVID-Vac/ChAdOx1-S/BBIBP-CorV</b><br>Phase II, Argentina <i>(Recruiting)</i><br><a href="https://clinicaltrials.gov/ct2/show/NCT04983537" style="color:#006d2c" target="_blank">NCT04983537</a>', 
#         start = '26/07/2021', end = '26/09/2021', stage = "Phase IV", use="Yes")  %>% 


# set factor levels
timeline$subgroup = factor(timeline$subgroup, levels=c("RNA", "DNA", "Vector (non-replicating)", "Vector (replicating)", "Inactivated", "Live-attenuated",
                                                       "Protein subunit", "Virus-like particle", "Other/Unknown", "Heterologous"))

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
pal_10 = brewer.pal(9, "Greys")[c(6:9,3)] # Other/unknown

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
timeline$style[timeline$subgroup=="Heterologous"] = paste0("font-size:12px;border-color:",pal_10[5],";background-color:",pal_10[1],";color:",pal_10[5],";")

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
timeline$style[timeline$subgroup=="RNA" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_1[1],";background-color:",pal_1[5],";color:",pal_1[1],";")
timeline$style[timeline$subgroup=="DNA" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_2[1],";background-color:",pal_2[5],";color:",pal_2[1],";")
timeline$style[timeline$subgroup=="Vector (non-replicating)" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_3[1],";background-color:",pal_3[5],";color:",pal_3[1],";")
timeline$style[timeline$subgroup=="Vector (replicating)" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_4[1],";background-color:",pal_4[5],";color:",pal_4[1],";")
timeline$style[timeline$subgroup=="Inactivated" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_5[1],";background-color:",pal_5[5],";color:",pal_5[1],";")
timeline$style[timeline$subgroup=="Live-attenuated" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_6[1],";background-color:",pal_6[5],";color:",pal_6[1],";")
timeline$style[timeline$subgroup=="Protein subunit" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_7[1],";background-color:",pal_7[5],";color:",pal_7[1],";")
timeline$style[timeline$subgroup=="Virus-like particle" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_8[1],";background-color:",pal_8[5],";color:",pal_8[1],";")
timeline$style[timeline$subgroup=="Other/Unknown" & grepl(" IV", timeline$content)] = paste0("font-size:12px;border-color:",pal_9[1],";background-color:",pal_9[5],";color:",pal_9[1],";")

# add style for terminated timeline row
timeline$style[grepl("Programme halted", timeline$content)] = paste0("font-size:12px;border-color:",pal_9[5],";background-color:",pal_9[1],";color:",pal_9[5],";")

# amend hyperlink colour for subsets with dark backgrounds
timeline$content[grepl(" IV", timeline$content)] = str_replace_all(timeline$content[grepl(" IV", timeline$content)], "#006d2c", "#99d8c9")
timeline$content[timeline$subgroup=="Heterologous"] = str_replace_all(timeline$content[timeline$subgroup=="Heterologous"], "#006d2c", "#99d8c9")
timeline$content[timeline$subgroup=="Live-attenuated"] = str_replace_all(timeline$content[timeline$subgroup=="Live-attenuated"], "#006d2c", "#99d8c9")
timeline$content[timeline$subgroup=="DNA"] = str_replace_all(timeline$content[timeline$subgroup=="DNA"], "#006d2c", "#99d8c9")
timeline$content[timeline$subgroup=="Virus-like particle"] = str_replace_all(timeline$content[timeline$subgroup=="Virus-like particle"], "#006d2c", "#99d8c9")
timeline$content[timeline$subgroup=="Vector (replicating)"] = str_replace_all(timeline$content[timeline$subgroup=="Vector (replicating)"], "#006d2c", "#99d8c9")
timeline$content[timeline$subgroup=="RNA" & grepl("III", timeline$content)] = str_replace_all(timeline$content[timeline$subgroup=="RNA" & grepl("III", timeline$content)], "#006d2c", "#99d8c9")
timeline$content[timeline$subgroup=="Inactivated" & grepl("III", timeline$content)] = str_replace_all(timeline$content[timeline$subgroup=="Inactivated" & grepl("III", timeline$content)], "#006d2c", "#99d8c9")
timeline$content[timeline$subgroup=="Protein subunit" & grepl("III", timeline$content)] = str_replace_all(timeline$content[timeline$subgroup=="Protein subunit" & grepl("III", timeline$content)], "#006d2c", "#99d8c9")
timeline$content[grepl("Programme halted", timeline$content)] = str_replace_all(timeline$content[grepl("Programme halted", timeline$content)], "#99d8c9", "#006d2c")

### Summary plot --------------------------------------------------------------------

# summary inputs for ui
landscape_all = landscape
landscape = subset(landscape_all, Phase!="Terminated")
total_count = nrow(landscape)
clinical_count = sum(landscape$Phase!="Pre-clinical")

# combine phases II/III with phase III for plotting purposes
landscape$Phase[landscape$Phase=="Phase II/III"] = "Phase III"
landscape$Phase[landscape$Phase=="Phase I/II/III"] = "Phase III"

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
summary = subset(summary, Group!="Heterologous") %>% droplevels()
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
