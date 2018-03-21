gbm_test = function(model, test_data) {
  ### Fit the GBM model with testing data
  
  ### Input: 
  ###  - the fitted GBM model using training data
  ###  - processed features from testing images
  ### Output: prediction error rate
  
  library(gbm)
  best.iter=gbm.perf(model,method="OOB", plot.it = FALSE)
  pred=predict(model,test_data,best.iter,type='response')
  class=apply(pred,1,which.max)
  error=mean(class!=test_data$y)
  return(error)
}


xgboost_test <- function(model,newdata){
  
  ### Fit the Xgboost model with testing data
  
  ### Input: 
  ###  - the fitted xgboost model using training data
  ###  -  processed features from testing images 
  ### Output: prediction error rate
  
  library(xgboost)
  pred=predict(model,as.matrix(newdata[,-1]))
  error=mean(pred!=newdata$y)
  return(error)
}

