clear matrix
clear mata
clear
capture log close
* install packages
ssc install xtivreg2
ssc install ivreg2
ssc install ranktest
ssc install outreg2

glo dir "H:\DATA"  /*directory to recover data*/

glo tab "H:\ANALYSIS\Tables" /* directory to store tables*/
cd  "${tab}"

********************
* MAIN RELATIONSHIP
********************
	clear
	use "${dir}\origmun_violence_commodities"

	# delimit; 
	tsset origmun year, yearly; 
		xi: xtivreg2 gueratt    lpop    _Y*          _R*  coca94indxyear
		(cofintxlinternalp   = rxltop3cof txltop3cof  rtxltop3cof) 
		oilprod88xlop     
		   , cluster(department) partial(_R* _Y*)  fe first; 
		outreg2  cofintxlinternalp  oilprod88xlop         using  table2.xls, replace se  bdec(3) tdec(3) nocons nor noni; 
	# delimit; 
	foreach var of varlist paratt clashes casualties  {; 
	tsset origmun year, yearly; 
		xi: xtivreg2 `var'    lpop    _Y*        		_R*  coca94indxyear
		(cofintxlinternalp   = rxltop3cof txltop3cof  rtxltop3cof ) 
		 oilprod88xlop      
		   , cluster(department) partial(_R* _Y*)  fe ; 
		outreg2  cofintxlinternalp  oilprod88xlop         using  table2.xls, se bdec(3) tdec(3) nocons nor noni; 
	}; 

* my data Dube & Vargas window 
	# delimit;
	clear;
	use "${dir}\base_1988_2005.dta";
	tsset muncode year, yearly; 
	foreach var of varlist guerrattacks parattacks clashes causalities{;
			xi: xtivreg2   `var'  lpop    _Y*  _r*  coca99xyear 
			(cofint_dvxlinternalp= rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof) oilprod88_dvxlop       
				  , cluster(depcode) partial(_r* _Y*)  fe;
				  outreg2  cofint_dvxlinternalp   oilprod88_dvxlop        
				  using  table_main_1998_2005.xls,  se  bdec(3) tdec(3) nocons nor noni; 
	};

* my data extended window 
	# delimit;
	clear;
	use "${dir}\base_full.dta";
	tsset muncode year, yearly; 
	foreach var of varlist guerrattacks parattacks posdattacks clashes causalities{;
			xi: xtivreg2   `var'  lpop    _Y*  _r*  coca99xyear 
			(cofint_dvxlinternalp= rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof) oilprod88_dvxlop       
				  , cluster(depcode) partial(_r* _Y*)  fe;
				  outreg2  cofint_dvxlinternalp   oilprod88_dvxlop        
				  using  table_main_1998_2021.xls,  se  bdec(3) tdec(3) nocons nor noni; 
	};

****************
*MECHANISMS: 
****************
* This part is directly copied from the material of Dube & Vargas
	*  Log capital revenue 	 
	# delimit;
	clear;  
	use "${dir}\origmun_violence_commodities"; 

	# delimit; 
	tsset origmun year, yearly; 
		xi: xtivreg2   lcaprev  lpop    _Y*        _R*  coca94indxyear
		(cofintxlinternalp   = rxltop3cof txltop3cof  rtxltop3cof)
		oilprod88xlop       
		      , cluster(department) partial(_R* _Y*)  fe ; 
		outreg2  cofintxlinternalp  oilprod88xlop         using  DV_mec.xls,  se  bdec(3) tdec(3) nocons nor noni; 


	*  Paramilitary and Guerrilla political kidnaps
	# delimit; 
	foreach var of varlist guerkidpol parkidpol  {; 
	# delimit; 
	tsset origmun year, yearly; 
		xi: xtivreg2   `var'  lpop    _Y*        _R*  coca94indxyear
		(cofintxlinternalp   = rxltop3cof txltop3cof  rtxltop3cof)
		oilprod88xlop       
		      , cluster(department) partial(_R* _Y*)  fe ; 
		outreg2  cofintxlinternalp  oilprod88xlop         using  DV_mec.xls,  se  bdec(3) tdec(3) nocons nor noni; 
		}; 

* using my data*/
* same years as Dube & Vargas
	# delimit;
	clear;
	use "${dir}\base_1988_2005.dta";
	
	tsset muncode year;

		xi: xtivreg2   lcaprev  lpop    _Y*        _r*  coca99xyear
		(cofint_dvxlinternalp   = rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof)
		oilprod88_dvxlop       
		      , cluster(depcode) partial(_r* _Y*)  fe ; 
		outreg2  cofint_dvxlinternalp   oilprod88_dvxlop         using  mec_1988_2005.xls, replace se  bdec(3) tdec(3) nocons nor noni; 
		*  Paramilitary and Guerrilla political kidnaps
	# delimit; 
	foreach var of varlist n_guerrsec n_parsec {; 
	# delimit; 
	tsset muncode year, yearly; 
		xi: xtivreg2   `var'  lpop    _Y*        _r*  coca99xyear
		(cofint_dvxlinternalp   = rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof)
		oilprod88_dvxlop       
		      , cluster(depcode) partial(_r* _Y*)  fe ; 
		outreg2  cofint_dvxlinternalp   oilprod88_dvxlop   using  mec_1988_2005.xls, append se  bdec(3) tdec(3) nocons nor noni; 
		}; 
		*  Paramilitary and Guerrilla political kidnaps HRDAG
	# delimit; 
	foreach var of varlist guersec_hrdag parsec_hrdag posdsec_hrdag{; 
	# delimit; 
	tsset muncode year, yearly; 
		xi: xtivreg2   `var'  lpop    _Y*        _r*  coca99xyear
		(cofint_dvxlinternalp   = rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof)
		oilprod88_dvxlop       
		      , cluster(depcode) partial(_r* _Y*)  fe ; 
		outreg2  cofint_dvxlinternalp   oilprod88_dvxlop          using  kidnappings_hrdag_1988_2005.xls,  append se  bdec(3) tdec(3) nocons nor noni; 
		}; 
