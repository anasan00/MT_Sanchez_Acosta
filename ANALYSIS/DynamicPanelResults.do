************* Dynamic Panel Approach ***********
* Install necessary packages
ssc install xtabond2
ssc install estout

* set working directory
cd H:\

*load data
import delimited "DATA\BaseAnalysis.csv"

*set to panel data 
xtset muncode year

*drop observations that do not have coffee data
drop if year<2007

* Create interaction variables 
gen coffee_rev=p_cafe*linternalp
gen oil_rev=oil_production*lop

gen postpeace = (period=="AfterFARC")

gen coffee_rev_postp= coffee_rev*postpeace
gen oil_rev_postp=oil_rev *postpeace

*** Main specification ***

eststo clear

* Guerrilla attacks 
xtabond2 guerrattacks l.guerrattacks l2.guerrattacks p_cafe oil_production h_coca coffee_rev oil_rev rainfall temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, gmm(L2.guerrattacks, lag(1 2) collapse) gmm(l.guerrattacks p_cafe oil_production h_coca coffee_rev oil_rev, lag(2 3) collapse) iv( rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust

eststo guerrattacks
estadd scalar AR1=e(ar1p)
estadd scalar AR2=e(ar2p)
estadd scalar instr=e(j)
estadd scalar phansen= e(hansenp)

local dep_vars_main_lag1 "posdattacks guerrmass posdmass causalities"

foreach depvar of local dep_vars_main_lag1 {
    
    display _newline
    display as text "{hline}"
    display as text "Dependent variable: `depvar'"
    display as text "{hline}"
    
    * Run the xtabond2 regression
    xtabond2 `depvar' L.`depvar' p_cafe oil_production h_coca ///
        coffee_rev oil_rev rainfall ///
        temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, ///
        gmm(L.`depvar', lag(1 2) collapse) ///
        gmm(p_cafe oil_production h_coca coffee_rev oil_rev, lag(2 3) collapse) ///
        iv(rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust
    
    * Store key results 
	eststo `depvar'
	estadd scalar AR1=e(ar1p)
	estadd scalar AR2=e(ar2p)
	estadd scalar instr=e(j)
	estadd scalar phansen= e(hansenp)
}
* define how to approach clashe
esttab using "ANALYSIS\Tables\DynamicPanel\main_results.tex", replace ///
    keep(L.* L2.* p_cafe coffee_rev oil_production oil_rev) ///
	order(L.* L2.* p_cafe coffee_rev oil_production oil_rev) ///
    label nocons compress ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	b(%9.3f) se(%9.3f) ///
    scalars(instr AR1 AR2 phansen) ///
    title("Effects of Price Shocks on conflict measures") ///
    mtitles("Guerrilla attacks" "Post-demobilization attacks" "Guerrilla Massacres" "Post-demobilization Massacccres" "Causalities")

* What happend after peace agreement 

eststo clear

* Guerrilla attacks 
xtabond2 guerrattacks l.guerrattacks l2.guerrattacks p_cafe oil_production h_coca coffee_rev oil_rev coffee_rev_postp oil_rev_postp rainfall temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, gmm(L2.guerrattacks, lag(1 2) collapse) gmm(l.guerrattacks p_cafe oil_production h_coca coffee_rev oil_rev coffee_rev_postp oil_rev_postp, lag(2 3) collapse) iv( rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust

eststo guerrattacks
estadd scalar AR1=e(ar1p)
estadd scalar AR2=e(ar2p)
estadd scalar instr=e(j)
estadd scalar phansen= e(hansenp)



foreach depvar of local dep_vars_main_lag1 {
    
    display _newline
    display as text "{hline}"
    display as text "Dependent variable: `depvar'"
    display as text "{hline}"
    
    * Run the xtabond2 regression with peace agreement variables
    xtabond2 `depvar' L.`depvar' p_cafe oil_production h_coca ///
        coffee_rev oil_rev coffee_rev_postp oil_rev_postp rainfall ///
        temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, ///
        gmm(L.`depvar', lag(1 2) collapse) ///
        gmm(p_cafe oil_production h_coca coffee_rev oil_rev coffee_rev_postp oil_rev_postp, lag(2 3) collapse) ///
        iv(rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust
    
    * Store key results 
	eststo `depvar'
	estadd scalar AR1=e(ar1p)
	estadd scalar AR2=e(ar2p)
	estadd scalar instr=e(j)
	estadd scalar phansen= e(hansenp)
}
* define how to approach clashes
esttab using "ANALYSIS\Tables\DynamicPanel\postpeace_results.tex", replace ///
    keep(L.* L2.* p_cafe coffee_rev coffee_rev_postp oil_production oil_rev oil_rev_postp) ///
	order(L.* L2.* p_cafe coffee_rev coffee_rev_postp oil_production oil_rev oil_rev_postp) ///
    label nocons compress ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	b(%9.3f) se(%9.3f) ///
    scalars(instr AR1 AR2 phansen) ///
    title("Effects of Price Shocks on conflict measures") ///
    mtitles("Guerrilla attacks" "Post-demobilization attacks" "Guerrilla Massacres" "Post-demobilization Massacccres" "Causalities")

* mechanisms
eststo clear
* SIEVCAC lidnappings 
local dep_vars_mec_lag1 "n_guerrsec n_posdsec"

foreach depvar of local dep_vars_mec_lag1 {
    
    display _newline
    display as text "{hline}"
    display as text "Dependent variable: `depvar'"
    display as text "{hline}"
    
    * Run the xtabond2 regression with peace agreement variables
    xtabond2 `depvar' L.`depvar' p_cafe oil_production h_coca ///
        coffee_rev oil_rev rainfall ///
        temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, ///
        gmm(L.`depvar', lag(1 2) collapse) ///
        gmm(p_cafe oil_production h_coca coffee_rev oil_rev , lag(2 3) collapse) ///
        iv(rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust
    
    * Store key results 
	eststo m_`depvar'
	estadd scalar AR1=e(ar1p)
	estadd scalar AR2=e(ar2p)
	estadd scalar instr=e(j)
	estadd scalar phansen= e(hansenp)
}

foreach depvar of local dep_vars_mec_lag1 {
    
    display _newline
    display as text "{hline}"
    display as text "Dependent variable: `depvar'"
    display as text "{hline}"
    
    * Run the xtabond2 regression with peace agreement variables
    xtabond2 `depvar' L.`depvar' p_cafe oil_production h_coca ///
        coffee_rev oil_rev coffee_rev_postp oil_rev_postp rainfall ///
        temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, ///
        gmm(L.`depvar', lag(1 2) collapse) ///
        gmm(p_cafe oil_production h_coca coffee_rev oil_rev coffee_rev_postp oil_rev_postp, lag(2 3) collapse) ///
        iv(rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust
    
    * Store key results 
	eststo `depvar'
	estadd scalar AR1=e(ar1p)
	estadd scalar AR2=e(ar2p)
	estadd scalar instr=e(j)
	estadd scalar phansen= e(hansenp)
}

esttab using "ANALYSIS\Tables\DynamicPanel\kidnappings.tex", replace ///
    keep(L.* p_cafe coffee_rev coffee_rev_postp oil_production oil_rev oil_rev_postp) ///
	order(L.* p_cafe coffee_rev coffee_rev_postp oil_production oil_rev oil_rev_postp) ///
    label nocons compress ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	b(%9.3f) se(%9.3f) ///
    scalars(instr AR1 AR2 phansen) ///
    title("Effects of Price Shocks on Kidnapping") ///
    mtitles("Guerrilla" "Post-demobilization" "Guerrilla" "Post-demobilization")
*HRDAG
eststo clear

local dep_vars_mec_lag1 "guersec_hrdag posdsec_hrdag"

foreach depvar of local dep_vars_mec_lag1 {
    
    display _newline
    display as text "{hline}"
    display as text "Dependent variable: `depvar'"
    display as text "{hline}"
    
    * Run the xtabond2 regression with peace agreement variables
    xtabond2 `depvar' L.`depvar' p_cafe oil_production h_coca ///
        coffee_rev oil_rev rainfall ///
        temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, ///
        gmm(L.`depvar', lag(1 2) collapse) ///
        gmm(p_cafe oil_production h_coca coffee_rev oil_rev , lag(2 3) collapse) ///
        iv(rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust
    
    * Store key results 
	eststo m_`depvar'
	estadd scalar AR1=e(ar1p)
	estadd scalar AR2=e(ar2p)
	estadd scalar instr=e(j)
	estadd scalar phansen= e(hansenp)
}

foreach depvar of local dep_vars_mec_lag1 {
    
    display _newline
    display as text "{hline}"
    display as text "Dependent variable: `depvar'"
    display as text "{hline}"
    
    * Run the xtabond2 regression with peace agreement variables
    xtabond2 `depvar' L.`depvar' p_cafe oil_production h_coca ///
        coffee_rev oil_rev coffee_rev_postp oil_rev_postp rainfall ///
        temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, ///
        gmm(L.`depvar', lag(1 2) collapse) ///
        gmm(p_cafe oil_production h_coca coffee_rev oil_rev coffee_rev_postp oil_rev_postp, lag(2 3) collapse) ///
        iv(rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust
    
    * Store key results 
	eststo `depvar'
	estadd scalar AR1=e(ar1p)
	estadd scalar AR2=e(ar2p)
	estadd scalar instr=e(j)
	estadd scalar phansen= e(hansenp)
}

esttab using "ANALYSIS\Tables\DynamicPanel\kidnappings_hrdag.tex", replace ///
    keep(L.* p_cafe coffee_rev coffee_rev_postp oil_production oil_rev oil_rev_postp) ///
	order(L.* p_cafe coffee_rev coffee_rev_postp oil_production oil_rev oil_rev_postp) ///
    label nocons compress ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	b(%9.3f) se(%9.3f) ///
    scalars(instr AR1 AR2 phansen) ///
    title("Effects of Price Shocks on Kidnapping") ///
    mtitles("Guerrilla" "Post-demobilization" "Guerrilla" "Post-demobilization")
*Capital revenue 
eststo clear

xtabond2 lcaprev l.lcaprev l2.lcaprev p_cafe oil_production h_coca coffee_rev oil_rev rainfall temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, gmm(L2.lcaprev, lag(1 2)   collapse) gmm(l.lcaprev p_cafe oil_production h_coca coffee_rev oil_rev, lag(2 3) collapse) iv( rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust noleveleq

eststo m_caprev
estadd scalar AR1=e(ar1p)
estadd scalar AR2=e(ar2p)
estadd scalar instr=e(j)
estadd scalar phansen= e(hansenp)

xtabond2 lcaprev l.lcaprev l2.lcaprev p_cafe oil_production h_coca coffee_rev oil_rev coffee_rev_postp oil_rev_postp rainfall temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, gmm(L2.lcaprev, lag(1 2)   collapse) gmm(l.lcaprev p_cafe oil_production h_coca coffee_rev oil_rev coffee_rev_postp oil_rev_postp, lag(2 3) collapse) iv( rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust noleveleq

eststo caprev
estadd scalar AR1=e(ar1p)
estadd scalar AR2=e(ar2p)
estadd scalar instr=e(j)
estadd scalar phansen= e(hansenp)

esttab using "ANALYSIS\Tables\DynamicPanel\capital_revenue.tex", replace ///
    keep(L.* L2.* p_cafe coffee_rev coffee_rev_postp oil_production oil_rev oil_rev_postp) ///
	order(L.* L2.* p_cafe coffee_rev coffee_rev_postp oil_production oil_rev oil_rev_postp) ///
    label nocons compress ///
    star(* 0.10 ** 0.05 *** 0.01) ///
	b(%9.3f) se(%9.3f) ///
    scalars(instr AR1 AR2 phansen) ///
    title("Effects of Price Shocks on capital revenue") ///
    mtitles("Main specification" "Peace agreement")
	


