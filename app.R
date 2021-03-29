### COVID-19 vaccine tracker
### Vaccine Centre, London School of Hygiene & Tropical Medicine
### Contact: Edward Parker, edward.parker@lshtm.ac.uk

### Shiny app code

### LOAD PACKAGES ---------------------------------------------------------------------------------
if(!require(data.table)) install.packages("data.table", repos = "http://cran.us.r-project.org")
if(!require(DT)) install.packages("DT", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(plotly)) install.packages("plotly", repos = "http://cran.us.r-project.org")
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(shinythemes)) install.packages("shinythemes", repos = "http://cran.us.r-project.org")
if(!require(stringr)) install.packages("stringr", repos = "http://cran.us.r-project.org")
if(!require(stringi)) install.packages("stringi", repos = "http://cran.us.r-project.org")
if(!require(timevis)) install.packages("timevis", repos = "http://cran.us.r-project.org")
if(!require(RColorBrewer)) install.packages("RColorBrewer", repos = "http://cran.us.r-project.org")
if(!require(shinydashboard)) install.packages("shinydashboard", repos = "http://cran.us.r-project.org")
if(!require(writexl)) install.packages("writexl", repos = "http://cran.us.r-project.org")
if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org")
if(!require(readxl)) install.packages("readxl", repos = "http://cran.us.r-project.org")
if(!require(shinyWidgets)) install.packages("shinyWidgets", repos = "http://cran.us.r-project.org")
if(!require(cowplot)) install.packages("cowplot", repos = "http://cran.us.r-project.org")
if(!require(BiocManager)) install.packages("BiocManager", repos = "http://cran.us.r-project.org")
if(!require(leaflet)) install.packages("leaflet", repos = "http://cran.us.r-project.org")
if(!require(geojsonio)) install.packages("geojsonio", repos = "http://cran.us.r-project.org")
options(repos = BiocManager::repositories())
if(!require(ComplexHeatmap)) install.packages("ComplexHeatmap", repos = "https://bioconductor.org")
if(!require(scales)) install.packages("scales", repos = "https://bioconductor.org")



### Generate landscape inputs for each layer -------------------------------------------------------------------------------------
update_full = "29 March 2021"
update_equity = "29 March 2021"
source("input_code/VaC_landscape.R")
source("input_code/VaC_efficacy_map.R")
source("input_code/VaC_living_review.R")
source("input_code/VaC_implementation.R")

# additional code to update case counts for weekly updates
#source("input_code/VaC_jhu_daily_cases.R")

# update manual components for ui
table(landscape$Phase)
table(landscape$Platform)
table(landscape$In.use)



