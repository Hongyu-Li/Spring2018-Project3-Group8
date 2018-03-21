setwd('C:/Users/rolco/Desktop/project3')
sift<-read.csv('data/train/SIFT_train.csv',header=F,sep=',')
sift<-sift[,-1]
label<-read.csv('data/train/label_train.csv',header=T,sep=',')
y<-as.factor(label$label)
sift<-cbind(y,sift)

#divide data into train data and test data
set.seed(123)
samp<-sample(1:nrow(sift),3000*0.8)
train.data<-sift[samp,]
test.data<-sift[-samp,]


#ISOMAP
source('lib/SIFT_isomap_GBM/isomap_process.R')
train.isomap<-isomap_process(train.data[,-1],20)$points
test.isomap<-isomap_process(test.data[,-1],20)$points
train.isomap<-as.data.frame(train.isomap)
test.isomap<-as.data.frame(test.isomap)
train.isomap<-data.frame(y=train.data$y,train.isomap)
test.isomap<-data.frame(y=test.data$y,test.isomap)


#tune parameters and get test error
source('lib/SIFT_GBM/gbm_model.R')
source('lib/SIFT_GBM/gbm_cv.R')
source('lib/SIFT_GBM/gbm_test.R')
ntrees = c(100,300,500)
shrinkages = c(0.01,0.05,0.1)
interactiondepths = c(1,3,5)
tuned.gbm<-cv_gbm(train.isomap,5,ntrees,shrinkages,interactiondepths)

gbm.mod<-gbm_model(train.isomap,tuned.gbm$ntree,tuned.gbm$shrinkage,tuned.gbm$interaction.depth)
isomap_error<-gbm_test(gbm.mod,test.isomap)
