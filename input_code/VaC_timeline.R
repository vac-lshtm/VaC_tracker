## COVID-2019 vaccine landscape
## Edward Parker, London School of Hygiene & Tropical Medicine (edward.parker@lshtm.ac.uk), April 2020

s = read.csv("input_data/VaC_LSHTM_timeline.csv", stringsAsFactors = FALSE)
nvar = 4

s1 = data.frame(
  Month = rep(s$Month, nvar),
  Stage = c(rep("Pre-clinical", nrow(s)), rep("Phase I", nrow(s)), rep("Phase II", nrow(s)), rep("Phase III", nrow(s))),
  N = c(s$Preclinical, s$Phase_I, s$Phase_II, s$Phase_III)
)
s1$Month = factor(s1$Month, levels = s$Month)
s1$Stage = factor(s1$Stage, levels = c("Pre-clinical", "Phase I", "Phase II", "Phase III"))

g1 = ggplot(s1, aes(Month, N, group=Stage, colour=Stage)) + theme_bw() + geom_line() + geom_point(size=2) + 
  ylab("N candidates (cumulative)") + xlab("") +
  scale_colour_manual(values = c("Pre-clinical" = "#cc4c02", "Phase I" = "#0570b0", "Phase II" = "#045a8d", "Phase III" = "#023858")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size=15), axis.text.y = element_text(size=15), 
        text = element_text(size = 15)) 


plot_grid(g1, summary_plot, align = "v", axis = "lr", rel_heights = c(1,1.2), ncol=1)
