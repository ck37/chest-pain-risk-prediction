# TODO: use the better version in ck37r (supports observation weights).
SL.stratified = function(Y, X, newX, family, obsWeights, id, stratify_on, ...) {
  
  # Take the mean of Y over specific strata of X.
  stratified_pred =
    cbind(Y, X) %>% dplyr::group_by_at(stratify_on) %>%
    # We prefix with an underscore to minimize any conflict with column names in X.
    dplyr::mutate(`_pred` = mean(Y, na.rm = TRUE),
                  `_size` = dplyr::n()) %>%
    # Restrict to one row per stratum
    dplyr::filter(dplyr::row_number() == 1) %>%
    # We only need the stratum and the prediction.
    # Make sure to include the grouping cols to avoid a warning message.
    dplyr::select(dplyr::group_cols(), `_pred`, `_size`) %>% as.data.frame()
  
  # Now left_join with newX to generate prediction.
  preds = dplyr::left_join(newX, stratified_pred, by = stratify_on) %>% as.data.frame()
  
  # Replace any empty cells with the sample mean.
  # TODO: remove the highest cardinality grouping variable and see if that stratification solves it.
  missing_pred = is.na(preds$`_pred`)
  sample_mean = mean(Y, na.rm = TRUE)
  if (any(missing_pred)) {
    preds[missing_pred, "_pred"] = sample_mean
  }
 
  # fit returns all objects needed for predict()
  fit = list(object = stratified_pred,
             stratify_on = stratify_on,
             sample_mean = sample_mean)
  
  # Declare class of fit for predict()
  class(fit) = 'SL.stratified'
  
  # Return the result.
  out = list(pred = preds$`_pred`, fit = fit)
  return(out)
}


# Temporary version: use the ck37r version otherwise.
predict.SL.stratified =
  function(object, newdata, family, ...) {
  
 stratify_on = setdiff(names(object$object), c("_pred", "_size"))
  
  # Now left_join with newX to generate prediction.
  preds = dplyr::left_join(newdata, object$object, by = stratify_on) %>% as.data.frame()
  
  # Replace any empty cells with the sample mean.
  # TODO: remove the highest cardinality grouping variable and see if that stratification solves it.
  missing_pred = is.na(preds$`_pred`)
  if (any(missing_pred)) {
    preds[missing_pred, "_pred"] = mean(object$object$`_pred`, na.rm = TRUE)
  }
  
  return(preds$`_pred`)
}
