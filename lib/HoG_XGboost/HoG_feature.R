#This function is used to extract HOG features
HOG_feature <- function(path, export=T){
  library(EBImage)
  library(plyr)
  library(OpenImageR)
  
  n_images<- length(list.files(path))
  hog.feature<-matrix(NA,n_images,54)
  
  for (i in 1:n_images){
    raw.mat <- readImage(paste0(path,sprintf("%04.f",i), ".jpg"))
    hog.feature[i,] <- HOG(raw.mat)
  }
  
  ### output constructed features
  if(export){
    write.csv(hog.feature,file = "output/hog_feature.csv")
  }
  return(data.frame(hog.feature))
}

setwd('C:/Users/rolco/Desktop/project3')
HOG_features<-HOG_feature('data/train/images/',T)
