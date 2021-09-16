SL.rpart_ck =
  function(Y, X, newX, family, obsWeights,
           # Changing this from the default for rpart of 0.01
           cp = 0.001,
           minsplit = 20L,
           maxdepth = 20L,
           minbucket = 5L,
           split = "information",
           loss_positive = 1,
           loss_negative = 1,
           # Whether to save the outcome variable in the result object.
           y = FALSE,
           prune = FALSE,
           # Needed for prediction, but saves a copy of the data (high memory waste).
           terms = TRUE,
           xval = if (prune) 10L else 0L,
           ...) {
    # .SL.require("rpart")
  
  rp_control = rpart::rpart.control(cp = cp,
                                    minsplit = minsplit,
                                    xval = xval,
                                    maxdepth = maxdepth,
                                    minbucket = minbucket)
  
  if (family$family == "gaussian") {
    method = "anova"
    parms = NULL
  } else {
    method = "class"
    parms = list(loss = matrix(c(0, loss_positive, loss_negative, 0), ncol = 2),
                 split = split)
  }
  
  fit.rpart =
    rpart::rpart(Y ~ .,
                 data = data.frame(Y, X),
                 y = y,
                 control = rp_control,
                 method = method,
                 parms = parms,
                 weights = obsWeights)
                 #weights = case_weights)
  
  if (prune) {
    # TODO: support min or 1SE complexity parameter selection.
	  best_complexity <- fit.rpart$cptable[which.min(fit.rpart$cptable[, "xerror"]), "CP"]
	  fit.rpart <- rpart::prune(fit.rpart, cp = best_complexity)
  }
	
	if (family$family == "gaussian") {
    pred <- predict(fit.rpart, newdata = newX)
	} else {
    pred <- predict(fit.rpart, newdata = newX)[, 2]
	}
  
  # Clear out a huge environment.
  environment(fit.rpart$terms) = NULL
  
  #if (!terms) {
    # Remove the terms element, which is huge.
  #  fit.rpart$terms = NULL
  #}
	
  fit <- list(object = fit.rpart)
  out <- list(pred = pred, fit = fit)
  class(out$fit) <- c("SL.rpart")
  return(out)
}

# Save the old name for backwards compatability
SL.rpart_weighted = SL.rpart_ck


SL.rpartPrune_weighted =
  function(Y, X, newX, family, obsWeights, cp = 0.001, minsplit = 20, xval = 10,
           maxdepth = 20, minbucket = 5, ...) {
    # .SL.require("rpart")
    
    rp_control = rpart::rpart.control(cp = cp,
                                      minsplit = minsplit,
                                      xval = xval,
                                      maxdepth = maxdepth,
                                      minbucket = minbucket)
    
    if (family$family == "gaussian") {
      method = "anova"
      parms = NULL
    } else {
      method = "class"
      parms = list(loss = matrix(c(0, positive_weight, 1, 0), ncol = 2),
                   split = "information")
      #parms = list(split = "information")
    }
    
    fit.rpart =
      rpart::rpart(Y ~ .,
                   data = data.frame(Y, X),
                   control = rp_control,
                   method = method,
                   parms = parms,
                   weights = obsWeights)
                   #weights = case_weights)
    
    # Clear out a huge environment.
    environment(fit.rpart$terms) = NULL
    
		CP <- fit.rpart$cptable[which.min(fit.rpart$cptable[, "xerror"]), "CP"]
		fitPrune <- rpart::prune(fit.rpart, cp = CP)
		
		if (family$family == "gaussian") {
      pred <- predict(fitPrune, newdata = newX)
		} else {
      pred <- predict(fitPrune, newdata = newX)[, 2]
		}
		
    fit <- list(object = fitPrune, fit = fit.rpart, cp = CP)
    out <- list(pred = pred, fit = fit)
    class(out$fit) <- c("SL.rpart")
    return(out)
}