### UI -------------------------------------------------------------------------------------
ui <- bootstrapPage(
  tags$head(includeHTML("gtag.html")),
  navbarPage(theme = shinytheme("flatly"), collapsible = TRUE,
             HTML('<a style="text-decoration:none;cursor:default;color:#FFFFFF;" class="active" href="#">COVID-19 vaccine tracker</a>'), id="nav",
             windowTitle = "COVID-19 vaccine tracker",
             
             #################
             ### HOME PAGE ###
             #################            
             
             tabPanel("Home",
                      tags$div(
                        "Last updated on ",tags$b(paste0(update_equity,".")),tags$br(),tags$br(),
                        
                        #tags$b("*** Update:"),"See",tags$b("Implementation"),"tab for new feature tracking the equity of vaccine roll-out.",tags$b("***"),tags$br(),tags$br(),
                        
                        "The COVID-19 pandemic has prompted numerous research institutes and companies to develop vaccine candidates targeting this novel disease.",
                        tags$br(),tags$br(),
                        
                        "First launched in April 2020, this tracker was developed by the", a("Vaccine Centre", href="https://www.lshtm.ac.uk/research/centres/vaccine-centre", target="_blank"),
                        "at the", a("London School of Hygiene & Tropical Medicine", href="https://www.lshtm.ac.uk", target="_blank"), "to follow candidates as they progress through the development pipeline.",
                        "Read our", a("Correspondence", href="https://www.thelancet.com/journals/langlo/article/PIIS2214-109X(21)00043-7/fulltext", target="_blank"),"in",em("Lancet Global Health"),"for further details.",
                        tags$br(),tags$br(),
                        
                        "All data and code are available via the LSHTM Vaccine Centre's", tags$a(href="https://github.com/vac-lshtm/VaC_tracker", "Github page.", target="_blank"),
                        tags$br(),tags$br(),
                        
                        "Citation details: Shrotri, Swinnen, Kampmann, Parker (2021). An interactive website tracking COVID-19 vaccine development.",tags$i("Lancet Glob Health;"),"epub ahead of print.",
                        tags$br(),tags$br(),
                        
                        actionButton("twitter_share", label = "Share", icon = icon("twitter"),class = "btn btn-warning",
                                     onclick = sprintf("window.open('%s')", 
                                                       "https://twitter.com/intent/tweet?text=%20Keep%20up%20with%20the%20latest%20COVID-19%20vaccine%20developments%20with%20the%20@LSHTM_Vaccines%20tracker&url=https://vac-lshtm.shinyapps.io/ncov_vaccine_landscape/")),
                        tags$br(),
                        
                        tags$hr(style="border-color: black;"),
                        fluidRow(
                          box(width = 4,
                              h3("Vaccine landscape", align="center"), 
                              HTML('<div class="text-center"><i class="fa fa-syringe fa-4x"></i></div>'),
                              tags$p("Summary of vaccine candidates and trial timelines", align="center"),
                              HTML("<div class=\"text-center\"><button class=\"btn btn-primary\" onclick=\"$('li:eq(1) a').tab('show');\" role=\"button\">View landscape</button></div>"),
                              tags$br()
                          ),
                          box(width = 4,
                              h3("Clinical trials database", align="center"),
                              HTML("<div class=\"text-center\"><i class=\"fas fa-clipboard-check fa-4x\"></i></div>"),
                              tags$p("Key attributes of registered COVID-19 vaccine trials", align="center"),
                              HTML("<div class=\"text-center\"><button class=\"btn btn-primary\" onclick=\"$('li:eq(2) a').tab('show');\" role=\"button\">View trials</button></div>"),
                              tags$br()
                          ),
                          h3("Efficacy trial map", align="center"),
                          HTML("<div class=\"text-center\"><i class=\"fas fa-globe-africa fa-4x\"></i></div>"),
                          tags$p("Map of planned and ongoing phase III trials", align="center"),
                          HTML("<div class=\"text-center\"><button class=\"btn btn-primary\" onclick=\"$('li:eq(3) a').tab('show');\" role=\"button\">View map</button></div>"),
                          tags$br()                          
                        ),
                        fluidRow(
                          box(width = 4,
                              h3("Living review", align="center"),
                              HTML("<div class=\"text-center\"><i class=\"fas fa-chart-line fa-4x\"></i></div>"),
                              tags$p("Published data on safety, immunogenicity, and efficacy", align="center"),
                              HTML("<div class=\"text-center\"><button class=\"btn btn-primary\" onclick=\"$('li:eq(4) a').tab('show');\" role=\"button\">View data</button></div>"),
                              tags$br()
                          ),
                          box(width = 4,
                              h3("Implementation", align="center"),
                              HTML("<div class=\"text-center\"><i class=\"fas fa-cart-plus fa-4x\"></i></div>"),
                              tags$p("Summary of vaccine distribution information", align="center"),
                              HTML("<div class=\"text-center\"><button class=\"btn btn-primary\" onclick=\"$('li:eq(5) a').tab('show');\" role=\"button\">View summary</button></div>"),
                              tags$br()
                          ),
                          box(width = 4,
                              h3("FAQs", align="center"),
                              HTML("<div class=\"text-center\"><i class=\"fas fa-question fa-4x\"></i></div>"),
                              tags$p("More on the vaccine development process", align="center"),
                              HTML("<div class=\"text-center\"><button class=\"btn btn-primary\" onclick=\"$('li:eq(6) a').tab('show');\" role=\"button\">View FAQs</button></div>"),
                              tags$br()
                          )
                        ),
                        tags$br(),tags$hr(style="border-color: black;"),
                        tags$br(),tags$br(),
                        HTML('<center><img src="vac_dark.png" width="150px" height="75px"></center>'),
                        tags$br(),tags$br(),
                        HTML('<center><img src="lshtm_dark.png" width="150px" height="75px"></center>'),
                        tags$br(),tags$br()
                      )
             ),
             
             
             
             ######################
             ### LANDSCAPE PAGE ###
             ######################            
             
             tabPanel("Landscape",
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     box(width = 6, 
                                         h4(total_count, align="center"), 
                                         HTML('<div class="text-center"><i class="fa fa-syringe fa-2x"></i></div>'),
                                         tags$p("vaccine candidates", align="center", style="font-size:14px;")
                                     ),
                                     
                                     box(width = 6, 
                                         h4(clinical_count, align="center"), 
                                         HTML('<div class="text-center"><i class="fa fa-user-friends fa-2x"></i></div>'),
                                         tags$p("in clinical testing", align="center", style="font-size:14px;")
                                     ),
                                     
                                     # create space behind boxes
                                     tags$br(),tags$br(),tags$br(),tags$br(),tags$br(),tags$br(),
                                     
                                     checkboxGroupInput(inputId = "stage",
                                                        label = "Stage of development",
                                                        choices = c("Terminated (4)" = "term",
                                                                    "Pre-clinical (225)" = "preclin",
                                                                    "Phase I (27)" = "phasei",
                                                                    "Phase I/II (25)" = "phasei_ii",
                                                                    "Phase II (5)" = "phaseii",
                                                                    "Phase III (21)" = "phaseiii",
                                                                    "Phase IV (5)" = "phaseiv"),
                                                        selected = c("phasei", "phasei_ii", "phaseii", "phaseiii", "phaseiv")),
                                     tags$br(),
                                     
                                     checkboxGroupInput(inputId = "in_use",
                                                        label = "In use",
                                                        choices = c("No (299)" = "not_in_use",
                                                                    "Yes (13)" = "in_use"),
                                                        selected = c("not_in_use", "in_use")),
                                     tags$br(),
                                     
                                     checkboxGroupInput(inputId = "vacc",
                                                        label = "Vaccine type",
                                                        choices = c("RNA (38)" = "rna",
                                                                    "DNA (26)" = "dna",
                                                                    "Vector (non-replicating) (38)" = "nrvv",
                                                                    "Vector (replicating) (25)" = "rvv",
                                                                    "Inactivated (21)" = "inact",
                                                                    "Live-attenuated (3)" = "live", 
                                                                    "Protein subunit (101)" = "ps",
                                                                    "Virus-like particle (23)" = "vlp",
                                                                    "Other/Unknown (37)" = "unknown"),
                                                        selected = c("rna", "dna", "inact", "nrvv", "rvv", "live", "ps", "vlp", "unknown")),
                                     tags$br(),
                                     
                                     tags$b("Colour code for vaccine type"),tags$br(),
                                     span("RNA", style="color:#9ECAE1"),tags$br(),
                                     span("DNA", style="color:#2171B5"),tags$br(),
                                     span("Vector (non-replicating)", style="color:#FDAE6B"),tags$br(),
                                     span("Vector (replicating)", style="color:#D94801"),tags$br(),
                                     span("Inactivated", style="color:#A1D99B"),tags$br(),
                                     span("Live-attenuated", style="color:#238B45"),tags$br(),
                                     span("Protein subunit", style="color:#BCBDDC"),tags$br(),
                                     span("Virus-like particle", style="color:#6A51A3"),tags$br(),
                                     span("Other/Unknown", style="color:#BDBDBD")     
                        ), 
                        
                        mainPanel(
                          "Last updated on ", tags$b(paste0(update_full,".")),
                          tags$br(),tags$br(),
                          
                          "We currently update the vaccine landscape weekly, pooling the latest information from the", 
                          tags$a(href="https://www.who.int/publications/m/item/draft-landscape-of-covid-19-candidate-vaccines", "WHO,", target="_blank"),
                          "the ",tags$a(href="https://milken-institute-covid-19-tracker.webflow.io", "Milken Institute", target="_blank"), 
                          "and ", tags$a(href="https://clinicaltrials.gov", "clinicaltrials.gov.", target="_blank"), 
                          "We are also grateful for additional information provided directly by vaccine developers.",
                          tags$br(),tags$br(),
                          
                          "All data and code are available via the LSHTM Vaccine Centre's", tags$a(href="https://github.com/vac-lshtm/VaC_tracker", "Github page.", target="_blank"),
                          tags$br(),tags$br(),
                          
                          "If you have any queries or wish to inform us of a candidate that is not included, please contact", HTML('<a href = "mailto: vaccines@lshtm.ac.uk">vaccines@lshtm.ac.uk.</a>'),
                          tags$br(),tags$br(),
                          
                          tabsetPanel(
                            tabPanel("Full pipeline", timevisOutput("vaccine_timeline")),
                            tabPanel("Summary", plotOutput("summary_plot", height="400px", width="600px"),
                                     "Candidates listed above as being in phase III include several undergoing combined phase II/III trials.")
                          )
                        )
                      )
             ),
             
             
             
             ################################
             ### CLINICAL TRIALS DATABASE ###
             ################################
             
             tabPanel("Clinical trials",
                      "Last updated on ", tags$b(paste0(update_full,".")),
                      tags$br(),tags$br(),
                      
                      "Each week, we search", tags$a(href="https://clinicaltrials.gov", "clinicaltrials.gov", target="_blank"), 
                      "for studies of COVID-19 vaccine candidates and extract key attributes from the registered protocols.
                      Additional trials are identified using the", tags$a(href="https://www.who.int/publications/m/item/draft-landscape-of-covid-19-candidate-vaccines", "WHO COVID-19 vaccine landscape.", target="_blank"),
                      "Trials are listed by decreasing size. Only trials with a registered protocol are included.",
                      tags$br(),tags$br(),
                      
                      pickerInput("trial_select_subset", h4("Select subset:"),
                                  choices = c("All trials", "Trials involving pregnant women", "Trials involving <18s", "Heterologous prime-boost trials"),
                                  selected = "All trials",
                                  multiple = FALSE),
                      tags$br(),
                      
                      DT::dataTableOutput("trial_table", width="100%"),
                      tags$br(),
                      
                      tags$b("Abbreviations:"),
                      tags$p(
                        "aAPC: artificial antigen presenting cell;
                        AZLB: Anhui Zhifei Longcom Biopharmaceutical;
                        BIBP: Beijing Institute of Biological Products; 
                        BWBP: Beijing Wantai Biological Pharmacy;
                        CAMS: Chinese Academy of Medical Sciences; 
                        FBRI SRC VB: Federal Budgetary Research Institution State Research Center of Virology and Biotechnology;
                        KBP: Kentucky BioProcessing;
                        LV-SMENP-DC: vaccine comprising dendritic cells (DCs) modified with lentivirus (LV) vectors expressing 'SMENP' minigene;
                        PLA-AMS: People's Liberation Army Academy of Military Science; 
                        SGMI: Shenzhen Geno-Immune Medical Institute; 
                        WIBP: Wuhan Institute of Biological Products.", style="font-size:13px;"),
                      tags$br(),
                      downloadButton("downloadCsv", "Download data", class="download_button"), 
                      tags$br(),tags$br()
                      ),
             
             
             
             ######################
             ### TRIAL MAP PAGE ###
             ######################
             
             tabPanel("Trial map",
                      div(class="outer",
                          tags$head(includeCSS("styles.css")),
                          leafletOutput("efficacy_map", width="100%", height="100%"),
                          
                          absolutePanel(id = "controls", class = "panel panel-default",
                                        top = 75, left = 55, width = 260, fixed=TRUE,
                                        draggable = TRUE, height = "auto",
                                        
                                        actionButton('plotBtn', HTML('<i class="fa fa-bars fa"></i>'), "class"='btn btn-link btn-sm', "data-toggle"='collapse',
                                                     "data-target"="#controls_collapse"),
                                        
                                        tags$div(id = 'controls_collapse', class = "collapse in",
                                                 tags$i("Phase III trials with N >1000 included."), tags$br(),
                                                 pickerInput("mapper_vaccine_select", h4("Select vaccine:"),
                                                             choices = as.character(unique(trials$Vaccine)),
                                                             selected = as.character(unique(trials$Vaccine))[1],
                                                             multiple = FALSE),
                                                 pickerInput("mapper_location_select", h4("Selection location:"),
                                                             choices = as.character(unique(trials$Location[trials$Trial==trials$Trial[1]])),
                                                             selected = as.character(trials$Location[1]),
                                                             multiple = FALSE),
                                                 
                                                 strong("Protocol:"),htmlOutput("mapper_trial_number", inline = T), tags$br(),
                                                 strong("Target N (total):"),textOutput("mapper_trial_n", inline = T), tags$br(),
                                                 strong("N doses:"),textOutput("mapper_trial_n_doses", inline = T), tags$br(),
                                                 strong("Status:"),htmlOutput("mapper_country_status", inline=T), tags$br(),
                                                 strong("Start date:"),textOutput("mapper_trial_start_date", inline=T), tags$br(),
                                                 htmlOutput("mapper_trial_status", inline = T),
                                                 htmlOutput("mapper_status_update_date", inline = T),
                                                 tags$br(),
                                                 
                                                 em("Case counts (rolling 7-day average):"),
                                                 plotOutput("mapper_country_plot", height="180px"),
                                                 a("Source for case counts", href="https://vac-lshtm.shinyapps.io/ncov_tracker/", target="_blank")
                                        )
                          )
                      )
             ),
             
             
             
             ##########################
             ### LIVING REVIEW PAGE ###
             ##########################
             
             tabPanel("Living review",
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     
                                     pickerInput("select_phase", "Phase:",   
                                                 choices = as.character(c("I/II", "III")), 
                                                 options = list(`actions-box` = TRUE),
                                                 selected = "III",
                                                 multiple = FALSE),
                                     
                                     pickerInput("select_trial", "Trial:",   
                                                 choices = as.character(subset(db, Phasegroup=="III")$Identifier), 
                                                 options = list(`actions-box` = TRUE),
                                                 selected = as.character(subset(db, Phasegroup=="III")$Identifier)[1],
                                                 multiple = FALSE),
                                     
                                     tags$strong("Developer(s):"), htmlOutput("trial_developer"), tags$br(),
                                     tags$strong("Vaccine:"), textOutput("trial_vaccine"), tags$br(),
                                     tags$strong("Platform:"), textOutput("trial_platform"), tags$br(),
                                     tags$strong("Phase:"), textOutput("trial_phase", inline = T), tags$br(), tags$br(),
                                     strong("Number(s):"),htmlOutput("trial_number"), tags$br(),
                                     strong("Location(s):"),textOutput("trial_location"), tags$br(),
                                     strong("Primary report:"),htmlOutput("trial_report"), tags$br(),
                                     strong("Publication date:"),textOutput("trial_publication_date"), tags$br()
                                     
                        ), 
                        
                        mainPanel(
                          tabsetPanel(
                            tabPanel("Methods",
                                     tags$br(),
                                     
                                     "Last updated on ",tags$b(paste0(update_full,".")),
                                     tags$br(),tags$br(),
                                     
                                     tags$h4("Approach"),
                                     "This living review summarises the available clinical trial data on different COVID-19 vaccine candidates. 
                                     Since 24 August 2020, we have performed a weekly search of",strong(em("medRxiv")),"and",strong("PubMed"),
                                     "(see", tags$b("Search log"),"below) using the R packages",em("medrxivr"),"and",em("easyPubMed."),
                                     "Titles and abstracts are screened to identify articles reporting outcome data from human clinical trials of COVID-19 vaccine candidates.",
                                     "Additional preprints are identified using the", tags$a(href="https://www.who.int/publications/m/item/draft-landscape-of-covid-19-candidate-vaccines", "WHO COVID-19 vaccine landscape.", target="_blank"),
                                     tags$br(),tags$br(),
                                     
                                     tags$h4("Search term"),
                                     tags$em('"(coronavirus OR COVID OR SARS*) AND vaccin* AND (trial OR phase)"'),
                                     tags$br(),tags$br(),
                                     
                                     tags$h4("Data extraction"),
                                     "We extract data on the following study attributes:",
                                     tags$ul(
                                       tags$li(strong("Design:"),"location, number and age of individuals enrolled, vaccine dose, etc."),
                                       tags$li(strong("Safety profile:"),"serious adverse events as well as non-serious adverse events with ≥25% prevalence in one or more study groups."),
                                       tags$li(strong("Immunogenicity:"),"pre- and post-vaccination levels of antigen-specific IgG (ELISA), neutralising antibody levels against live SARS-CoV-2 and/or pseudoviruses, and/or T-cell responses.
                                               We present antibody and T-cell outcomes 28 days post-vaccination or the nearest available timepoint."),
                                       tags$li(strong("Efficacy:"),"protective efficacy against COVID-19, severe COVID-19, and/or asymptomatic SARS-CoV-2 infection. 
                                               Where available, we present the profile (age, ethnicity, and comorbidity prevalence) of the study population, as well as vaccine efficacy 
                                               estimates stratified by relevant covariates (dose regimen, age group, ethnicity, and presence of comorbidities)."),
                                       tags$li(strong("Planned next steps"),"for clinical testing and/or manufacture. See",strong("Implementation"),"tab for additional details.")
                                       ),
                                     "Data extraction is performed for all peer-reviewed manuscripts. Links are provided to all preprints.",
                                     tags$br(),tags$br(),
                                     
                                     tags$h4("Eligible studies"),
                                     "Total number of studies included: ", living_review_study_count,
                                     DT::dataTableOutput("eligible_studies", width="100%"),
                                     tags$br(),
                                     tags$b("Abbreviations:"),
                                     tags$p("BIBP: Beijing Institute of Biological Products; CAMS: Chinese Academy of Medical Sciences; WIBP: Wuhan Institute of Biological Products."), #, style="font-size:13px;"
                                     tags$b("Notes:"),
                                     tags$p("Phase I and phase II data extracted separately for WIBP inactivated vaccine (Xia; JAMA 2020), BBIBP-CorV (Xia; Lancet Infect Dis 2020), and Sinovac CoronaVac (Zhang; Lancet Infect Dis 2020)."
                                      #     Paper by Logunov et al (2021) had not been indexed on PubMed as of 01 Feb 2021 and is therefore not included in the search log below." 
                                     ),
                                     tags$br(),
                                     
                                     tags$h4("Search log"),
                                     DT::dataTableOutput("search_log", width="100%"),
                                     tags$br(), tags$br()
                                     
                                       ),
                            
                            tabPanel("Results",
                                     tags$br(),
                                     tags$h4("Description of vaccine"),
                                     htmlOutput("trial_vaccine_description"),
                                     
                                     tags$br(),tags$h4("Trial attributes"),
                                     DT::dataTableOutput("trial_attributes", width="100%"),                           
                                     
                                     conditionalPanel("input.select_phase == 'III'",
                                                      tags$br(),tags$h4("Vaccine efficacy"),
                                                      tags$em("We present protective efficacy against symptomatic COVID-19, severe COVID-19, and/or asymptomatic SARS-CoV-2 infection."),
                                                      tags$br(),tags$br(),
                                                      
                                                      htmlOutput("efficacy_endpoint_primary", inline = T),
                                                      htmlOutput("efficacy_endpoint_asymptomatic", inline = T),
                                                      htmlOutput("efficacy_endpoint_severe", inline = T),
                                                      tags$br(),
                                                      tabsetPanel(
                                                        tabPanel("Plot", 
                                                                 tags$br(),
                                                                 plotOutput("outcome_plot_efficacy", width = "900px",  height = "525px"), 
                                                                 tags$br()),
                                                        tabPanel("Table",
                                                                 fluidPage(style = "font-size: 85%; padding: 0px 0px; margin: 0%", DT::dataTableOutput("efficacy_table", width="100%")),
                                                                 tags$br()
                                                        ),
                                                        tabPanel("Population profile",
                                                                 DT::dataTableOutput("efficacy_population", width="100%"),
                                                                 tags$br()
                                                        )
                                                      ),
                                                      htmlOutput("efficacy_table_legend", inline = T),
                                                      tags$br()
                                     ),
                                     
                                     tags$br(),tags$h4("Safety profile"),
                                     tags$em("We present data on any",tags$strong("serious adverse events"),"(potentially life-threatening: requires assessment in A&E or hospitalisation) and", 
                                             tags$strong("common adverse events"),"(≥25% prevalence in one or more study groups) relating to the test vaccine."),
                                     tags$br(),tags$br(),
                                     
                                     tags$strong("Serious adverse events:"),tags$br(),
                                     textOutput("saes"),tags$br(),
                                     tags$strong("Common adverse events (local):"),
                                     htmlOutput("localaes"),tags$br(),
                                     tags$strong("Common adverse events (systemic):"),
                                     htmlOutput("systemicaes"),
                                     htmlOutput("safetyissue"),
                                     tags$br(),tags$br(),
                                     
                                     conditionalPanel("input.select_phase == 'I/II' | input.select_trial == 'Gamaleya Gam-COVID-Vac phase III' | input.select_trial == 'Oxford ChAdOx1 phase III (report 2; Voysey 2021)'",
                                                      tags$h4("Antibody response"),
                                                      tags$em("We present antibody levels measured 28 days post-vaccination or the nearest available timepoint. 
                                                              Where multiple types of antibody were measured, we prioritise (i) antigen-specific ELISA (IgG); 
                                                              (ii) neutralisation of live SARS-CoV-2; and (iii) neutralisation of a pseudovirus modified to express SARS-CoV-2 antigens."),
                                                      tags$br(),tags$br(),
                                                      
                                                      pickerInput("select_outcome", "Select outcome:",   
                                                                  choices = as.character(outcome_list), 
                                                                  options = list(`actions-box` = TRUE),
                                                                  selected = outcome_list[1],
                                                                  multiple = FALSE),
                                                      
                                                      htmlOutput("outcome_assay", inline = T),
                                                      htmlOutput("outcome_timing", inline = T),
                                                      htmlOutput("outcome_units", inline = T),
                                                      htmlOutput("outcome_binary", inline = T),
                                                      htmlOutput("outcome_extraction_flag", inline = T),
                                                      htmlOutput("outcome_small_group_flag", inline = T),
                                                      tags$br(),
                                                      
                                                      conditionalPanel("input.select_outcome != 'Not applicable'",
                                                                       tabsetPanel(
                                                                         tabPanel("Plot", plotOutput("outcome_plot", height = "350px")),
                                                                         tabPanel("Table",
                                                                                  DT::dataTableOutput("immunogenicity_table", width="100%"),
                                                                                  tags$br()
                                                                         )
                                                                       )
                                                      ),
                                                      
                                                      tags$br(),tags$h4("T cell response"),
                                                      
                                                      pickerInput("select_outcome_T", "Select outcome:",   
                                                                  choices = as.character(outcome_list_T), 
                                                                  options = list(`actions-box` = TRUE),
                                                                  selected = outcome_list_T[1],
                                                                  multiple = FALSE),
                                                      
                                                      htmlOutput("outcome_assay_T", inline = T),
                                                      htmlOutput("outcome_timing_T", inline = T),
                                                      htmlOutput("outcome_units_T", inline = T),
                                                      htmlOutput("outcome_binary_T", inline = T),
                                                      htmlOutput("outcome_extraction_flag_T", inline = T),
                                                      htmlOutput("outcome_small_group_flag_T", inline = T),
                                                      tags$br(),
                                                      
                                                      conditionalPanel("input.select_outcome_T != 'Not applicable'",
                                                                       tabsetPanel(
                                                                         tabPanel("Plot", plotOutput("outcome_plot_T", height = "350px")),
                                                                         tabPanel("Table",
                                                                                  DT::dataTableOutput("immunogenicity_table_T", width="100%"),
                                                                                  tags$br()
                                                                         )
                                                                       )
                                                      ),
                                                      htmlOutput("outcome_Th1_Th2", inline = T),
                                                      
                                                      conditionalPanel("input.select_outcome_subgroup != 'Not applicable'",
                                                                       tags$br(),
                                                                       tags$h4("Subgroup analysis"),
                                                                       htmlOutput("subgroup_text", inline = T),
                                                                       pickerInput("select_outcome_subgroup", "Select outcome:",   
                                                                                   choices = as.character(outcome_list_subgroup), 
                                                                                   options = list(`actions-box` = TRUE),
                                                                                   selected = outcome_list_subgroup[1],
                                                                                   multiple = FALSE),
                                                                       htmlOutput("outcome_assay_subgroup", inline = T),
                                                                       htmlOutput("outcome_timing_subgroup", inline = T),
                                                                       htmlOutput("outcome_units_subgroup", inline = T),
                                                                       htmlOutput("outcome_binary_subgroup", inline = T),
                                                                       
                                                                       DT::dataTableOutput("subgroup_table", width="100%"),
                                                                       htmlOutput("subgroup_conclusion", inline = T), 
                                                                       tags$br()
                                                      )
                                                      ),
                                     
                                     htmlOutput("other_cofactors", inline = T),
                                     htmlOutput("other_endpoints"),
                                     
                                     tags$br(),tags$h4("Next steps"),
                                     htmlOutput("trial_next_steps"),
                                     tags$br(),tags$br()
                                     )
                          )
                        )
                      )
             ),
             
             
             
             ###########################
             ### IMPLEMENTATION PAGE ###
             ###########################
             
             tabPanel("Implementation",
                      "Last updated on ",tags$b(paste0(update_equity,".")),
                      tags$br(),tags$br(),
                      
                      h4("Equity of vaccine roll-out"),
                      "Vaccines against COVID-19 are now being rolled out across the globe. However, we are falling considerably short of achieving equitable global distribution.
                      In the plot below, each circle represents a country, with circle size corresponding to population size. Hover over the circles for additional details.", 
                      tags$br(),tags$br(),
                      
                      sidebarLayout(
                        sidebarPanel(width = 3,
                                     
                                     pickerInput("equity_outcome", h5("Select outcome:"),   
                                                 choices = c("% vaccinated with at least 1 dose", "% fully vaccinated", "Total vaccines per hundred people"), # "Total vaccines" 
                                                 selected = c("% vaccinated with at least 1 dose"),
                                                 multiple = FALSE),
                                     
                                     checkboxGroupInput(inputId = "equity_group",
                                                        label = h5("Select income group:"),
                                                        choices = c("High income" = "hic",
                                                                    "Upper middle income" = "umic",
                                                                    "Lower middle income" = "lmic",
                                                                    "Low income" = "lic"),
                                                        selected = c("hic", "umic", "lmic", "lic")),
                                     
                                     sliderTextInput("equity_date",
                                                     label = h5("Select date:"),
                                                     choices = format(unique(equity_slider), "%d %b %y"),
                                                     selected = format(max(equity_slider), "%d %b %y"),
                                                     grid = TRUE,
                                                     animate=animationOptions(interval = 1200, loop = FALSE))
                                     
                        ), 
                        
                        mainPanel(
                          h4(textOutput("equity_date_clean",inline = T),"-",textOutput("equity_sum",inline = T),"million doses of vaccine given worldwide"),
                          plotlyOutput("equity_plot", height="400px", width="700px")
                        )
                      ),
                      
                      "Source for vaccine roll-out data:", a("Our World in Data.", href="https://ourworldindata.org/covid-vaccinations", target="_blank"),
                      "Source for income data:", a("Gapminder.", href="https://www.gapminder.org/tools/", target="_blank"),
                      "Source for income group data:", a("World Bank.", href="https://data.worldbank.org", target="_blank"),
                      
                      tags$br(),tags$br(),
                      h4("Testing and implementation status of front-running candidates"),
                      tags$br(),
                      plotOutput("summary_matrix", height="750px", width="950px"),
                      tags$br(),
                      "Abbreviations: AZLB, Anhui Zhifei Longcom Biopharmaceutical; nr, non-replicating; RIBSP, Research Institute for Biological Safety Problems; VLP, virus-like particle. 
                      Candidates in phase III testing and/or widespread use are included. 
                      Source for N countries reporting use: ",a("Our World in Data.", href="https://ourworldindata.org/covid-vaccinations", target="_blank"),
                      tags$br(), tags$br(),
                        
                      h4("Side-by-side comparison of front-running candidates"),
                                 pickerInput("implementation_select_vaccine", h4("Select up to 5 vaccines:"),   
                                             choices = as.character(imp_list), 
                                             options = list(`actions-box` = TRUE, `max-options` = 5),
                                             selected = imp_list[c(3,7,8,10,11)],
                                             multiple = TRUE),
                                 DT::dataTableOutput("implementation_table", width="100%"),
                                 tags$br(),
                                 "Vaccines in widespread use are included.",
                                 tags$br(), tags$br()
                      
                      ),
             

                          
             #################
             ### FAQs PAGE ###
             #################
             
             tabPanel("FAQs",
                      tags$h4("What is a clinical trial?"),
                      "Clinical trials are research studies that are used to determine if a new vaccine is safe and effective. In our",
                      a("animated video on clinical trials", href="https://www.youtube.com/watch?v=G49UhCumWOc", target="_blank"), 
                      "below, we describe the four phases of vaccine clinical trials and the steps it takes to license a vaccine.",
                      tags$ul(
                        tags$li(tags$b("Phase I"), "is an initial trial with a small group of healthy volunteers and usually takes a few months."), 
                        tags$li(tags$b("Phase II"), "examines consistency of the vaccine, any potential side effects and the presence of immune response expected. This phase can last several months."), 
                        tags$li(tags$b("Phase III"), "gathers robust data on safety and efficacy and can last several years as it usually involves thousands of volunteers."), 
                        tags$li(tags$b("Phase IV"), "occurs after the vaccine is licenced and used in the public. This phase continues for as long as the vaccine is being used in the community and monitors the vaccine’s benefits and any side effects.")
                      ),
                      tags$br(),
                      
                      tags$p(HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/G49UhCumWOc" frameborder="0" allowFullScreen="allowFullScreen"></iframe>'), align="center"),
                      
                      tags$br(),tags$h4("What's in a vaccine?"),
                      tags$b("Each ingredient in every vaccine is present for a very specific purpose and our"), 
                      a("animated video on vaccines", href="https://www.youtube.com/watch?v=LQKI5SuqtXk&feature=youtu.be", target="_blank"), 
                      "below explores what goes into a vaccine and why.", 
                      tags$br(), tags$br(),
                      
                      "The main ingredient in any vaccine is the antigen, which is a small part of the virus or bacterium being targeted.", 
                      "The antigen is the ingredient in the vaccine that challenges our immune system to generate the right defences.",
                      "Some vaccines add an adjuvant to the antigen to help strengthen and lengthen your body’s immune response.", 
                      "Stabilisers are used to help the active ingredients to remain effective while the vaccine is made, stored, and moved.", 
                      "Antibiotics and preservatives are sometimes used in the manufacturing process of some vaccines however these elements aren’t in the final vaccine.",
                      "The patient information leaflet that comes with every vaccine tells you exactly what was used in making the vaccine, what is still in it and how much is in the final product.",
                      tags$br(),tags$br(), 
                      
                      tags$p(HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/LQKI5SuqtXk" frameborder="0" allowFullScreen="allowFullScreen"></iframe>'), align="center"),
                      tags$br(),
                      
                      tags$h4("How do we know that vaccines are safe?"),
                      "How safe are vaccines? How do we know that vaccines are safe? Our",
                      a("animated video on vaccine safety", href="https://www.youtube.com/watch?v=owFT2e8h7lw", target="_blank"), 
                      "below explores the safety measures in place throughout the entire vaccine development process, from the four clinical trial phases and through to the use of vaccines in the community.", 
                      tags$br(),tags$br(), 
                      
                      tags$p(HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/owFT2e8h7lw" frameborder="0" allowFullScreen="allowFullScreen"></iframe>'), align="center"),
                      tags$br(),
                      
                      tags$h4("What are the different types of vaccine?"),
                      "All vaccines expose our immune system to antigens from a specific pathogen, but they do this in a variety of ways.",
                      "A summary of the key vaccine types being developed for COVID-19 is provided in the table below.",
                      tags$br(),
                      
                      DT::dataTableOutput("vaccine_types", width="100%"),
                      
                      tags$br(),
                      "For more information, please visit the",a("Vaccine Centre's full FAQs page.", href="https://www.lshtm.ac.uk/research/centres/vaccine-centre/vaccine-faqs", target="_blank"),
                      tags$br(),tags$br()
             )
             )
  )



### server -------------------------------------------------------------------------------------

server <- function(input, output, session) {
  
  ######################
  ### LANDSCAPE PAGE ###
  ######################
  
  # reactive timeline dataframe
  reactive_timeline = reactive({
    if ("term" %in% input$stage==FALSE) { timeline = subset(timeline, stage!="Terminated") }
    if ("preclin" %in% input$stage==FALSE) { timeline = subset(timeline, stage!="Pre-clinical") }
    if ("phasei" %in% input$stage==FALSE) { timeline = subset(timeline, stage!="Phase I") }
    if ("phasei_ii" %in% input$stage==FALSE) { timeline = subset(timeline, stage!="Phase I/II") }
    if ("phaseii" %in% input$stage==FALSE) { timeline = subset(timeline, stage!="Phase II") }
    if ("phaseiii" %in% input$stage==FALSE) { timeline = subset(timeline, stage!="Phase III" & stage!="Phase II/III") }
    if ("phaseiv" %in% input$stage==FALSE) { timeline = subset(timeline, stage!="Phase IV") }
    
    if ("not_in_use" %in% input$in_use==FALSE) { timeline = subset(timeline, use!="No") }
    if ("in_use" %in% input$in_use==FALSE) { timeline = subset(timeline, use!="Yes") }
    
    if ("rna" %in% input$vacc==FALSE) { timeline = subset(timeline, subgroup!="RNA") }
    if ("dna" %in% input$vacc==FALSE) { timeline = subset(timeline, subgroup!="DNA") }
    if ("nrvv" %in% input$vacc==FALSE) { timeline = subset(timeline, subgroup!="Vector (non-replicating)") }
    if ("rvv" %in% input$vacc==FALSE) { timeline = subset(timeline, subgroup!="Vector (replicating)") }
    if ("inact" %in% input$vacc==FALSE) { timeline = subset(timeline, subgroup!="Inactivated") }
    if ("live" %in% input$vacc==FALSE) { timeline = subset(timeline, subgroup!="Live-attenuated") }
    if ("ps" %in% input$vacc==FALSE) { timeline = subset(timeline, subgroup!="Protein subunit") }
    if ("vlp" %in% input$vacc==FALSE) { timeline = subset(timeline, subgroup!="Virus-like particle") }
    if ("unknown" %in% input$vacc==FALSE) { timeline = subset(timeline, subgroup!="Other/Unknown") }
    timeline
  })
  
  # dataframe with one row per candidate
  reactive_groups = reactive({
    groups_df[groups_df$id %in% reactive_timeline()$group,]
  })
  
  # timeline plot for selected groups
  output$vaccine_timeline <- renderTimevis({
    timevis(reactive_timeline() %>% select(-c(stage)), 
            groups = reactive_groups()) %>%
      setWindow("2019-10-01", "2021-12-31") 
  })
  
  # summary figure of landscape
  output$summary_plot <- renderPlot({ summary_plot })
  
  
  
  ############################
  ### CLINICAL TRIALS PAGE ###
  ############################
  
  # clinical trials database
  output$trial_table <- DT::renderDataTable({
    table = fread("input_data/VaC_LSHTM_trials.csv")
    table$`Start date` = as.Date(table$`Start date`, format="%d/%m/%Y")
    table$`Primary completion date` = as.Date(table$`Primary completion date`, format="%d/%m/%Y")
    table$`Trial number` = paste0("<a href=",table$Link,' target="_blank">',table$`Trial number`,"</a>")

    if (input$trial_select_subset=="All trials") { table_selected = table }
    if (input$trial_select_subset=="Trials involving pregnant women") { table_selected = subset(table, Pregnancy==1) }
    if (input$trial_select_subset=="Trials involving <18s") { table_selected = subset(table, Children==1) }
    if (input$trial_select_subset=="Heterologous prime-boost trials") { table_selected = subset(table, `Prime boost`==1) }
    
    DT::datatable(table_selected %>% select(-c(Institutes, Name, Link, Pregnancy, Children, `Prime boost`)), rownames=F, escape = FALSE, 
                  options = list(ordering=T, pageLength = 20,
                                 lengthMenu = c(20, 40, 60))) %>%
      formatStyle(columns = c(1:13), fontSize = '80%')  %>%
      formatCurrency('N',currency = "", interval = 3, mark = ",", digits=0) %>%
      formatDate(columns = c("Start date", "Primary completion date"),  method =  "toLocaleDateString", 
                 params = list('en-GB'))
  })
  
  # download button
  output$downloadCsv <- downloadHandler(
    filename = function() { paste0("VaC_LSHTM_Covid_vaccine_trials_",str_replace_all(update_full, " ", ""),".xlsx") },
    content = function(file) {
      write_xlsx(fread("input_data/VaC_LSHTM_trials.csv") %>% select(-c(Link, Name, Pregnancy, Children, `Prime boost`)), file)
    }
  )
  

  
  #########################
  ### EFFICACY MAP PAGE ###
  #########################
  
  # updates when new vaccine selected
  mapper_reactive_db = reactive({
    trials %>% filter(Vaccine == input$mapper_vaccine_select)
  })
  
  observeEvent(input$mapper_vaccine_select, {
    updatePickerInput(session = session, inputId = "mapper_location_select", 
                      choices = as.character(unique(mapper_reactive_db()$Location)), selected = as.character(mapper_reactive_db()$Location[1]))
  })
  
  observeEvent(input$mapper_vaccine_select, {
    output$mapper_trial_vaccine <- renderText({ as.character(mapper_reactive_db()$Vaccine[1]) })
    output$mapper_trial_n <- renderText({ formatC(mapper_reactive_db()$N[1],big.mark=",") })
    output$mapper_trial_n_doses <- renderText({ as.character(mapper_reactive_db()$N_doses[1]) })
    output$mapper_trial_platform <- renderText({ as.character(mapper_reactive_db()$Platform[1]) })
    output$mapper_trial_number <- renderUI({ HTML("<a href=",as.character(mapper_reactive_db()$Link[1]),'" target="_blank">',as.character(mapper_reactive_db()$Trial_number[1]),"</a>") })
    output$mapper_trial_start_date <- renderText({ format(as.Date(mapper_reactive_db()$Start_date[1],"%d/%m/%Y"),"%d %b %Y") })
    output$mapper_country_status <- renderUI({ 
      if (mapper_reactive_db()$Location_status[1]=="Active/recruiting") { 
        HTML("<em><span style=\"color:green\">Active/recruiting</span></em>") 
      } else if (mapper_reactive_db()$Location_status[1]=="Recruiting") { 
        HTML("<em><span style=\"color:green\">Recruiting</span></em>") 
      } else if (mapper_reactive_db()$Location_status[1]=="Active, not recruiting") {
        HTML("<em><span style=\"color:green\">Active, not recruiting</span></em>")
      } else if (mapper_reactive_db()$Location_status[1]=="Suspended") {
        HTML("<em><span style=\"color:orange\">Suspended</span></em>")
      } else { HTML("<em><span style=\"color:orange\">Not yet recruiting</span></em>") }
    })
    output$mapper_trial_status <- renderUI({ 
      if (mapper_reactive_db()$N_enrolled[1]=="Unknown") {  return(NULL)  } else {
        HTML("<strong>Progress: </strong><a href=",as.character(mapper_reactive_db()$Update_link[1]),'" target="_blank">',as.character(mapper_reactive_db()$N_enrolled[1]),"</a><br>") 
      }
    })
    output$mapper_status_update_date <- renderUI({ 
      if (is.na(mapper_reactive_db()$Update_date[1])) { return(NULL) } else { 
        HTML(paste0("<strong>Status date: </strong>",format(as.Date(mapper_reactive_db()$Update_date[1],"%d/%m/%Y"),"%d %b %Y"),"<br>")) }
    })
    output$mapper_country_plot <- renderPlot({
      country_select = as.character(mapper_reactive_db()$Location_clean[1])
      start_date = as.Date(mapper_reactive_db()$Start_date[1],"%d/%m/%Y") 
      plot_start = as.Date("01/05/2020", "%d/%m/%Y")
      plot_df_new = subset(cv_cases, date>=plot_start & country==country_select)
      grad_df <- data.frame(yintercept = seq(0,200, length.out = 200), alpha = c(seq(0.2, 0, length.out = 150), rep(0,50)))
      
      ggplot(plot_df_new, aes(x = date, y = rolling7permill)) +
        geom_area(fill = covid_col, alpha = 0.7) +
        geom_hline(data = grad_df, aes(yintercept = yintercept, alpha = alpha), size = 1, colour = "white") +
        geom_line(arrow = arrow(length=unit(0.20,"cm"), ends="last", type = "closed"), size=0.5, colour = covid_col) + 
        ylab("cases per million") + theme_bw() + ylim(0,1500) + 
        theme(legend.title = element_blank(), panel.grid.major = element_blank(), legend.position = "", plot.title = element_text(size=10), 
              plot.margin = margin(5, 12, 5, 5)) + theme(text = element_text(size=13)) 
    }, res = 80)
    
    # map updates
    recruiting_countries = subset(mapper_reactive_db(), Location_status=="Active/recruiting")
    recruiting_countries = recruiting_countries[order(recruiting_countries$alpha3),]
    plot_map_layer_1 <- worldcountry[worldcountry$ADM0_A3 %in% recruiting_countries$alpha3[1], ]
    if (nrow(recruiting_countries)>1) {
      for (i in 2:nrow(recruiting_countries)) {
        plot_map_layer_1 = rbind(plot_map_layer_1, worldcountry[worldcountry$ADM0_A3 %in% recruiting_countries$alpha3[i], ])
      }
    }
    pending_countries = subset(mapper_reactive_db(), Location_status=="Not yet recruiting")
    pending_countries = pending_countries[order(pending_countries$alpha3),]
    plot_map_layer_2 <- worldcountry[worldcountry$ADM0_A3 %in% pending_countries$alpha3[1], ]
    if (nrow(pending_countries)>1) {
      for (i in 2:nrow(pending_countries)) {
        plot_map_layer_2 = rbind(plot_map_layer_2, worldcountry[worldcountry$ADM0_A3 %in% pending_countries$alpha3[i], ])
      }
    }
    
    basemap_update = leafletProxy("efficacy_map") %>%
      clearMarkers() %>% clearShapes()
    
    if (nrow(pending_countries)>0) {
      basemap_update = basemap_update  %>%
        addPolygons(data = plot_map_layer_2, smoothFactor = 0.1, fillOpacity = 0.2, fillColor = planned_col,
                    group = 'Not yet recruiting', weight = 1, color = planned_col,
                    label = sprintf("<strong>%s: </strong><i>%s</i>", pending_countries$Location, pending_countries$Location_status) %>% lapply(htmltools::HTML),
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "3px 8px", "color" = planned_col),
                      textsize = "15px", direction = "auto")) %>%
        addCircleMarkers(data = pending_countries, lat = ~ Latitude, lng = ~ Longitude, weight = 1,
                         fillOpacity = 0.5, color = planned_col,
                         label = sprintf("<strong>%s: </strong><i>%s</i>", pending_countries$Location, pending_countries$Location_status) %>% lapply(htmltools::HTML),
                         labelOptions = labelOptions(
                           style = list("font-weight" = "normal", padding = "3px 8px", "color" = planned_col),
                           textsize = "15px", direction = "auto"))
    }
    
    if (nrow(recruiting_countries)>0) {
      basemap_update = basemap_update  %>%
        addPolygons(data = plot_map_layer_1, smoothFactor = 0.1, fillOpacity = 0.2, fillColor = active_col,
                    group = 'Active/recruiting', weight = 1, color = active_col,
                    label = sprintf("<strong>%s: </strong><i>%s</i>", recruiting_countries$Location, recruiting_countries$Location_status) %>% lapply(htmltools::HTML),
                    labelOptions = labelOptions(
                      style = list("font-weight" = "normal", padding = "3px 8px", "color" = active_col),
                      textsize = "15px", direction = "auto")) %>%
        addCircleMarkers(data = recruiting_countries, lat = ~ Latitude, lng = ~ Longitude, weight = 1,
                         fillOpacity = 0.5, color = active_col,
                         label = sprintf("<strong>%s: </strong><i>%s</i>", recruiting_countries$Location, recruiting_countries$Location_status) %>% lapply(htmltools::HTML),
                         labelOptions = labelOptions(
                           style = list("font-weight" = "normal", padding = "3px 8px", "color" = active_col),
                           textsize = "15px", direction = "auto"))
    }
    
    basemap_update = basemap_update %>%
      addCircleMarkers(data = mapper_reactive_db()[1,], lat = ~ Latitude, lng = ~ Longitude, weight = 1,
                       fillOpacity = 1, color = ~status_pal(Location_status),
                       label = sprintf("<strong>%s: </strong><i>%s</i>", mapper_reactive_db()$Location[1], mapper_reactive_db()$Location_status[1]) %>% lapply(htmltools::HTML),
                       labelOptions = labelOptions(
                         style = list("font-weight" = "normal", padding = "3px 8px", "color" = ~status_pal(Location_status)),
                         textsize = "15px", direction = "auto"))
  })
  
  # updates when new location selected
  mapper_reactive_db_country = reactive({
    mapper_reactive_db() %>% filter(Location == input$mapper_location_select)
  })
  
  observeEvent(input$mapper_location_select, {
    output$mapper_trial_vaccine <- renderText({ as.character(mapper_reactive_db_country()$Vaccine[1]) })
    output$mapper_trial_n <- renderText({ formatC(mapper_reactive_db_country()$N[1],big.mark=",") })
    output$mapper_trial_n_doses <- renderText({ as.character(mapper_reactive_db_country()$N_doses[1]) })
    output$mapper_trial_platform <- renderText({ as.character(mapper_reactive_db_country()$Platform[1]) })
    output$mapper_trial_number <- renderUI({ HTML("<a href=",as.character(mapper_reactive_db_country()$Link[1]),'" target="_blank">',as.character(mapper_reactive_db_country()$Trial_number[1]),"</a>") })
    output$mapper_trial_start_date <- renderText({ format(as.Date(mapper_reactive_db_country()$Start_date[1],"%d/%m/%Y"),"%d %b %Y") })
    output$mapper_country_status <- renderUI({ 
      if (mapper_reactive_db_country()$Location_status[1]=="Recruiting") { 
        HTML("<em><span style=\"color:green\">Recruiting</span></em>") 
      } else if (mapper_reactive_db_country()$Location_status[1]=="Active, not recruiting") {
        HTML("<em><span style=\"color:green\">Active, not recruiting</span></em>")
      } else if (mapper_reactive_db_country()$Location_status[1]=="Active/recruiting") {
        HTML("<em><span style=\"color:green\">Active/recruiting</span></em>")
      } else if (mapper_reactive_db_country()$Location_status[1]=="Suspended") {
        HTML("<em><span style=\"color:orange\">Suspended</span></em>")
      } else { HTML("<em><span style=\"color:orange\">Not yet recruiting</span></em>") }
    })
    output$mapper_trial_status <- renderUI({ 
      if (mapper_reactive_db_country()$N_enrolled[1]=="Unknown") {  return(NULL)  } else {
        HTML("<strong>Progress: </strong><a href=",as.character(mapper_reactive_db_country()$Update_link[1]),'" target="_blank">',as.character(mapper_reactive_db_country()$N_enrolled[1]),"</a><br>") 
      }
    })
    output$mapper_status_update_date <- renderUI({ 
      if (is.na(mapper_reactive_db_country()$Update_date[1])) { return(NULL) } else { 
        HTML(paste0("<strong>Status date: </strong>",format(as.Date(mapper_reactive_db_country()$Update_date[1],"%d/%m/%Y"),"%d %b %Y"),"<br>")) }
    })
    output$mapper_country_plot <- renderPlot({
      country_select = as.character(mapper_reactive_db_country()$Location_clean[1])
      if (is.na(mapper_reactive_db_country()$Start_date[1])) { start_date = as.Date("01/09/2020", "%d/%m/%Y") } else {
        start_date = as.Date(mapper_reactive_db_country()$Start_date[1],"%d/%m/%Y") 
      }
      plot_start = as.Date("01/05/2020", "%d/%m/%Y")
      plot_df_new = subset(cv_cases, date>=plot_start & country==country_select)
      grad_df <- data.frame(yintercept = seq(0,200, length.out = 200), alpha = c(seq(0.2, 0, length.out = 150), rep(0,50)))
      
      g1 = ggplot(plot_df_new, aes(x = date, y = rolling7permill)) +
        geom_area(fill = covid_col, alpha = 0.7) +
        geom_hline(data = grad_df, aes(yintercept = yintercept, alpha = alpha), size = 1, colour = "white") +
        geom_line(arrow = arrow(length=unit(0.20,"cm"), ends="last", type = "closed"), size=0.5, colour = covid_col) + 
        ylab("cases per million") + theme_bw() + ylim(0,1500) + 
        theme(legend.title = element_blank(), panel.grid.major = element_blank(), legend.position = "", plot.title = element_text(size=10), 
              plot.margin = margin(5, 12, 5, 5)) + theme(text = element_text(size=13)) 
      
      if (is.na(mapper_reactive_db_country()$Start_date[1])) { g1 } else {
        g1 + geom_vline(xintercept=start_date, size=0.5, colour=active_col) +
          annotate("segment", x = start_date, xend = start_date+20, y = 1000, yend = 1000, colour = active_col, size = 0.5, alpha=1, arrow=arrow(length=unit(0.20,"cm"), type = "closed")) +
          annotate("text", x = start_date+5, y = 1150, label = c("start date") , color= active_col, size=4, fontface="italic", hjust = 0)
      }
    }, res = 80)
  })
  
  output$efficacy_map <- renderLeaflet({ 
    basemap
  })
  
  # updates to map when selecting new location
  observeEvent(input$mapper_location_select, {
    basemap_update = leafletProxy("efficacy_map") %>% clearMarkers()

    # create paramters for active trials layer
    trial_layer = mapper_reactive_db()
    recruiting_countries = subset(trial_layer, Location_status=="Active/recruiting")
    pending_countries = subset(trial_layer, Location_status=="Not yet recruiting")

    if (nrow(pending_countries)>0) {
      basemap_update = basemap_update  %>%
        addCircleMarkers(data = pending_countries, lat = ~ Latitude, lng = ~ Longitude, weight = 1,
                         fillOpacity = 0.5, color = planned_col,
                         label = sprintf("<strong>%s: </strong><i>%s</i>", pending_countries$Location, pending_countries$Location_status) %>% lapply(htmltools::HTML),
                         labelOptions = labelOptions(
                           style = list("font-weight" = "normal", padding = "3px 8px", "color" = planned_col),
                           textsize = "15px", direction = "auto"))
    }

    if (nrow(recruiting_countries)>0) {
      basemap_update = basemap_update  %>%
        addCircleMarkers(data = recruiting_countries, lat = ~ Latitude, lng = ~ Longitude, weight = 1,
                         fillOpacity = 0.5, color = active_col,
                         label = sprintf("<strong>%s: </strong><i>%s</i>", recruiting_countries$Location, recruiting_countries$Location_status) %>% lapply(htmltools::HTML),
                         labelOptions = labelOptions(
                           style = list("font-weight" = "normal", padding = "3px 8px", "color" = active_col),
                           textsize = "15px", direction = "auto"))
    }

    basemap_update = basemap_update  %>%
      addCircleMarkers(data = mapper_reactive_db_country(), lat = ~ Latitude, lng = ~ Longitude, weight = 1,
                       fillOpacity = 1, color = ~status_pal(Location_status),
                       label = sprintf("<strong>%s: </strong><i>%s</i>", mapper_reactive_db_country()$Location, mapper_reactive_db_country()$Location_status) %>% lapply(htmltools::HTML),
                       labelOptions = labelOptions(
                         style = list("font-weight" = "normal", padding = "3px 8px", "color" = ~status_pal(Location_status)),
                         textsize = "15px", direction = "auto"))
  })
  
  ##########################
  ### LIVING REVIEW PAGE ###
  ##########################
  
  output$search_log <- DT::renderDataTable({
    search = fread("input_data/VaC_LSHTM_search_log.csv")
    search$`Search date` = format(as.Date(search$`Search date`, format="%d/%m/%Y"),"%d %b %Y")
    search$`N eligible` = paste0("<p style=\"text-align:right;\"><b><span style=\"color:green\">",search$`N eligible`,"</span></b>")
    
    DT::datatable(search, rownames=F, escape = FALSE, options = list(dom = 't', ordering=F, pageLength = 50)) %>%
      formatStyle(columns = c(1:7), fontSize = '80%') 
  })
  
  output$eligible_studies <- DT::renderDataTable({
    eligible = fread("input_data/VaC_LSHTM_eligible_studies.csv")
    eligible$`Trial number` = paste0("<a href=",eligible$Link,' target="_blank">',eligible$`Trial number`,"</a>")
    
    # Modify Gamaleya phase I/II to include 2 corresponding trials
    eligible$`Trial number`[eligible$Reference=="Logunov; Lancet 2020"] = '<a href=https://clinicaltrials.gov/ct2/show/NCT04436471 target="_blank">NCT04436471</a><br>
    <a href=https://clinicaltrials.gov/ct2/show/NCT04437875 target="_blank">NCT04437875</a>'     

    # Modify Oxford phase III to include 4 corresponding trials
    eligible$`Trial number`[eligible$Reference=="Voysey; Lancet 2020"] = '<a href=https://clinicaltrials.gov/ct2/show/NCT04324606 target="_blank">NCT04324606</a><br>
    <a href=https://clinicaltrials.gov/ct2/show/NCT04400838 target="_blank">NCT04400838</a><br>
    <a href=https://clinicaltrials.gov/ct2/show/NCT04536051 target="_blank">NCT04536051</a><br>
    <a href=https://clinicaltrials.gov/ct2/show/NCT04444674 target="_blank">NCT04444674</a>'    
    
    # Modify Oxford phase III preprint to include 3 corresponding trials
    eligible$`Trial number`[eligible$Reference=="Voysey; Lancet 2021"] = '<a href=https://clinicaltrials.gov/ct2/show/NCT04324606 target="_blank">NCT04324606</a><br>
    <a href=https://clinicaltrials.gov/ct2/show/NCT04400838 target="_blank">NCT04400838</a><br>
    <a href=https://clinicaltrials.gov/ct2/show/NCT04536051 target="_blank">NCT04536051</a><br>
    <a href=https://clinicaltrials.gov/ct2/show/NCT04444674 target="_blank">NCT04444674</a>'    

    # Modify AZLB ZF2001 I/II to include 2 corresponding trials
    eligible$`Trial number`[eligible$Reference=="Yang; Lancet Infect Dis 2021"] = '<a href=https://clinicaltrials.gov/ct2/show/NCT04445194 target="_blank">NCT04445194</a><br>
    <a href=https://clinicaltrials.gov/ct2/show/NCT04466085 target="_blank">NCT04466085</a>'     
    
    eligible$Reference = paste0("<a href=",eligible$`Reference link`,' target="_blank">',eligible$Reference,"</a>")
    eligible = eligible %>% select(-c(`Reference link`, Link, Platform))
    eligible$`Data extraction`[eligible$`Data extraction`=="Complete"] = "<em><span style=\"color:green\">Complete</span></em>"
    eligible$`Data extraction`[eligible$`Data extraction`=="In progress"] = "<em><span style=\"color:orange\">In progress</span></em>"
    eligible$`Data extraction`[eligible$`Data extraction`=="In progress (complete for preprint)"] = "<em><span style=\"color:orange\">In progress (complete for preprint)</span></em>"
    DT::datatable(eligible,  extensions = 'RowGroup', rownames=F, escape = FALSE, 
                  options = list(dom = 't', ordering=F, rowGroup = list(dataSrc = 2), pageLength = 50, columnDefs = list(list(visible=FALSE, targets=2)))) %>%
      formatStyle(columns = c(1:8), fontSize = '80%') 
  })

  observeEvent(input$select_phase, {
    updatePickerInput(session = session, inputId = "select_trial", 
                      choices = unique(db$Identifier[db$Phasegroup==input$select_phase & !is.na(db$Phasegroup)]), selected = unique(db$Identifier[db$Phasegroup==input$select_phase & !is.na(db$Phasegroup)])[1])
  }, ignoreInit = TRUE)
  
  reactive_db = reactive({ db %>% filter(Identifier == input$select_trial) })
  
  ### (1) sidebar outputs ###
  output$trial_developer <- renderUI({ HTML(paste0(reactive_db()$Developers[1])) })
  output$trial_vaccine <- renderText({ paste0(reactive_db()$Vaccine[1]) })
  output$trial_platform <- renderText({ paste0(reactive_db()$Platform[1]) })
  output$trial_location <- renderText({ paste0(reactive_db()$Country[1]) })
  output$trial_phase <- renderText({ paste0(reactive_db()$Phase[1]) })
  output$trial_number <- renderUI({ 
    if (reactive_db()$Identifier[1] == "Gamaleya Gam-COVID-Vac phase I/II") {
      # Insert both trial numbers for Gamaleya phase I/II
      HTML('<a href=https://clinicaltrials.gov/ct2/show/NCT04436471 target="_blank">NCT04436471</a><br>
           <a href=https://clinicaltrials.gov/ct2/show/NCT04437875 target="_blank">NCT04437875</a>') 
    } else if (reactive_db()$Identifier[1] == "Oxford ChAdOx1 phase III (report 1; Voysey 2020)" | reactive_db()$Identifier[1] == "Oxford ChAdOx1 phase III (report 2; Voysey 2021)") {
      # Insert all trial numbers for Oxford phase III
      HTML('<a href=https://clinicaltrials.gov/ct2/show/NCT04324606 target="_blank">NCT04324606</a><br>
           <a href=https://clinicaltrials.gov/ct2/show/NCT04400838 target="_blank">NCT04400838</a><br>
           <a href=https://clinicaltrials.gov/ct2/show/NCT04536051 target="_blank">NCT04536051</a><br>
           <a href=https://clinicaltrials.gov/ct2/show/NCT04444674 target="_blank">NCT04444674</a>') 
    } else {
      # Otherwise render trial number and link
      HTML("<a href=",reactive_db()$Link[1],' target="_blank">',reactive_db()$Trialnumber[1],"</a>") 
    }
  })
  output$trial_report <- renderUI({ HTML("<a href=",reactive_db()$Referencelink[1],' target="_blank">',reactive_db()$Reference[1],"</a>") })
  output$trial_publication_date <- renderText({ format(reactive_db()$Publicationdate[1],"%d %B %Y") })
  
  ### (2) trial attributes ###
  output$trial_vaccine_description <- renderUI({ HTML(paste0(reactive_db()$Descriptionofvaccine[1])) })
  output$trial_attributes <- DT::renderDataTable({
    attributes <- data.frame(
      Attribute = c("Study Design", "Start Date", "Population", "Pregnant women included", "HIV-positive individuals included", "Total number enrolled", "Male (n [%])", "Age range (years)", 
                    "Number of doses", "Route", "Vaccine group(s)", "Control group(s)"),
      
      Description = c(reactive_db()$Studydesign[1], format(reactive_db()$Startdate[1],"%d %B %Y"),reactive_db()$Incusioncriteria[1],
                      reactive_db()$Pregnantwomenincluded[1],reactive_db()$HIVpositiveindividualsincluded[1],
                      reactive_db()$Totalenrolledn[1], reactive_db()$Malen[1], reactive_db()$Ageyearsrange[1], reactive_db()$Numberofdoses[1], 
                      reactive_db()$Delivery[1], reactive_db()$Doses[1], reactive_db()$Control[1]),
      stringsAsFactors = FALSE
    )
    
    # modify date for CAMS phase II, where only month given
    if (reactive_db()$Identifier[1]=="CAMS vaccine phase II") { attributes$Description[2] = "June 2020" }
    
    DT::datatable(attributes, 
                  rownames=F,colnames="",escape = FALSE, 
                  options = list(dom = 't', ordering=F, pageLength = 20, columnDefs = list(list(width = "65%", targets = 1)))) %>%
      formatStyle(columns = c(1:2), fontSize = '90%')
  })
  
  ### (3) safety profile ###
  output$saes <- renderText({ reactive_db()$Seriousadverseevents[1] })
  output$localaes <- renderUI({ HTML(paste0(reactive_db()$Localadverseevents[1])) })
  output$systemicaes <- renderUI({ HTML(reactive_db()$Systemicadverseevents[1]) })
  output$safetyissue <- renderUI({ 
    if (reactive_db()$Safetyissueidentified[1]=="N/A") { return(NULL) }
    else { HTML(paste0("<br><em><span style=\"color:orange\">",reactive_db()$Safetyissueidentified[1],"</span></em>")) }
  })
  
  ### (4) Vaccine efficacy ###
  output$efficacy_endpoint_primary <- renderUI({
    if (reactive_db()$Endpointdefinition[1]=="N/A") { return(NULL) } else { HTML("<b>Primary endpoint: </b>",reactive_db()$Endpointdefinition[1],"<br>") } 
  })
  
  output$efficacy_endpoint_asymptomatic <- renderUI({
    db_sub = subset(reactive_db(), Efficacyendpoint=="Asymptomatic SARS-CoV-2 infection")
    if (nrow(db_sub)==0) { return(NULL) } else { HTML("<b>Asymptomatic SARS-CoV-2: </b>",db_sub$Endpointdefinition[1],"<br>") } 
  })
  
  output$efficacy_endpoint_severe <- renderUI({
    db_sub = subset(reactive_db(), Efficacyendpoint=="Severe COVID-19")
    if (nrow(db_sub)==0) { return(NULL) } else { HTML("<b>Severe COVID-19: </b>",db_sub$Endpointdefinition[1],"<br>") } 
  })
  
  output$efficacy_table_legend <- renderUI({
    if (reactive_db()$Efficacytablelegend[1]=="N/A") { return(NULL) } else { HTML("<b>Notes: </b>",reactive_db()$Efficacytablelegend[1],"<br>") } 
  })
  
  output$outcome_plot_efficacy <- renderPlot({
    #reactive_db = db %>% filter(Identifier == "Oxford ChAdOx1 phase III")
    db_piecharts = reactive_db()
    db_piecharts$profile_plotgroup = "age"
    db_piecharts$profile_plotgroup[db_piecharts$Efficacyprofileplotgroup %in% c("White", "Black", "Asian", "Mixed", "Other")] = "ethnicity"
    db_piecharts$Efficacyprofileplotgroup = factor(db_piecharts$Efficacyprofileplotgroup, levels = db_piecharts$Efficacyprofileplotgroup)
    
    g1 = ggplot(subset(db_piecharts, profile_plotgroup=="age"), aes(x="", y=as.numeric(Efficacyprofileplotpercentage), fill=Efficacyprofileplotgroup)) +
      geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + theme_minimal() + guides(fill=guide_legend(title="Age (y)")) +
      scale_fill_brewer(palette = "Spectral") + theme(legend.text=element_text(size=9), legend.title=element_text(size=9)) +
      ggtitle(paste0("N = ",format(as.numeric(db_piecharts$EfficacyN[1]),big.mark=","))) + theme(plot.title = element_text(hjust = -1.9, vjust = 4, face="italic", size=11)) + 
      theme(legend.position = "left", axis.text.x=element_blank(), panel.border = element_blank(), axis.title.x = element_blank(), axis.title.y = element_blank(), panel.grid=element_blank()) +
      theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
    
    g2 = ggplot(subset(db_piecharts, profile_plotgroup=="ethnicity"), aes(x="", y=as.numeric(Efficacyprofileplotpercentage), fill=Efficacyprofileplotgroup)) +
      geom_bar(width = 1, stat = "identity") + coord_polar("y", start=0) + theme_minimal() + guides(fill=guide_legend(title="Ethnicity")) +
      scale_fill_brewer(palette = "Spectral") + theme(legend.text=element_text(size=9), legend.title=element_text(size=9)) +
      theme(legend.position = "left", axis.text.x=element_blank(), panel.border = element_blank(), axis.title.x = element_blank(), axis.title.y = element_blank(), panel.grid=element_blank()) +
      theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
    
    db_efficacy = subset(reactive_db(), Efficacy95CI!="Pending")
    db_efficacy$Efficacygroup = factor(db_efficacy$Efficacygroup, levels=unique(db_efficacy$Efficacygroup))
    db_efficacy$Efficacystratum = factor(db_efficacy$Efficacystratum, levels=unique(db_efficacy$Efficacystratum))
    db_efficacy$Efficacysubset = factor(db_efficacy$Efficacysubset)
    db_efficacy$Efficacysubset = fct_reorder(db_efficacy$Efficacysubset, -as.numeric(db_efficacy$Efficacyplotorder))

    g3 = ggplot(db_efficacy, aes(x = Efficacysubset, y = as.numeric(VEmid), colour = factor(Efficacygroup), group = 1,
                            label = format(as.numeric(VEmid),nsmall=1))) +
      geom_point(aes(size=as.numeric(Efficacycases)), alpha=0.8) + xlab("") + ylab("Efficacy, %") +
      geom_errorbar(aes(ymin=as.numeric(VElower), ymax=as.numeric(VEupper)), width=0, size=0.8, alpha=0.8, position=position_dodge(.5, preserve = 'single')) +
      scale_colour_manual(values = c("Symptomatic COVID-19" = covid_col, "Virologically confirmed COVID-19" = covid_col, "Asymptomatic SARS-CoV-2" = "#3B9AB2", "Moderate/Severe COVID-19" = "#9970ab", "Severe COVID-19" = "#9970ab")) + 
      geom_text(nudge_x = 0.3, nudge_y = -10, show.legend=FALSE, size=3.5) + ylim(-10,100) + ggtitle(" ") +
      theme_bw() + coord_flip() + facet_grid(Efficacystratum~., scales="free_y", space = "free_y") +
      guides(colour=guide_legend(title="Endpoint", order=2), size=guide_legend(title="N cases")) +
      theme(strip.background = element_blank(), strip.text.y = element_text(size=0), 
            text = element_text(size=11), legend.text=element_text(size=9)) 

    plot_grid(plot_grid(g1, g2, ncol=1, nrow=3, rel_heights = c(1.1,1,1.1),align="v"), g3, ncol=2, rel_widths = c(1,3))
  }, res = 100)
  
  output$efficacy_table <- DT::renderDataTable({
    db_efficacy <- reactive_db() 
    summary <- data.frame(
      "Group" =  db_efficacy$Efficacysubset,
      "Endpoint" =  db_efficacy$Efficacystratum,
      "N_total" = format(as.numeric(db_efficacy$EfficacyN), big.mark=","),
      "N_cases" = db_efficacy$Efficacycases,
      "Cases_vaccine" = db_efficacy$CasesinvaccinegroupsnN,
      "Cases_control" = db_efficacy$CasesincontrolgroupsnN,
      "Efficacy" = db_efficacy$Efficacy95CI
    )
    names(summary) = c("Group", "Endpoint", "N<br>(total)", "N<br>(cases)", "Cases - vaccine,<br>n/N (%)", "Cases - control,<br>n/N (%)", "Efficacy<br>(95% CI)")
    DT::datatable(summary, extensions = 'RowGroup', rownames=F, escape = FALSE, 
                  options = list(dom = 't', ordering=F, rowGroup = list(dataSrc = 1), pageLength = 20, columnDefs = list(list(visible=FALSE, targets=1)))) %>%
      formatStyle(columns = 7, fontWeight = 'bold')
  })
  
  output$efficacy_population <- DT::renderDataTable({
    db_table = subset(reactive_db(), !is.na(Efficacypopulationcharacteristic))
    summary <- data.frame(
      "Characteristic" = db_table$Efficacypopulationcharacteristic,
      "Distribution" = db_table$Efficacypopulationprofile
    )
    DT::datatable(summary[,1:2], rownames=F, escape = FALSE, options = list(dom = 't', ordering=F, 
                                                                            autoWidth = FALSE, columnDefs = list(list(width = "65%", targets = 1)))) %>%
      formatStyle(columns = c(1:2), fontSize = '90%')
  })
  
  ### (5) Antibody response ###
  db_outcome <- reactive({ 
    db_outcome <- reactive_db() %>% filter(Outcome == input$select_outcome & Group=="Antibody") 
    db_outcome$Plotgroup = factor(db_outcome$Plotgroup)
    db_outcome$Plotgroup = fct_reorder(db_outcome$Plotgroup, db_outcome$Plotorder)
    db_outcome
  })
  
  output$outcome_assay <- renderUI({ 
    if (db_outcome()$Outcome[1]=="Not applicable") { return(NULL) } else { HTML("<b>Assay: </b>",db_outcome()$Assay[1],"<br>") } 
  })
  
  output$outcome_timing <- renderUI({ 
    if (db_outcome()$Outcome[1]=="Not applicable") { return(NULL) } else { HTML("<b>Timing: </b>",db_outcome()$Timing[1],"<br>") } 
  })
  
  output$outcome_units <- renderUI({ 
    if (db_outcome()$Outcome[1]=="Not applicable") { return(NULL) } else { HTML("<b>Units: </b>",db_outcome()$Units[1],"<br>") }
  })
  
  output$outcome_binary <- renderUI({ 
    if (db_outcome()$Binaryresponsedefinition[1]=="N/A") { return(NULL) } 
    else { HTML(paste0("<b>Response definition: </b>",db_outcome()$Binaryresponsedefinition[1]),"<br>") } 
  })
  
  output$outcome_extraction_flag <- renderUI({ 
    if (db_outcome()$PlotDigitizerrequired[1]=="No") { return(NULL) } else { HTML("<em><span style=\"color:orange\">Plot Digitizer software required for data extraction; some values are therefore approximations</span></em><br>") }
  })
  output$outcome_small_group_flag <- renderUI({ 
    if (db_outcome()$Smallgroupflag[1]=="No") { return(NULL) } else { HTML(paste0("<em><span style=\"color:orange\">Data available for <10 partipiants in one or more groups</span></em><br>")) }
  })
  
  output$outcome_plot <- renderPlot({
    db_plot = db_outcome()
    y_lowerlim = 10^floor(log10(min(c(db_plot$Lowerpre, db_plot$Lowerpost), na.rm=T)))
    y_upperlim = 10^ceiling(log10(max(c(db_plot$Upperpre, db_plot$Upperpost), na.rm=T)))
    
    if (reactive_db()$Platform[1]=="RNA") { palette = brewer.pal(9, "Blues")[c(3:9, 8:3)] }
    if (reactive_db()$Platform[1]=="DNA") { palette = brewer.pal(9, "Blues")[c(9:3, 3:8)] }
    if (reactive_db()$Platform[1]=="Vector (non-replicating)") { palette = brewer.pal(9, "Oranges")[c(3:9, 8:3)] }
    if (reactive_db()$Platform[1]=="Inactivated") { palette = brewer.pal(9, "Greens")[c(3:9, 8:3)] }
    if (reactive_db()$Platform[1]=="Protein subunit") { palette = brewer.pal(9, "Purples")[c(3:9, 8:3)] }
    if (reactive_db()$Platform[1]=="Virus-like particle") { palette = brewer.pal(9, "Purples")[c(9:3, 3:8)] }
    
    ngroup = length(unique(db_plot$Plotgroup))
    if (y_upperlim==1000) { nudge = 0.06 } else { nudge = 0.07 }
    
    # plot continuous outcome (pre)
    g1 = ggplot(db_plot, aes(x = Plotgroup, y = as.numeric(Midpre), colour = Plotgroup, group = 1,
                             label = format(as.numeric(Midpre), big.mark=","))) +
      geom_point(size = 5, alpha=0.8) +
      geom_errorbar(aes(ymin=as.numeric(Lowerpre), ymax=as.numeric(Upperpre)), width=0, size=0.8, alpha=0.8) +
      theme_bw() + scale_colour_manual(values = palette[1:ngroup]) +
      ylab(db_plot$Yaxislabel[1]) + xlab("") + scale_y_log10(limits=c(y_lowerlim,y_upperlim), labels = trans_format("log10", math_format(10^.x))) +
      ggtitle("Levels (pre)") +
      theme(legend.position="none", text = element_text(size=15), axis.text.x = element_text(angle = 45, hjust = 1),
            plot.title = element_text(size = 14, face = "italic"), axis.title.y = element_text(size = 13))
    
    # plot continuous outcome (post)
    g2 = ggplot(db_plot, aes(x = Plotgroup, y = as.numeric(Midpost), colour = Plotgroup, group = 1,
                             label = format(as.numeric(Midpost), big.mark=","))) + 
      geom_point(size = 5, alpha=0.8) + 
      geom_errorbar(aes(ymin=as.numeric(Lowerpost), ymax=as.numeric(Upperpost)), width=0, size=0.8, alpha=0.8) + 
      theme_bw() + scale_colour_manual(values = palette[1:ngroup]) +
      ylab(" ") + xlab("") + scale_y_log10(limits=c(y_lowerlim,y_upperlim), labels = trans_format("log10", math_format(10^.x))) +    
      ggtitle("Levels (post)") +
      theme(legend.position="none", text = element_text(size=15), axis.text.x = element_text(angle = 45, hjust = 1),
            plot.title = element_text(size = 14, face = "italic"))
    
    # plot binary outcome
    g3 = ggplot(db_plot, aes(x = Plotgroup, y = as.numeric(Responseplot), group = 1,
                             fill = Plotgroup, label = Responseplot)) + 
      geom_bar(stat="identity") + geom_text(nudge_y = 8, aes(colour = Plotgroup), size=4) + 
      theme_bw() + 
      scale_fill_manual(values = palette[1:ngroup]) + scale_colour_manual(values = palette[1:ngroup]) +
      ylab("%") + xlab("") + 
      ggtitle("Response rate") + scale_y_continuous(breaks=c(0,25,50,75,100), limits=c(0, 115)) +
      theme(legend.position="none", text = element_text(size=15), axis.text.x = element_text(angle = 45, hjust = 1),
            plot.title = element_text(size = 14, face = "italic"), axis.title.y = element_text(size = 13))
    
    # create grid plot
    if (all(db_plot$Levelpre95CI!="N/A") & all(db_plot$Levelpost95CI!="N/A") & all(db_plot$Responseplot=="N/A")) { plot_grid(g1, g2, ncol=3) } 
    else if (all(db_plot$Levelpre95CI=="N/A") & all(db_plot$Levelpost95CI!="N/A") & all(db_plot$Responseplot=="N/A")) { plot_grid(g2 + ylab(db_plot$Yaxislabel[1]), ncol=3) } 
    else if (all(db_plot$Levelpre95CI=="N/A") & all(db_plot$Levelpost95CI!="N/A") & all(db_plot$Responseplot!="N/A")) { plot_grid(g2 + ylab(db_plot$Yaxislabel[1]), g3, ncol=3) } 
    else if (all(db_plot$Levelpre95CI=="N/A") & all(db_plot$Levelpost95CI=="N/A") & all(db_plot$Responseplot!="N/A")) { plot_grid(g3, ncol=3) } 
    else { plot_grid(g1, g2, g3, ncol=3) }
  })

  output$immunogenicity_table <- DT::renderDataTable({
    db_plot = db_outcome()
    summary <- data.frame(
      "Group" =  db_plot$Plotgroup,
      "N_pre" = db_plot$Nreportedpre,
      "Ab_pre" = db_plot$Levelpre95CI,
      "N_post" = db_plot$Nreportedpost,
      "Continuous_outcome" = db_plot$Levelpost95CI,
      "Response_rate" = db_plot$ResponseratenN
    )
    
    if (all(db_plot$ResponseratenN=="N/A")) {
      custom_header = htmltools::withTags(table(class = 'display',
                                                thead(tr(
                                                  th(rowspan = 2, 'Group'),
                                                  th(colspan = 2, 'Pre-vaccination'),
                                                  th(colspan = 2, 'Post-vaccination')
                                                ),
                                                tr(lapply(rep(c('N', 'Levels'), 2), th))
                                                )))
      
      DT::datatable(summary[,1:5], container = custom_header, rownames=F, escape = FALSE, options = list(dom = 't', ordering=F)) %>%
        formatStyle(columns = c(1:5), fontSize = '90%')  
      
    } else {
      custom_header = htmltools::withTags(table(class = 'display',
                                                thead(tr(
                                                  th(rowspan = 2, 'Group'),
                                                  th(colspan = 2, 'Pre-vaccination'),
                                                  th(colspan = 2, 'Post-vaccination'),
                                                  th(rowspan = 2, 'Response rate')
                                                ),
                                                tr(lapply(rep(c('N', 'Levels'), 2), th))
                                                )))
      
      DT::datatable(summary, container = custom_header, rownames=F, escape = FALSE, options = list(dom = 't', ordering=F)) %>%
        formatStyle(columns = c(1:6), fontSize = '90%')  
    }
  })
  
  ### (6) T-cell response ###
  db_outcome_T <- reactive({ 
    db_outcome <- reactive_db() %>% filter(Outcome == input$select_outcome_T & Group=="T-cell") 
    db_outcome$Plotgroup = factor(db_outcome$Plotgroup)
    db_outcome$Plotgroup = fct_reorder(db_outcome$Plotgroup, db_outcome$Plotorder)
    db_outcome
  })
  
  output$outcome_assay_T <- renderUI({ 
    if (db_outcome_T()$Outcome[1]=="Not applicable") { return(NULL) } else { HTML("<b>Assay: </b>",db_outcome_T()$Assay[1],"<br>") } 
  })
  output$outcome_timing_T <- renderUI({
    if (db_outcome_T()$Outcome[1]=="Not applicable") { return(NULL) } else { HTML("<b>Timing: </b>",db_outcome_T()$Timing[1],"<br>") }
  })
  output$outcome_units_T <- renderUI({ 
    if (db_outcome_T()$Outcome[1]=="Not applicable") { return(NULL) } else { HTML("<b>Units: </b>",db_outcome_T()$Units[1],"<br>") }
  })
  output$outcome_binary_T <- renderUI({ 
    if (db_outcome_T()$Binaryresponsedefinition[1]=="N/A") { return(NULL) } 
    else { HTML("<b>Response definition: </b>",db_outcome_T()$Binaryresponsedefinition[1],"<br>") } 
  })
  output$outcome_Th1_Th2 <- renderUI({ 
    if (db_outcome_T()$Outcome[1]=="Not applicable") { return(NULL) } else { HTML("<b>Th1/Th2 profile: </b>",reactive_db()$Th1Th2bias[1],"<br><br>") }
  })
  output$outcome_extraction_flag_T <- renderUI({ 
    if (db_outcome_T()$PlotDigitizerrequired[1]=="No") { return(NULL) } else { HTML("<em><span style=\"color:orange\">Plot Digitizer software required for data extraction; some values are therefore approximations</span></em><br>") }
  })
  output$outcome_small_group_flag_T <- renderUI({ 
    if (db_outcome_T()$Smallgroupflag[1]=="No") { return(NULL) } else { HTML(paste0("<em><span style=\"color:orange\">Data available for <10 partipiants in one or more groups</span></em><br>")) }
  })
  
  output$outcome_plot_T <- renderPlot({
    db_plot = db_outcome_T()

    if (reactive_db()$Platform[1]=="RNA") { palette = brewer.pal(9, "Blues")[c(3:9, 8:3)] }
    if (reactive_db()$Platform[1]=="DNA") { palette = brewer.pal(9, "Blues")[c(9:3, 3:8)] }
    if (reactive_db()$Platform[1]=="Vector (non-replicating)") { palette = brewer.pal(9, "Oranges")[c(3:9, 8:3)] }
    if (reactive_db()$Platform[1]=="Inactivated") { palette = brewer.pal(9, "Greens")[c(3:9, 8:3)] }
    if (reactive_db()$Platform[1]=="Protein subunit") { palette = brewer.pal(9, "Purples")[c(3:9, 8:3)] }
    if (reactive_db()$Platform[1]=="Virus-like particle") { palette = brewer.pal(9, "Purples")[c(9:3, 3:8)] }
    
    ngroup = length(unique(db_plot$Plotgroup))
    
    if (db_plot$Plotmax[1]=="N/A" & all(all(db_plot$Levelpost95CI!="N/A"))) {
      
      y_lowerlim = 10^floor(log10(min(c(as.numeric(db_plot$Lowerpre), as.numeric(db_plot$Lowerpost)), na.rm=T)))
      y_upperlim = 10^ceiling(log10(max(c(as.numeric(db_plot$Upperpre), as.numeric(db_plot$Upperpost)), na.rm=T)))
      
      if (y_upperlim==1000) { nudge = 0.06 } else if (y_upperlim==1) { nudge = 0.5 } else { nudge = 0.07 }
      
      # plot continuous outcome (pre)
      g1 = ggplot(db_plot, aes(x = Plotgroup, y = as.numeric(Midpre), colour = Plotgroup, group = 1,
                               label = format(as.numeric(Midpre), big.mark=","))) +
        geom_point(size = 5, alpha=0.8) +
        geom_errorbar(aes(ymin=as.numeric(Lowerpre), ymax=as.numeric(Upperpre)), width=0, size=0.8, alpha=0.8) +
        theme_bw() + scale_colour_manual(values = palette[1:ngroup]) +
        ylab(db_plot$Yaxislabel[1]) + xlab("") + scale_y_log10(limits=c(y_lowerlim,y_upperlim), labels = trans_format("log10", math_format(10^.x))) +
        ggtitle("Levels (pre)") +
        theme(legend.position="none", text = element_text(size=15), axis.text.x = element_text(angle = 45, hjust = 1),
              plot.title = element_text(size = 14, face = "italic"), axis.title.y = element_text(size = 13))
      
      # plot continuous outcome (post)
      g2 = ggplot(db_plot, aes(x = Plotgroup, y = as.numeric(Midpost), colour = Plotgroup, group = 1,
                               label = format(as.numeric(Midpost), big.mark=","))) + 
        geom_point(size = 5, alpha=0.8) + 
        geom_errorbar(aes(ymin=as.numeric(Lowerpost), ymax=as.numeric(Upperpost)), width=0, size=0.8, alpha=0.8) + 
        theme_bw() + scale_colour_manual(values = palette[1:ngroup]) +
        ylab(" ") + xlab("") + scale_y_log10(limits=c(y_lowerlim,y_upperlim), labels = trans_format("log10", math_format(10^.x))) +    
        ggtitle("Levels (post)") +
        theme(legend.position="none", text = element_text(size=15), axis.text.x = element_text(angle = 45, hjust = 1),
              plot.title = element_text(size = 14, face = "italic"), axis.title.y = element_text(size = 13))
      
    } else if (db_plot$Plotmax[1]!="N/A" & all(all(db_plot$Levelpost95CI!="N/A"))) {
      
      y_lowerlim = -0.01
      y_upperlim = as.numeric(db_plot$Plotmax[1])
      
      ngroup = length(unique(db_plot$Plotgroup))
      
      # plot continuous outcome (pre)
      g1 = ggplot(db_plot, aes(x = Plotgroup, y = as.numeric(Midpre), colour = Plotgroup, group = 1,
                               label = format(as.numeric(Midpre), big.mark=","))) +
        geom_point(size = 5, alpha=0.8) +
        geom_errorbar(aes(ymin=as.numeric(Lowerpre), ymax=as.numeric(Upperpre)), width=0, size=0.8, alpha=0.8) +
        theme_bw() + scale_colour_manual(values = palette[1:ngroup]) +
        ylab(db_plot$Yaxislabel[1]) + xlab("") + ylim(y_lowerlim,y_upperlim) +      
        ggtitle("Levels (pre)") +
        theme(legend.position="none", text = element_text(size=15), axis.text.x = element_text(angle = 45, hjust = 1),
              plot.title = element_text(size = 14, face = "italic"), axis.title.y = element_text(size = 13))
      
      # plot continuous outcome (post)
      g2 = ggplot(db_plot, aes(x = Plotgroup, y = as.numeric(Midpost), colour = Plotgroup, group = 1,
                               label = format(as.numeric(Midpost), big.mark=","))) + 
        geom_point(size = 5, alpha=0.8) + 
        geom_errorbar(aes(ymin=as.numeric(Lowerpost), ymax=as.numeric(Upperpost)), width=0, size=0.8, alpha=0.8) + 
        theme_bw() + scale_colour_manual(values = palette[1:ngroup]) +
        ylab(" ") + xlab("") + ylim(y_lowerlim,y_upperlim) +      
        ggtitle("Levels (post)") +
        theme(legend.position="none", text = element_text(size=15), axis.text.x = element_text(angle = 45, hjust = 1),
              plot.title = element_text(size = 14, face = "italic"), axis.title.y = element_text(size = 13))
      
    }
    
    # plot binary outcome
    g3 = ggplot(db_plot, aes(x = Plotgroup, y = as.numeric(Responseplot), group = 1,
                             fill = Plotgroup, label = Responseplot)) + 
      geom_bar(stat="identity") + geom_text(nudge_y = 8, aes(colour = Plotgroup), size=4) + 
      theme_bw() + 
      scale_fill_manual(values = palette[1:ngroup]) + scale_colour_manual(values = palette[1:ngroup]) +
      ylab("%") + xlab("") + 
      ggtitle("Response rate") + scale_y_continuous(breaks=c(0,25,50,75,100), limits=c(0, 115)) +
      theme(legend.position="none", text = element_text(size=15), axis.text.x = element_text(angle = 45, hjust = 1),
            plot.title = element_text(size = 14, face = "italic"), axis.title.y = element_text(size = 13))
    
    # create grid plot
    if (all(db_plot$Levelpre95CI!="N/A") & all(db_plot$Levelpost95CI!="N/A") & all(db_plot$Responseplot=="N/A")) { plot_grid(g1, g2, ncol=3) } 
    else if (all(db_plot$Levelpre95CI=="N/A") & all(db_plot$Levelpost95CI!="N/A") & all(db_plot$Responseplot=="N/A")) { plot_grid(g2 + ylab(db_plot$Yaxislabel[1]), ncol=3) } 
    else if (all(db_plot$Levelpre95CI=="N/A") & all(db_plot$Levelpost95CI!="N/A") & all(db_plot$Responseplot!="N/A")) { plot_grid(g2 + ylab(db_plot$Yaxislabel[1]), g3, ncol=3) } 
    else if (all(db_plot$Levelpre95CI=="N/A") & all(db_plot$Levelpost95CI=="N/A") & all(db_plot$Responseplot!="N/A")) { plot_grid(g3, ncol=3) } 
    else { plot_grid(g1, g2, g3, ncol=3) }
  })
  
  output$immunogenicity_table_T <- DT::renderDataTable({
    db_plot = db_outcome_T()
    summary <- data.frame(
      "Group" =  db_plot$Plotgroup,
      "N_pre" = db_plot$Nreportedpre,
      "Ab_pre" = db_plot$Levelpre95CI,
      "N_post" = db_plot$Nreportedpost,
      "Continuous_outcome" = db_plot$Levelpost95CI,
      "Response_rate" = db_plot$ResponseratenN
    )
    
    if (all(db_plot$ResponseratenN=="N/A")) {
      custom_header = htmltools::withTags(table(class = 'display',
                                                thead(tr(
                                                  th(rowspan = 2, 'Group'),
                                                  th(colspan = 2, 'Pre-vaccination'),
                                                  th(colspan = 2, 'Post-vaccination')
                                                ),
                                                tr(lapply(rep(c('N', 'Levels'), 2), th))
                                                )))
      
      DT::datatable(summary[,1:5], container = custom_header, rownames=F, escape = FALSE, options = list(dom = 't', ordering=F)) %>%
        formatStyle(columns = c(1:5), fontSize = '90%')  
      
    } else {
      custom_header = htmltools::withTags(table(class = 'display',
                                                thead(tr(
                                                  th(rowspan = 2, 'Group'),
                                                  th(colspan = 2, 'Pre-vaccination'),
                                                  th(colspan = 2, 'Post-vaccination'),
                                                  th(rowspan = 2, 'Response rate')
                                                ),
                                                tr(lapply(rep(c('N', 'Levels'), 2), th))
                                                )))
      
      DT::datatable(summary, container = custom_header, rownames=F, escape = FALSE, options = list(dom = 't', ordering=F)) %>%
        formatStyle(columns = c(1:6), fontSize = '90%')  
    }
  })
  
  ### (6) Subgroup analysis ###
  db_outcome_subgroup <- reactive({ 
    db_outcome <- reactive_db() %>% filter(Outcome == input$select_outcome_subgroup) 
    db_outcome$Plotgroup = factor(db_outcome$Plotgroup)
    db_outcome$Plotgroup = fct_reorder(db_outcome$Plotgroup, db_outcome$Plotorder)
    db_outcome
  })
  
  output$outcome_assay_subgroup <- renderUI({ 
    if (reactive_db()$Subgroupsummary[1]=="Not applicable") { return(NULL) }
    else { HTML(paste0("<b>Assay: </b>", db_outcome_subgroup()$Assay[1], "<br>")) }
  })
  output$outcome_timing_subgroup <- renderUI({ 
    if (reactive_db()$Subgroupsummary[1]=="Not applicable") { return(NULL) }
    else { HTML(paste0("<b>Timing: </b>", db_outcome_subgroup()$Timing[1], "<br>")) }
  })
  output$outcome_units_subgroup <- renderUI({ 
    if (reactive_db()$Subgroupsummary[1]=="Not applicable") { return(NULL) }
    else { HTML(paste0("<b>Units: </b>", db_outcome_subgroup()$Units[1], "<br>")) }
  })
  output$outcome_binary_subgroup <- renderUI({ 
    if (reactive_db()$Subgroupsummary[1]=="Not applicable") { return(NULL) }
    else { HTML(paste0("<b>Response definition: </b>", db_outcome_subgroup()$Binaryresponsedefinition[1], "<br>")) }
  })
  output$subgroup_conclusion <- renderUI({ 
    if (reactive_db()$Subgroupsummary[1]=="Not applicable") { return(NULL) }
    else { HTML(paste0("<br><b>Conclusion: </b><br>", reactive_db()$Conclusion[1], "<br><br>")) }
  })
  
  output$subgroup_text <- renderUI({
    if (reactive_db()$Subgroupsummary[1]=="Not applicable") { return(NULL) }
    else {
      HTML(paste0("<i>",reactive_db()$Subgroupsummary[1],"</i><br><br>"))
    }
  })
  
  output$subgroup_table <- DT::renderDataTable({
    if (reactive_db()$Subgroupsummary[1]=="Not applicable") { return(NULL) }
    else {
      db_plot = reactive_db() %>% filter(Outcome == input$select_outcome_subgroup) 
      summary <- data.frame(
        "Group" =  db_plot$Plotgroup,
        "Subgroup_1_N" = db_plot$Group1N,
        "Subgroup_1_level" = db_plot$Group1levelpost95CI,
        "Subgroup_1_binary" = db_plot$Group1responseratenN,
        "Subgroup_2_N" = db_plot$Group2N,
        "Subgroup_2_level" = db_plot$Group2levelpost95CI, 
        "Subgroup_1_binary" = db_plot$Group2responseratenN
      )
      
      custom_header = htmltools::withTags(table(class = 'display',
                                                thead(tr(
                                                  th(rowspan = 2, 'Group'),
                                                  th(colspan = 3, reactive_db()$Group1label[1]),
                                                  th(colspan = 3, reactive_db()$Group2label[1])
                                                ),
                                                tr(lapply(rep(c('N', 'Levels (post)', 'Response rate'), 2), th))
                                                )))
      
      DT::datatable(summary, container = custom_header, rownames=F, escape = FALSE, options = list(dom = 't', ordering=F))  %>%
        formatStyle(columns = c(1:8), fontSize = '90%')
    }
  })
  
  # final additions
  output$other_cofactors <- renderUI({
    other <- reactive_db()$Othercofactors[!is.na(reactive_db()$Othercofactors) & reactive_db()$Othercofactors!="N/A"]
    other_html = paste0("<li>",other,"</li>")
    other_html = paste0("<h4>Factors associated with vaccine response</h4><ul>", paste(other_html, collapse = ""), "</ul><br>")
    
    if (length(other)==0) { return(NULL) }
    else { HTML(str_replace_all(other_html, "\\)\\,\\)", "))")) }
  })
  
  output$other_endpoints <- renderUI({
    other <- reactive_db()$Otherendpoints[!is.na(reactive_db()$Otherendpoints) & reactive_db()$Otherendpoints!="N/A"]
    other_html = paste0("<li>",other,"</li>")
    other_html = paste0("<h4>Other outcomes measured</h4><ul>", paste(other_html, collapse = ""), "</ul>")
    
    if (length(other)==0) { return(NULL) }
    else { HTML(str_replace_all(other_html, "\\)\\,\\)", "))")) }
  })
  
  output$trial_next_steps <- renderUI({ HTML(reactive_db()$Nextstepsproposed[1]) })
  
  # update outcome measurement options - antibody
  observeEvent(input$select_trial, {
    updatePickerInput(session = session, inputId = "select_outcome", 
                      choices = unique(reactive_db()$Outcome[reactive_db()$Group=="Antibody" & !is.na(reactive_db()$Group)]), selected = reactive_db()$Outcome[reactive_db()$Group=="Antibody"][1])
  }, ignoreInit = TRUE)
  
  # update outcome measurement options - T cell endpoints
  observeEvent(input$select_trial, {
    updatePickerInput(session = session, inputId = "select_outcome_T", 
                      choices = unique(reactive_db()$Outcome[reactive_db()$Group=="T-cell" & !is.na(reactive_db()$Group)]), selected = reactive_db()$Outcome[reactive_db()$Group=="T-cell"][1])
  }, ignoreInit = TRUE)
  
  # update outcome measurement options - efficacy endpoints
  observeEvent(input$select_trial, {
    updatePickerInput(session = session, inputId = "select_outcome_efficacy", 
                      choices = unique(reactive_db()$Efficacyendpoint, selected = reactive_db()$Efficacyendpoint[1]))
  }, ignoreInit = TRUE)
  
  # update outcome measurement options - subgroup
  observeEvent(input$select_trial, {
    if (reactive_db()$Subgroupsummary[1]=="Not applicable") { 
      updatePickerInput(session = session, inputId = "select_outcome_subgroup", 
                        choices = "Not applicable", selected = "Not applicable")
    }
    else {
      updatePickerInput(session = session, inputId = "select_outcome_subgroup", 
                        choices = unique(reactive_db()$Outcome), selected = reactive_db()$Outcome[1])
    }
  }, ignoreInit = TRUE)
  
  
  
  ###########################
  ### IMPLEMENTATION PAGE ###
  ###########################
  
  output$summary_matrix <- renderPlot({ summary_matrix })
  
  output$implementation_table <- DT::renderDataTable({
    if (length(input$implementation_select_vaccine)==1) {
      imp_subset <- imp %>% filter(Vaccine %in% input$implementation_select_vaccine) 
      colnames(imp_subset) = c("","",as.character(imp_subset$Vaccine[1]))
      imp_subset = imp_subset[,c(1,3)]
    } else {
      imp_subset <- imp %>% filter(Vaccine %in% input$implementation_select_vaccine[1]) 
      imp_subset = imp_subset[,c(1,3)]
      
      for (i in 2:length(input$implementation_select_vaccine)) {
        imp_subset_new <- imp %>% filter(Vaccine %in% input$implementation_select_vaccine[i]) 
        imp_subset = cbind(imp_subset, imp_subset_new[,3])
      }
      colnames(imp_subset) = c("",input$implementation_select_vaccine)
    }
    
    col_width = paste0(round(100/ncol(imp_subset),0),"%")
    DT::datatable(imp_subset, rownames=F, escape = FALSE, 
                  options = list(dom = 't', ordering=F, pageLength = 50, 
                                 autoWidth = FALSE, columnDefs = list(list(width = col_width, targets = "_all")))) %>% 
      formatStyle(columns = c(1:6), fontSize = '90%') %>%
      formatStyle(columns = 1, fontWeight = 'bold')
  })
  
  
  # equity plot
  equity_input <- reactive({
    equity = equity_full
    selected_date = format(as.Date(input$equity_date, format="%d %b %y"), "%Y-%m-%d")
  
    equity$date[is.na(equity$date)] = selected_date
    equity <- equity %>% filter(date == selected_date) 
    
    if ("hic" %in% input$equity_group==FALSE) { equity = subset(equity, income_group!="High income") }
    if ("umic" %in% input$equity_group==FALSE) { equity = subset(equity, income_group!="Upper middle income") }
    if ("lmic" %in% input$equity_group==FALSE) { equity = subset(equity, income_group!="Lower middle income") }
    if ("lic" %in% input$equity_group==FALSE) { equity = subset(equity, income_group!="Low income") }

    if (nrow(equity)==0) {
      equity = equity_full
      equity$date[is.na(equity$date)] = selected_date
      equity <- equity %>% filter(date == selected_date)
    }
    
    if (input$equity_outcome=="% vaccinated with at least 1 dose") { equity$y = equity$people_vaccinated_per_hundred }
    if (input$equity_outcome=="% fully vaccinated") { equity$y = equity$people_fully_vaccinated_per_hundred }
    if (input$equity_outcome=="Total vaccines per hundred people") { equity$y = equity$total_vaccinations_per_hundred }
    if (input$equity_outcome=="Total vaccines") { equity$y = equity$total_vaccinations }
    
    equity = subset(equity, population>1e6 & !is.na(gdp_2019))
    equity$y[is.na(equity$y)] = 0
    equity
  })
  
  output$equity_sum <- renderText({ round(sum(equity_input()$total_vaccinations, na.rm=TRUE)/1e6,0)})
  output$equity_date_clean <-  renderText({ format(as.Date(input$equity_date, format="%d %b %y"), "%d %b %Y") })
    
  
  output$equity_plot <- renderPlotly({
    
    if (input$equity_outcome=="% vaccinated with at least 1 dose") {
      ymax = max(equity_full$people_vaccinated_per_hundred, na.rm=TRUE)+10
      units = "%"
      }
    if (input$equity_outcome=="% fully vaccinated") { 
      ymax = max(equity_full$people_fully_vaccinated_per_hundred, na.rm=TRUE)+10
      units = "%"
      }
    if (input$equity_outcome=="Total vaccines per hundred people") { 
      ymax = max(equity_full$total_vaccinations_per_hundred, na.rm=TRUE)+10
      units = " vaccine doses"    
    }
    # if (input$equity_outcome=="Total vaccines") { 
    #   ymax = max(equity_full$total_vaccinations, na.rm=TRUE)
    # }
    
    g1 = ggplot(equity_input(), aes(gdp_2019, y, fill=factor(income_group), size=population^(1/2), group = 1,
                                    text = paste0("<b>",round(y,1),units,"</b>",
                                                  "\n<i>",country,"</i>", 
                                                  "\nVaccine(s): ",vaccines))) + #"\nPopulation: ", round(population/1e6,1), "M")
                                                  theme_bw() +
      geom_point(alpha=0.5, stroke = 0.2) + ylab(input$equity_outcome) + 
      scale_fill_manual(values = c("High income" =  "#B40F20", "Upper middle income" = "#8856a7", "Lower middle income" = "#EBCC2A", "Low income" = "#3B9AB2")) + 
      theme(legend.title = element_blank()) +
      scale_x_continuous(trans = log2_trans(), breaks = trans_breaks("log2", function(x) 2^x), limits = c(min(equity_full$gdp_2019, na.rm=T), max(equity_full$gdp_2019, na.rm=T)))  +
      scale_size(range = c(0, 12)) + theme(text = element_text(size=11), legend.position = "none") +
      xlab("Income (GDP/capita in USD)") + ylim(0,ymax)
    
    ggplotly(g1, tooltip = c("text")) %>% layout(hoverlabel = list(font=list(size=15)))
  })
  
  
  
  #################
  ### FAQs PAGE ###
  #################
  
  output$vaccine_types <- DT::renderDataTable({ 
    DT::datatable(data.table::fread("input_data/VaC_LSHTM_vaccine_types.csv"), 
                  rownames=F, options = list(dom = 't', ordering=F, 
                                             columnDefs = list(list(width = "65%", targets = 1)))) %>%
      formatStyle(columns = c(1:3), fontSize = '90%') %>%
      formatStyle(columns = 1, fontWeight = 'bold')
  })
  
  # render table even when hidden to improve loading speed
  outputOptions(output, "implementation_table", suspendWhenHidden = FALSE)
  outputOptions(output, "trial_table", suspendWhenHidden = FALSE)
  outputOptions(output, "eligible_studies", suspendWhenHidden = FALSE)
  outputOptions(output, "search_log", suspendWhenHidden = FALSE)
  outputOptions(output, "vaccine_types", suspendWhenHidden = FALSE)
  outputOptions(output, "vaccine_timeline", suspendWhenHidden = FALSE)
  outputOptions(output, "equity_sum", suspendWhenHidden = FALSE)
  outputOptions(output, "equity_plot", suspendWhenHidden = FALSE)
}

shinyApp(ui = ui, server = server)
#runApp(shinyApp(ui, server), launch.browser = TRUE)
#library(rsconnect)
#deployApp(account="vac-lshtm")
