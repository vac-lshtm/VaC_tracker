### COVID-19 vaccine tracker
### Vaccine Centre, London School of Hygiene & Tropical Medicine
### Contact: Edward Parker, edward.parker@lshtm.ac.uk

### Living review feature inputs



# load data
db = data.frame(read_excel("input_data/VaC_LSHTM_living_review_data.xlsx", range="A2:DD1000"))
living_review_study_count = nrow(fread("input_data/VaC_LSHTM_eligible_studies.csv"))
names(db) = str_replace_all(names(db), "\\.", "") 

# Add html tags for printing developer names and vaccine doses to datatable
db$Developers = str_replace_all(db$Developers, "/", "<br/>") 
db$Doses = str_replace_all(db$Doses, ";", "<br/>")
db$Control = str_replace_all(db$Control, ";", "<br/>")
db$Control = str_replace_all(db$Control, ";", "<br/>")
db$Efficacypopulationprofile = str_replace_all(db$Efficacypopulationprofile, ";", "<br/>")
db$Totalenrolledn = str_replace_all(db$Totalenrolledn, ";", "<br/>")
db$Numberofdoses = str_replace_all(db$Numberofdoses, "; ", "<br/>") 
db$Descriptionofvaccine = str_replace_all(db$Descriptionofvaccine, "\\^10", "<sup>10</sup>")
db$Doses = str_replace_all(db$Doses, "\\^10", "<sup>10</sup>")
db$Doses = str_replace_all(db$Doses, "\\^11", "<sup>11</sup>")
db$Nextstepsproposed = str_replace_all(db$Nextstepsproposed, "\\^10", "<sup>10</sup>") 
db$Nextstepsproposed = str_replace_all(db$Nextstepsproposed, "\\^11", "<sup>11</sup>")
trial_list = unique(db$Identifier[!is.na(db$Identifier)])
db$ResponseratenN_plot = str_replace_all(db$ResponseratenN, " \\(", "\n(") 

# remove commas from numeric inputs
db$Midpost = as.numeric(gsub(",","",db$Midpost))
db$Lowerpost = as.numeric(gsub(",","",db$Lowerpost))
db$Upperpost = as.numeric(gsub(",","",db$Upperpost))
db$Midpre = as.numeric(gsub(",","",db$Midpre))
db$Lowerpre = as.numeric(gsub(",","",db$Lowerpre))
db$Upperpre = as.numeric(gsub(",","",db$Upperpre))

# create starting lists for drop-down menus
db_trial1 = subset(db, Identifier==db$Identifier[1])
outcome_list = unique(db_trial1$Outcome[db_trial1$Group=="Antibody"])
outcome_list_T = unique(db_trial1$Outcome[db_trial1$Group=="T-cell"])
outcome_list_efficacy = unique(db_trial1$Efficacyendpoint)
outcome_list_subgroup = "Not applicable"

