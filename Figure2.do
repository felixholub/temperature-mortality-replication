* ==========================================================================================
*  Information
* ==========================================================================================
/* 
	This script replicates parts of https://www.journals.uchicago.edu/doi/full/10.1086/684582
	"Adapting to Climate Change: The Remarkable Decline in the U.S. Temperature-Mortality Relationship over the 20th Century"
	by Alan Barreca, Karen Clay, Olivier Deschenes, Michael Greenstone, and Joseph S. Shapiro (2016)
	Journal of Political Economy 124(1): 105-159.
 */


* ==========================================================================================
*  Setup
* ==========================================================================================
use problemset_data, clear
* in case this file is not found, Stata is not working in the same directory as this file
* resolve this by reopening Stata by double-clicking on this do file, or run the
* following command, specifying the directory where you storew the data for this problem set
* Example in my case: 
* cd "C:/Users/holub/Dropbox/Uni/Teaching/Environmental Economics/src/stata_mortality"

* if you want to understand the structure of the data, try these commands:
* describe
* summarize
* browse

* create lags and first differences of the ten counts of daily average temperature
forvalues i=1/10 {
	gen L1_b10_`i'=L1.b10_`i'
	gen D1_b10_`i'=D1.b10_`i'
}

* define variables for the regression, omitting the 60-69°F categories
global lagvars L1_b10_1 L1_b10_2 L1_b10_3 L1_b10_4 L1_b10_5 L1_b10_6 o.L1_b10_7 L1_b10_8 L1_b10_9 L1_b10_10
global diffvars D1_b10_1 D1_b10_2 D1_b10_3 D1_b10_4 D1_b10_5 D1_b10_6 o.D1_b10_7 D1_b10_8 D1_b10_9 D1_b10_10

* ==========================================================================================
*  Plot Options
* ==========================================================================================

* Variables that shall be plotted
global lagcoefs L1_b10_1 L1_b10_2 L1_b10_3 L1_b10_4 L1_b10_5 L1_b10_6 L1_b10_7 L1_b10_8 L1_b10_9 L1_b10_10
* Other options
global plotoptions vert yline(0) omitted recast(connected) ciopts(recast(rconnected) lpattern(dash) lcolor(gray) mcolor(gray)) ylabel(-0.01(.01)0.04) xlabel(1 "<10" 2 "10-19" 3 "20-29" 4 "30-39" 5 "40-49" 6 "50-59" 7 "60-69" 8 "70-79" 9 "80-89" 10 ">90", angle(45)) xtitle("Daily Average Temperature (°F)") ytitle("Log Mortality Rate")

* ==========================================================================================
*  Regressions
* ==========================================================================================

* Outcome
global y lndrate
* Precipitation controls
global rain devp25 devp75
* Weights
global weights totalpop
* Cluster variable for standard error calculation
global clustervar stfips
* Absorbed variables that are categeorical or categorical interactions with continuous variables
global absorbvars month#c.(sh_0000 sh_4564 sh_6599) stfips#month##c.(year year2) year#month
* Same as above, but with the GDP variable
global absorbvars_gdp $absorbvars month#c.lri

/* 1900 - 2004 */
reghdfe $y $lagvars $diffvars $rain [aw=$weights], cluster($clustervar) abs($absorbvars)
coefplot, keep($lagcoefs) title("1900-2004") name(panela, replace) $plotoptions

/* 1930 - 2004 */
reghdfe $y $lagvars $diffvars $rain if (year>=1930 & year<=2004) [aw=$weights], cluster($clustervar) abs($absorbvars_gdp)
coefplot, keep($lagcoefs) title("1930-2004") name(panelb, replace) $plotoptions

/* 1930 - 1959 */
reghdfe $y $lagvars $diffvars $rain if (year>=1930 & year<=1959) [aw=$weights], cluster($clustervar) abs($absorbvars_gdp)
coefplot, keep($lagcoefs) title("1930-1959") name(panelc, replace) $plotoptions

/* 1960 - 2004 */
reghdfe $y $lagvars $diffvars $rain if (year>=1960 & year<=2004) [aw=$weights], cluster($clustervar) abs($absorbvars_gdp)
coefplot, keep($lagcoefs) title("1960-2004") name(paneld, replace) $plotoptions


* ==========================================================================================
*  Combine plots
* ==========================================================================================

graph combine panela panelb panelc paneld, xsize(8) ysize(6) title("Mortality rates and temperature")
graph export "Figure2.png", replace


