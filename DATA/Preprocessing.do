* Last formating to have tables ready for the analysis 

clear
* define directory
glo dir "H:\DATA" 

**************
*BaseAnalysis
**************
* load data 
import delimited "${dir}\BaseAnalysis.csv"
gen postpeace = (period=="AfterFARC")
* Create year dummies 
tabulate year, gen(_Y)

* create interactions
gen oil_postpeace= oilprod88_dvxlop*postpeace
gen coffee_postpeace= cofint_dvxlinternalp*postpeace

gen r_t3_pp=rainfall_dvxltop3cof*postpeace
gen t_t3_pp=temperature_dvxltop3cof*postpeace
gen rt_t3_pp=rt_dvxltop3cof*postpeace
* save data
save "${dir}\base_full.dta", replace

* drop year dummies
drop _Y*

* filter dataset so it countain the same periods as Dube & Vargas 
drop if year>2005

* create new dummies
tabulate year, gen(_Y)

* save data
save "${dir}\base_1988_2005.dta", replace

******************
* Robustness
******************
clear
* load data 
import delimited "${dir}\BaseAnalysis_nospill.csv"
gen postpeace = (period=="AfterFARC")
* Create year dummies 
tabulate year, gen(_Y)

* create interactions
gen oil_postpeace= oilprod88_dvxlop*postpeace
gen coffee_postpeace= cofint_dvxlinternalp*postpeace

gen r_t3_pp=rainfall_dvxltop3cof*postpeace
gen t_t3_pp=temperature_dvxltop3cof*postpeace
gen rt_t3_pp=rt_dvxltop3cof*postpeace
* save data
save "${dir}\base_full_nospill.dta", replace

* drop year dummies
drop _Y*

* filter dataset so it countain the same periods as Dube & Vargas 
drop if year>2005

* create new dummies
tabulate year, gen(_Y)

* save data
save "${dir}\base_1988_2005_nospill.dta", replace