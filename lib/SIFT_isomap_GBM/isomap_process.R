#This function is used to perform isomap
#install.packages('vegan')
library(vegan)
isomap_process<-function(feature_data,k){
  dis<-vegdist(feature_data)
  isomap.data<-isomap(dis,k=k)
  return(isomap.data)
}