setwd('C:/Users/rolco/Desktop/project3')
rgb<-read.csv('output/rgb_feature.csv',header=T,sep=',')
rgb<-rgb[,-1]
label<-read.csv('data/train/label_train.csv',header=T,sep=',')
y<-as.factor(label$label)
rgb<-cbind(y,rgb)

#divide data into train data and test data
set.seed(123)
samp<-sample(1:nrow(rgb),3000*0.8)
train.data<-rgb[samp,]
test.data<-rgb[-samp,]


#tsne
source('lib/SIFT_tsne_GBM/tsne_process.R')
train.tsne<-tsne_process(train.data[,-1],5,30,500)$Y
test.tsne<-tsne_process(test.data[,-1],5,30,500)$Y
train.tsne<-as.data.frame(train.tsne)
test.tsne<-as.data.frame(test.tsne)
train.tsne<-data.frame(y=train.data$y,train.tsne)
test.tsne<-data.frame(y=test.data$y,test.tsne)


#tune parameters and get test error
source('lib/SIFT_GBM/gbm_model.R')
source('lib/SIFT_GBM/gbm_cv.R')
source('lib/SIFT_GBM/gbm_test.R')
ntrees = c(100,300,500)
shrinkages = c(0.01,0.05,0.1)
interactiondepths = c(1,3,5)
tuned.gbm<-cv_gbm(train.tsne,5,ntrees,shrinkages,interactiondepths)

gbm.opt<-gbm_model(train.tsne,tuned.gbm$ntree,tuned.gbm$shrinkage,tuned.gbm$interaction.depth)
#100 0.05 3 optimal
tsne_error<-gbm_test(gbm.opt,test.tsne)