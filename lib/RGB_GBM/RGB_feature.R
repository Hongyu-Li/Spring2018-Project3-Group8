#This function is used to extract RGB color histogram features
RGB_feature <- function(path, export=T){
  library(EBImage)
  library(plyr)
  #define bins of color histogram for each channel
  nR <- 8 
  nG <- 8
  nB <- 8 
  Rbin <- seq(0, 1, length.out=nR)
  Gbin <- seq(0, 1, length.out=nG)
  Bbin <- seq(0, 1, length.out=nB)
  n_images<- length(list.files(path))
  
  image_hist_count<-function(pos){
    mat <- imageData(readImage(paste0(path,sprintf("%04.f",pos), ".jpg")))
    mat_as_rgb <-array(c(mat,mat,mat),dim = c(nrow(mat),ncol(mat),3))
    count_rgb <- as.data.frame(table(factor(findInterval(mat_as_rgb[,,1], Rbin), levels=1:nR), 
                                     factor(findInterval(mat_as_rgb[,,2], Gbin), levels=1:nG),
                                     factor(findInterval(mat_as_rgb[,,3], Bbin), levels=1:nB)))
    #find frequency in color histogram for specific combination
    rgb_feature <- as.numeric(count_rgb$Freq)/(nrow(mat)*ncol(mat))  
    return(rgb_feature)
  }
  
  rgb_feature<-ldply(1:n_images,image_hist_count)
  
  ### output constructed features
  if(export){
    write.csv(rgb_feature, file = "output/rgb_feature.csv")
  }
  return(data.frame(rgb_feature))
}

setwd('C:/Users/rolco/Desktop/project3')
RGB_features<-RGB_feature('data/images/',T)