* whole sample period
 	# delimit;
	clear;
	use "${dir}\base_full.dta";
	
	tsset muncode year;
		xi: xtivreg2   lcaprev  lpop    _Y*        _r*  coca99xyear
		(cofint_dvxlinternalp   = rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof)
		oilprod88_dvxlop       
		      , cluster(depcode) partial(_r* _Y*)  fe ; 
		outreg2  cofint_dvxlinternalp   oilprod88_dvxlop         using  mec_1988_2021.xls, replace  se  bdec(3) tdec(3) nocons nor noni; 
*  Paramilitary and Guerrilla political kidnaps
	# delimit; 
	foreach var of varlist n_guerrsec n_parsec n_posdsec{; 
	# delimit; 
	tsset muncode year, yearly; 
		xi: xtivreg2   `var'  lpop    _Y*        _r*  coca99xyear
		(cofint_dvxlinternalp   = rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof)
		oilprod88_dvxlop       
		      , cluster(depcode) partial(_r* _Y*)  fe ; 
		outreg2  cofint_dvxlinternalp   oilprod88_dvxlop          using  mec_1988_2021.xls,  append se  bdec(3) tdec(3) nocons nor noni; 
		}; 
*  Paramilitary and Guerrilla political kidnaps HRDAG
	# delimit; 
	foreach var of varlist guersec_hrdag parsec_hrdag posdsec_hrdag{; 
	# delimit; 
	tsset muncode year, yearly; 
		xi: xtivreg2   `var'  lpop    _Y*        _r*  coca99xyear
		(cofint_dvxlinternalp   = rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof)
		oilprod88_dvxlop       
		      , cluster(depcode) partial(_r* _Y*)  fe ; 
		outreg2  cofint_dvxlinternalp   oilprod88_dvxlop          using  kidnappings_hrdag_1988_2021.xls,  append se  bdec(3) tdec(3) nocons nor noni; 
		}; 

* test including post peace period dummies 
* Main effects 
	* paramiliatry are not relevant sice the demobilized before 
 	# delimit;
	clear;
	use "${dir}\base_full.dta";
	tsset muncode year, yearly; 
	foreach var of varlist guerrattacks posdattacks clashes causalities{;
			xi: xtivreg2   `var'  lpop    _Y*  _r*  coca99xyear oil_postpeace
			(coffee_postpeace cofint_dvxlinternalp= rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof r_t3_pp t_t3_pp rt_t3_pp) oilprod88_dvxlop       
				  , cluster(depcode) partial(_r* _Y*)  fe;
				  outreg2  cofint_dvxlinternalp  coffee_postpeace oilprod88_dvxlop   oil_postpeace        using  table_main_postpeace.xls,  se  bdec(3) tdec(3) nocons nor noni; 
	};

* Mechanisms 
# delimit;
	clear;
	use "${dir}\base_full.dta";
	
	tsset muncode year;
		xi: xtivreg2   lcaprev  lpop    _Y*  _r*  coca99xyear oil_postpeace
			(coffee_postpeace cofint_dvxlinternalp= rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof r_t3_pp t_t3_pp rt_t3_pp) oilprod88_dvxlop       
		      , cluster(depcode) partial(_r* _Y*)  fe ; 
		outreg2  cofint_dvxlinternalp   oilprod88_dvxlop         using pp_mec.xls, replace  se  bdec(3) tdec(3) nocons nor noni; 
*  Paramilitary and Guerrilla political kidnaps
	# delimit; 
	foreach var of varlist n_guerrsec n_parsec n_posdsec{; 
	# delimit; 
	tsset muncode year, yearly; 
		xi: xtivreg2   `var'  lpop    _Y*        _r*  coca99xyear oil_postpeace
			(coffee_postpeace cofint_dvxlinternalp= rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof r_t3_pp t_t3_pp rt_t3_pp) oilprod88_dvxlop       
		      , cluster(depcode) partial(_r* _Y*)  fe ; 
		outreg2  cofint_dvxlinternalp   oilprod88_dvxlop          using  pp_mec.xls,  append se  bdec(3) tdec(3) nocons nor noni; 
		}; 
*  Paramilitary and Guerrilla political kidnaps HRDAG
	# delimit; 
	foreach var of varlist guersec_hrdag parsec_hrdag posdsec_hrdag{; 
	# delimit; 
	tsset muncode year, yearly; 
		xi: xtivreg2   `var'  lpop    _Y*        _r*  coca99xyear oil_postpeace
			(coffee_postpeace cofint_dvxlinternalp= rainfall_dvxltop3cof temperature_dvxltop3cof  rt_dvxltop3cof r_t3_pp t_t3_pp rt_t3_pp) oilprod88_dvxlop       
		      , cluster(depcode) partial(_r* _Y*)  fe ; 
		outreg2  cofint_dvxlinternalp   oilprod88_dvxlop          using  kidnappings_hrdag_pp.xls,  append se  bdec(3) tdec(3) nocons nor noni; 
		}; 