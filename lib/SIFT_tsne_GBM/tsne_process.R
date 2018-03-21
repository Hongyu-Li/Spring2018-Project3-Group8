#This function is used to perform tsne
#install.packages('Rtsne')
library(Rtsne)
tsne_process<-function(feature_data,dim,perp,max_iter){
  proc<-Rtsne(feature_data, dims = dim, perplexity=perp, verbose=FALSE, 
              max_iter = max_iter)
  return(proc)
}