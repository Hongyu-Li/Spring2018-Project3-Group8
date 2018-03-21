RGB_feature<-function(img_dir, export=TRUE){
  
  ### Construct process features for training/testing images
  ### RGB: calculate the Frequency of Color Histogram for an image
  
  ### Input: a directory that contains images ready for processing
  ### Output: an .csv file contains processed features for the images
  
  
  library(EBImage)
  library(plyr)
  #define bins of color histogram for each channel
  nR <- 8 
  nG <- 8
  nB <- 8 
  Rbin <- seq(0, 1, length.out=nR)
  Gbin <- seq(0, 1, length.out=nG)
  Bbin <- seq(0, 1, length.out=nB)
  n_images<- length(list.files(img_dir))
  
  image_hist_count<-function(pos){
    mat <- imageData(readImage(paste0(img_dir,sprintf("%04.f",pos), ".jpg")))
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
    write.csv(rgb_feature, file = "..//output/rgb_feature_test.csv")
  }
  return(data.frame(rgb_feature))
}


#rgb<-RGB_feature(paste(img_train_dir,'images/',sep=''),T)
