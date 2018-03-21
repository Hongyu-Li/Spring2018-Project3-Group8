setwd('C:/Users/rolco/Desktop/project3')
orb.train<-read.csv('output/ORB_train.csv',header=F,sep=',')
orb.train<-orb.train[-1,]
orb.test<-read.csv('output/ORB_test.csv',header=F,sep=',')
orb.test<-orb.test[-1,]
train.label<-read.csv('output/train_label_orb.csv',header=T,sep=',')
test.label<-read.csv('output/test_label_orb.csv',header=T,sep=',')
train.y<-train.label[,1]-1
test.y<-test.label[,1]-1
train.data<-cbind(y=train.y,orb.train)
test.data<-cbind(y=test.y,orb.test)


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

