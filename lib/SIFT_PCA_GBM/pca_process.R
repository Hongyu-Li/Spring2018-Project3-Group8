#This function is for performing pca on the data
pca_process<-function(feature_data,proportion){
  pc<-princomp(feature_data)
  prop<-cumsum(pc$sdev)/sum(pc$sdev)
  names(prop)<-NULL
  num<-which(prop>proportion)[1]
  loadings<-pc$loadings[,1:num]
  scores<-pc$scores[,1:num]
  return(list(loading=loadings,score=scores))
}
