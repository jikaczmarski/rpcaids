pcaids2good <- function(regression_good_i, aggregate_market_demand, share_i) {
  #
  #   Calculates own- and cross-price elasticities for a two-good PC-AIDS.
  #   
  #   Calculates own- and cross-price elasticities for a two-good PC-AIDS based on
  #   the equations from Coloma (2006).
  #   
  #   Parameters
  #   ---
  #   regression_good_i : R object of class("rlm","lm")
  #       R regression object for good i
  #   aggregate_market_demand : R object of class("rlm","lm")
  #       R regression object for the aggregate demand curve
  #   share_i : R object for the variable representing market share of good i
  #       E.g., data$share_i
  #   
  #   Returns
  #   ---
  #     A list containing two sub-lists: 1) own-price estimates, and 2) cross-price
  #     estimates.
  #     - own_price
  #       - own_price[1] : Mean Own-price elasticity of demand for good i
  #       - own_price[2] : Median Own-price elasticity of demand for good i
  #       - own_price[3] : T-statistic: Test Statistic (Ho: elasticity = 0)
  #       - own_price[4] : T-statistic: P Value
  #       - own_price[5] : T-statistic: Lower Bound 95% Confidence Interval
  #       - own_price[6] : T-statistic: Upper Bound 95% Confidence Interval
  #     - cross_price
  #       - cross_price[1] : Mean Cross-price elasticity of demand for good i
  #       - cross_price[2] : Median Cross-price elasticity of demand for good i
  #       - cross_price[3] : T-statistic: Test Statistic (Ho: elasticity = 0)
  #       - cross_price[4] : T-statistic: P Value
  #       - cross_price[5] : T-statistic: Lower Bound 95% Confidence Interval
  #       - cross_price[6] : T-statistic: Upper Bound 95% Confidence Interval
  # 
  # Notes
  # ---
  #   This does not check for any assumption requirements associated with the PC-
  #   AIDS model presented in Epstein and Rubinfeld (2002) and Coloma (2006). It
  #   is your responsibility to make sure these assumptions hold.
  # 
  # Warnings
  # ---
  #   - This does not check for any assumption requirements associated with the PC-
  #     AIDS model presented in Epstein and Rubinfeld (2002) and Coloma (2006). It
  #     is your responsibility to make sure these assumptions hold.
  #   - This function only allows linear models and/or robust linear models.
  #   - The first predictor in the model must be the price variable.
  #   - This model does not support repressed intercepts.
  
  # Supported classes
  s_c = c("lm","rlm") 
  
  # Basic argument testing
  if (inherits(regression_good_i, s_c)) {}
  else {stop("Arguments must be of classes:", paste(s_c, collapse=", "))}
  if (inherits(aggregate_market_demand, s_c)) {}
  else {stop("Arguments must be of classes:", paste(s_c, collapse=", "))}
  
  # Generalizing variables
  aii <- regression_good_i$coefficients[2] # Price ratio coeff from good i
  n <- aggregate_market_demand$coefficients[2] # Avg price coeff from aggregate demand function
  si <- share_i # Market share for good i, vector
  sj <- 1 - share_i # Market share for good j, vector
  ajj <- ((sj*(1-sj))/(si*(1-si)))*aii # Calculated a_jj
  aij <- ((-si)/(1-sj))*ajj  # Cross-price parameter assumption
  
  # Calculating sample own- and cross-price elasticity of demand
  oped <- ((-1) + (aii / si) + (si*(n + 1))) # Own-price elasticity for i
  cped <- (((aij)/(si)) + (sj*(n+1))) # Cross-price elasticity, i to j
  
  # Estimating sample means and medians for elasticity of demand
  m_oped <- mean(oped, na.rm=T) # Mean own-price elasticity for i
  md_oped <- median(oped, na.rm=T) # Median own-price elasticity for i
  m_cped <- mean(cped, na.rm=T) # Mean cross-price elasticity, i to j
  md_cped <- median(cped, na.rm=T) # Median cross-price elasticity, i to j
  
  # Conduct one sample t-tests
  t_oped <- t.test(oped) # Comparing mean of own-price to zero
  t_cped <- t.test(cped) # Comparing mean of cross-price to zero
  
  # Storing results in an list for access
  list("own_price" = c(m_oped, md_oped,
                       t_oped$statistic,
                       t_oped$p.value,
                       t_oped$conf.int[1],
                       t_oped$conf.int[2]), 
       "cross_price" = c(m_cped,
                         md_cped,
                         t_cped$statistic,
                         t_cped$p.value,
                         t_cped$conf.int[1],
                         t_oped$conf.int[2])
  )
}