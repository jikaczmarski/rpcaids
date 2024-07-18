# Proportionally Calibrated Almost Ideal Demand System (PCAIDS) in R

## Overview

This repository contains R functions for the calculation of own- and cross-price elasticities of goods in the PCAIDS framework as described in,

  - Coloma, G. (2006). Econometric estimation of PCAIDS models. Empirical Economics, 31(3), 587–599. https://doi.org/10.1007/s00181-005-0033-6
  - Epstein, R. J., & Rubinfeld, D. L. (2007). Merger Simulation: A Simplified Approach with New Applications. Conferences on New Political Economy, 24(1), 281–316. https://doi.org/10.1628/186183407785978576

## Use

The process workflow for these scripts is to estimate the market share equations and the aggregate demand curve and store them as R linear (or robust linear) model objects. These objects are the input arguments for the elasticity calculation functions.

The user simply downloads `pcaids_functions.R` and sources them in their R script with a command such as,

`source("pcaids_functions.R")`

This gives access to the elasticity functions in `pcaids_functions.R`.

### Two-Good Problems

Importing `pcaids_functions.R` provides access to the `pcaids2good` function which is used for two-good problems. Given the assumptions in Coloma (2006), only one regression (for good $i$) is needed along with the aggregate demand curve regression.

#### Two-Good Methodology

Following the methodology of Coloma (2006), the `pcaids2good` function calculates own- and cross-price elasticities following,

$$\eta_{own} = -1 + \frac{a_{ii}}{S_i}+S_i(\eta + 1)$$

$$\eta_{cross} = \frac{a_{ij}}{S_i}+S_j(\eta + 1)$$

The function calculates the mean and median of these elasticities as well as a t-stat test with the null hypothesis that the elasticity is zero.


`pcaids2good(regression_good_i, aggregate_market_demand)`

```
  Calculates own- and cross-price elasticities for a two-good PC-AIDS.

  Calculates own- and cross-price elasticities for a two-good PC-AIDS based on
  the equations from Coloma (2006).

  Parameters
  ---
  reg_i : R object of class("rlm","lm")
      R regression object for good i
  aggregate_market_demand : R object of class("rlm","lm")
      R regression object for the aggregate demand curve

  Returns
  ---
  A list containing two sub-lists: 1) own-price estimates, and 2) cross-price
  estimates.
    - own_price
      - own_price[1] : Mean Own-price elasticity of demand for good i
      - own_price[2] : Median Own-price elasticity of demand for good i
      - own_price[3] : T-statistic: Test Statistic (Ho: elasticity = 0)
      - own_price[4] : T-statistic: P Value
      - own_price[5] : T-statistic: Lower Bound 95% Confidence Interval
      - own_price[6] : T-statistic: Upper Bound 95% Confidence Interval
    - cross_price
      - cross_price[1] : Mean Cross-price elasticity of demand for good i
      - cross_price[2] : Median Cross-price elasticity of demand for good i
      - cross_price[3] : T-statistic: Test Statistic (Ho: elasticity = 0)
      - cross_price[4] : T-statistic: P Value
      - cross_price[5] : T-statistic: Lower Bound 95% Confidence Interval
      - cross_price[6] : T-statistic: Upper Bound 95% Confidence Interval

  Notes
  ---
  This does not check for any assumption requirements associated with the PC-
  AIDS model presented in Epstein and Rubinfeld (2002) and Coloma (2006). It
  is your responsibility to make sure these assumptions hold.

  Warnings
  ---
    - This does not check for any assumption requirements associated with the PC-
      AIDS model presented in Epstein and Rubinfeld (2002) and Coloma (2006). It
      is your responsibility to make sure these assumptions hold.
    - This function only allows linear models and/or robust linear models.
    - The first predictor in the model must be the price variable.
    - This model does not support repressed intercepts.
```

### Future Models

I am currently working to expand the elasticity model to `n` goods but this is forthcoming.
