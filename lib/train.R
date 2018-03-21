gbm_model <- function(data,ntree=NA,shrinkage=NA,interactiondepth=NA){
  
  ### Train a GBM classifier using features of training images
  
  ### Input:
  ### - training data including features of training images 
  ###   and class labels of training images
  ### - parameters(ntree,shrinkage,interactiondepth)
  ### Output:
  ### - training gbm model specification
  
  ### load libraries
  library(gbm)
  
  ### train with GBM
  if(is.na(ntree) | is.na(shrinkage) | is.na(interactiondepth)){
    ntree = 100
    interactiondepth = 1
    shrinkage = 0.01
  }
  else{
    ntree = ntree
    interactiondepth =interactiondepth
    shrinkage = shrinkage
  }
  
  model<-gbm(y~.,data=data,distribution="multinomial",n.trees=ntree,
             shrinkage=shrinkage,interaction.depth = interactiondepth,
             n.minobsinnode = 0)
  
  return(model)
}

xgboost_model<-function(data,paras=NULL){
  ### Train a Xgboost classifier using features of training images
  
  ### Input:
  ### - training data including features of training images 
  ###   and class labels of training images
  ### - paramters(data.frame contains max_depth, eta, nrounds)
  ### Output:
  ### - training Xgboost model specification
  
  library(xgboost)
  
  if(is.null(paras)){
    max_depth = 3
    eta = 0.5
    min_child_weight = 5
  } 
  else {
    max_depth<-paras['max_depth']
    eta<-paras['eta']
    min_child_weight<-paras['min_child_weight']
  }
  
  model<-xgboost(data = data.matrix(data[,-1]),
                 label = data[,1],
                 eta = eta,
                 max_depth = max_depth,
                 min_child_weight=min_child_weight,
                 nrounds = 5,   #make model more robust
                 num_class = 3,
                 metrics = "merror",
                 objective = "multi:softmax")
  return(model)
}
