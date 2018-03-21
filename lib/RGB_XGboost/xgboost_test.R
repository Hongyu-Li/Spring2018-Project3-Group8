#This function is used to calculate error rate on the test data.
library(xgboost)

xgboost_test<-function(model,newdata){
  pred=predict(model,as.matrix(newdata[,-1]))
  error=mean(pred!=newdata$y)
  return(error)
}