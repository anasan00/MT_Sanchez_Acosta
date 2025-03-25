glo dir "H:\DATA"  /*directory to recover data*/

glo tab "H:\ANALYSIS\Tables" /* directory to store tables*/

cd  "${tab}"

* install packages
ssc install xtabond2
ssc install xtivreg2
ssc install ivreg2
ssc install ranktest
ssc install outreg2
ssc install estout
*************************************************************
* CHANGE PEACE AGREEMENT THRESHOLDS
*************************************************************
* DV approach
clear
**# Bookmark #4
use "${dir}\base_full.dta" 



* create a directory to store results
capture mkdir "${tab}/results_threshold_analysis"

* DiD Approach 
gen year_var=year
* create all new interaction variables

foreach yearn in 2014 2015 2016 2017 2018 {
    gen peace_`yearn' = (year_var>=`yearn')
    gen oil_pp_`yearn' = oilprod88_dvxlop * peace_`yearn'
    gen coffee_pp_`yearn' = cofint_dvxlinternalp * peace_`yearn'
	gen r_t3_pp_`yearn'=rainfall_dvxltop3cof * peace_`yearn'
	gen t_t3_pp_`yearn'=temperature_dvxltop3cof * peace_`yearn'
	gen rt_t3_pp_`yearn'=rt_dvxltop3cof*peace_`yearn'
}
tsset muncode year, yearly
foreach var in guerrattacks posdattacks clashes causalities {

	eststo clear
	foreach yearn in 2014 2015 2016 2017 2018 {
	
	
		xi: xtivreg2 `var' lpop _Y* _r* coca99xyear oil_pp_`yearn' (coffee_pp_`yearn' cofint_dvxlinternalp = rainfall_dvxltop3cof temperature_dvxltop3cof rt_dvxltop3cof r_t3_pp_`yearn' t_t3_pp_`yearn' rt_t3_pp_`yearn') oilprod88_dvxlop, cluster(depcode) partial(_r* _Y*) fe
		eststo model_`var'_`yearn'
		estadd local th ="`yearn'"
		
	}
		
	esttab model_* using "${tab}\Robustness\TH_var_results_`var'.tex", ///
	b(3) se(3) ///
	keep(cofint_dvxlinternalp coffee_pp_* oilprod88_dvxlop oil_pp_*) ///
	order(cofint_dvxlinternalp coffee_pp_* oilprod88_dvxlop oil_pp_*) ///
	stats(th depvar N, fmt(%9.0g %9s %9.0g)) replace
	
	esttab model_* using "${tab}\Robustness\TH_var_results_`var'.csv", wide plain ///
	b(5) ci(5) ///
	keep(coffee_pp_* oil_pp_*) ///
	order(coffee_pp_* oil_pp_) ///
	 replace
		
}

* Dynamic panel approach

* Create interaction variables 
gen coffee_rev=p_cafe*linternalp
gen oil_rev=oil_production*lop
foreach yearn in 2014 2015 2016 2017 2018 {
	gen oil_pp_dp_`yearn' = oil_rev * peace_`yearn'
	gen coffee_pp_dp_`yearn' = coffee_rev * peace_`yearn'
}

eststo clear
foreach yearn in 2014 2015 2016 2017 2018 {
	xtabond2 guerrattacks l.guerrattacks l2.guerrattacks p_cafe oil_production h_coca coffee_rev oil_rev coffee_pp_dp_`yearn' oil_pp_dp_`yearn' rainfall temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, gmm(L2.guerrattacks, lag(1 2) collapse) gmm(l.guerrattacks p_cafe oil_production h_coca coffee_rev oil_rev coffee_pp_dp_`yearn' oil_pp_dp_`yearn', lag(2 3) collapse) iv( rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust
	eststo model_guerrattacks_`yearn'
	}

	esttab model_* using "${tab}\Robustness\TH_var_results_dp_guerrattacks.tex", ///
	b(3) se(3) ///
	keep(coffee_rev coffee_pp_* oil_rev oil_pp_*) ///
	order(coffee_rev coffee_pp_* oil_rev oil_pp_*) ///
	replace
	
	esttab model_* using "${tab}\Robustness\TH_var_results_dp_guerrattacks.csv", wide plain ///
	b(3) ci(3) ///
	keep(coffee_pp_dp_* oil_pp_dp_*) ///
	order(coffee_pp_dp_* oil_pp_dp_*) ///
	 replace
	
foreach var in posdattacks guerrmass posdmass causalities {

	eststo clear
	foreach yearn in 2014 2015 2016 2017 2018 {
		xtabond2 `var' L.`var' p_cafe oil_production h_coca ///
        coffee_rev oil_rev coffee_pp_dp_`yearn' oil_pp_dp_`yearn' rainfall ///
        temperature rainfallxltop3cof temperaturexltop3cof lpop i.year, ///
        gmm(L.`var', lag(1 2) collapse) ///
        gmm(p_cafe oil_production h_coca coffee_rev oil_rev coffee_pp_dp_`yearn' 		oil_pp_dp_`yearn', lag(2 3) collapse) ///
        iv(rainfall temperature rainfallxltop3cof temperaturexltop3cof i.year) robust
		eststo model_`var'_`yearn'
	}
	esttab model_* using "${tab}\Robustness\TH_var_results_dp_`var'.tex", ///
	b(3) se(3) ///
	keep(coffee_rev coffee_pp_* oil_rev oil_pp_*) ///
	order(coffee_rev coffee_pp_* oil_rev oil_pp_*) ///
	replace
	
	esttab model_* using "${tab}\Robustness\TH_var_results_dp_`var'.csv", wide plain ///
	b(5) ci(5) ///
	keep(coffee_pp_dp_* oil_pp_dp_*) ///
	order(coffee_pp_dp_* oil_pp_dp_*) ///
	 replace
}

************************
* NO SPILLOVER
* my data Dube & Vargas window 
	# delimit;
	clear;
	use "${dir}\base_1988_2005_nospill.dta";
	tsset muncode year, yearly; 
	foreach var of varlist guerrattacks parattacks clashes causalities{;
			xi: xtivreg2   `var'  lpop    _Y*  _r*  coca99xyear 
			(cofint_dvxlinternalp= rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof) oilprod88_dvxlop       
				  , cluster(depcode) partial(_r* _Y*)  fe;
				  outreg2  cofint_dvxlinternalp   oilprod88_dvxlop        
				  using  main_1998_2005_nospill.xls,  se  bdec(3) tdec(3) nocons nor noni; 
	};

* my data extended window 
	# delimit;
	clear;
	use "${dir}\base_full_nospill.dta";
	tsset muncode year, yearly; 
	foreach var of varlist guerrattacks parattacks posdattacks clashes causalities{;
			xi: xtivreg2   `var'  lpop    _Y*  _r*  coca99xyear 
			(cofint_dvxlinternalp= rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof) oilprod88_dvxlop       
				  , cluster(depcode) partial(_r* _Y*)  fe;
				  outreg2  cofint_dvxlinternalp   oilprod88_dvxlop        
				  using  main_1998_2021_nospill.xls,  se  bdec(3) tdec(3) nocons nor noni; 
	};