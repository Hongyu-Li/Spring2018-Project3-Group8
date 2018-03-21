setwd('C:/Users/rolco/Desktop/project3')
hog<-read.csv('output/hog_feature.csv',header=T,sep=',')
hog<-hog[,-1]
label<-read.csv('data/train/label_train.csv',header=T,sep=',')
y<-label$label-1  #xgboost label from 0 to num.class
hog<-cbind(y,hog)

#divide data into train data and test data
set.seed(123)
samp<-sample(1:nrow(hog),3000*0.8)
train.data<-hog[samp,]
test.data<-hog[-samp,]

source('lib/RGB_XGboost/xgboost_train.R')
source('lib/RGB_XGboost/xgboost_test.R')
source('lib/RGB_XGboost/xgboost_cv.R')
library(caret)
xgb_paras<-expand.grid(eta=c(0.01,0.1,0.5),max_depth=c(1,3),min_child_weight=c(1,3,5))
tuned.xgb<-cv_xgboost(train.data,5,xgb_paras)
best.paras<-data.frame(eta=tuned.xgb$eta,max_depth=tuned.xgb$max_depth,
                       min_child_weight=tuned.xgb$min_child_weight)
xgb.opt<-xgboost_model(train.data,best.paras)
xgb.error<-xgboost_test(xgb.opt,test.data)

