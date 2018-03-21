#This function is used to build gbm model
library(gbm)
gbm_model<-function(data,ntree,shrinkage,interactiondepth){
  model<-gbm(y~.,data=data,distribution="multinomial",n.trees=ntree,
             shrinkage=shrinkage,interaction.depth = interactiondepth,
             n.minobsinnode = 0)
  return(model)
}