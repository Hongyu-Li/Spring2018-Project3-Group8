#This function is used to build xgboost model
library(xgboost)
xgboost_model<-function(data,paras){
  #paras is a list which contains max_depth, eta, min_child_weight
  max_depth<-paras['max_depth']
  eta<-paras['eta']
  min_child_weight<-paras['min_child_weight']
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


