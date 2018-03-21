#This function is used to calculate error rate on the test data.
library(gbm)

gbm_test<-function(model,test_data){
  best.iter=gbm.perf(model,method="OOB", plot.it = FALSE)
  pred=predict(model,test_data,best.iter,type='response')
  class=apply(pred,1,which.max)
  error=mean(class!=test_data$y)
  return(error)
}