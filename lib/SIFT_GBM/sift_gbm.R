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


#Build model, tune parameter and evaluate
source('lib/SIFT_GBM/gbm_model.R')
source('lib/SIFT_GBM/gbm_cv.R')
source('lib/SIFT_GBM/gbm_test.R')
ntrees = c(100,300,500)
shrinkages = c(0.01,0.05,0.1)
interactiondepths = c(1,3,5)
tuned.gbm<-cv_gbm(train.data,5,ntrees,shrinkages,interactiondepths)

gbm.opt<-gbm_model(train.data,tuned.gbm$ntree,tuned.gbm$shrinkage,
                   tuned.gbm$interaction.depth)
test.error<-gbm_test(gbm.opt,test.data)
