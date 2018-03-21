cv_gbm<-function(data,k,ntrees,shrinkages,interactiondepths){
  total=length(ntrees)*length(interactiondepths)*length(shrinkages)
  cv_df= data.frame(ntree = rep(NA,total),
                    shrinkage = rep(NA,total),
                    interactiondepth = rep(NA,total),
                    error = rep(NA,total))
  count=1
  for (n in 1:length(ntrees)){
    for (s in 1:length(shrinkages)){
      for (i in 1:length(interactiondepths)){
        error<-rep(NA,k)
        for (j in 1:k){
          validation_index=c((j-1)*(nrow(data)%/%k)+1:(nrow(data)%/%k)) 
          train_index=c(1:nrow(data))[-validation_index]  
          model=gbm_model(data[train_index,],ntrees[n],shrinkages[s],interactiondepths[i])
          best.iter=gbm.perf(model,method="OOB", plot.it = FALSE)
          pred=predict(model,data[validation_index,],best.iter,type='response')
          class=apply(pred,1,which.max)
          error[j]=mean(class!=data[validation_index,1])
        }
        cv_df[count,4]<-mean(error)
        cv_df[count,1:3]<-c(ntrees[n],shrinkages[s],interactiondepths[i])
        count=count+1
      }
    }
  }
  best.para=cv_df[which.min(cv_df$error),1:3]
  return(list(ntree=best.para[,1],shrinkage=best.para[,2],interaction.depth=best.para[,3],
              cv.error=min(cv_df$error)))
}



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
  return(list(eta=best.para[,'eta'],max_depth=best.para[,'max_depth'],
              min_child_weight=best.para[,'min_child_weight'],
              cv.error=min(cv_df$error)))
}