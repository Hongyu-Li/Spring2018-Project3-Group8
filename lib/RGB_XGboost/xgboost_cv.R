#This function is used to undergo cross validation for gbm
cv_xgboost<-function(data,k,paras_df){
  cv_df= data.frame(paras_df,
                    error=rep(NA,nrow(paras_df)))
  for (i in 1:nrow(paras_df)){
    error<-rep(NA,k)
    for (j in 1:k){
      validation_index=c((j-1)*(nrow(data)%/%k)+1:(nrow(data)%/%k)) 
      train_index=c(1:nrow(data))[-validation_index]  
      model=xgboost_model(data[train_index,],paras_df[i,])
      error[j]=xgboost_test(model,data[validation_index,])
    }
    cv_df[i,4]<-mean(error)
  }
  best.para=cv_df[which.min(cv_df$error),1:3]
  return(list(eta=best.para[,1],max_depth=best.para[,2],min_child_weight=best.para[,3],
              cv.error=min(cv_df$error)))
}



