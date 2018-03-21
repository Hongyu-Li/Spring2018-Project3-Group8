#This function is used to perform lle 
#install.packages('lle')
library(lle)
lle_process<-function(feature_data,k,reg){
  lle.data<-lle(feature_data,k,reg,ss=FALSE)
  return(lle.data)
}