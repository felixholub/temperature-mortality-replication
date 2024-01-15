# Exercise List

- Look the code in the file `Figure2.do`. It replicates Figure 2 in the paper and stores it in your working directory. As you can see, the impact of temperature extremes falls over the 20th century. Make sure to understand the code and how it matches the paper. To understand the `reghdfe` command, in particular the `absorb()` option, you can read the help file by typing `help reghdfe` in Stata. The notation "o.VARIABLE" includes a variable in the regression that will actually be omitted. One does this to have a zero that can easily plotted at the benchmark temperature level.

- Estimate a similar model, but without taking into account the mortality replacement, so only on the variables `b10_1 b10_2 b10_3 b10_4 b10_5 b10_6 o.b10_7 b10_8 b10_9 b10_10`. Compare the estimates to (your) Figure 2.

- Figure 4 shows coefficients on the interaction of the `L1_b10_*` terms with the share of households with air conditioning `i2_ac`. For the period 1960-2004, estimate this model and plot the relevant coefficients. Check that they match Figure 4 in the paper. Hint for the creation of the additional variables:

```
* create interaction terms of temperature bins with the share of households with AC
forvalues i=1/10 {
	gen i_b10_`i'=i2_ac*b10_`i'
}

* create lags and first differences of the ten counts of daily average temperature and the
forvalues i=1/10 {
	gen L1_b10_`i'=L1.b10_`i'
	gen D1_b10_`i'=D1.b10_`i'
	gen L1_i_b10_`i'=L1.i_b10_`i'
	gen D1_i_b10_`i'=D1.i_b10_`i'
}
```
