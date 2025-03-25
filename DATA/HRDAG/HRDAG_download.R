# HRDAG Data 


#installation 
if (!require("devtools")) {install.packages("devtools")}
devtools::install_github("HRDAG/verdata")

#use 
library(verdata)

#confirm files 
confirmar <- verdata::confirm_files("C:/Users/anasa/Master Thesis/DATA/HRDAG_secuetros/Secuestro.csv",
                                    "secuestro", c(1:100))

#read tables 
replicas_datos <- verdata::read_replicates("C:/Users/anasa/Master Thesis/DATA/HRDAG_secuetros/Secuestro.csv",
                                           "secuestro", c(1:100))
#filter
replicas_filtradas <- verdata::filter_standard_cev(replicas_datos,
                                                   "secuestro", 
                                                   perp_change = TRUE)
                                                   
#sumarize data                                                    

tabla_documentada <- verdata::summary_observed("secuestro",
                                               replicas_filtradas, 
                                               strata_vars = c("yy_hecho","muni_code_hecho","p_str"),
                                               conflict_filter = TRUE,
                                               forced_dis_filter = FALSE,
                                               edad_minors_filter = FALSE,
                                               include_props = FALSE)

#export data from table 
write.csv(tabla_documentada, "C:/Users/anasa/Master Thesis/DATA/HRDAG_secuetros/HRDAG_secuestros.csv", row.names=FALSE)


