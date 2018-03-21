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


#principal component process
source('lib/SIFT_PCA_GBM/pca_process.R')
pca<-pca_process(train.data[,-1],0.7)
train.pca<-pca$score
test.pca<-as.matrix(test.data[,-1]) %*% as.matrix(pca$loading)
train.pca<-as.data.frame(train.pca)
test.pca<-as.data.frame(test.pca)
train.pca<-data.frame(y=train.data$y,train.pca)
test.pca<-data.frame(y=test.data$y,test.pca)


#tune parameters and get test error
source('lib/SIFT_GBM/gbm_model.R')
source('lib/SIFT_GBM/gbm_cv.R')
source('lib/SIFT_GBM/gbm_test.R')
ntrees = c(100,300,500)
shrinkages = c(0.01,0.05,0.1)
interactiondepths = c(1,3,5)
tuned.gbm<-cv_gbm(train.pca,5,ntrees,shrinkages,interactiondepths)

gbm.opt<-gbm_model(train.pca,tuned.gbm$ntree,tuned.gbm$shrinkage,tuned.gbm$interaction.depth)
#100 0.05 3 optimal
pca_error<-gbm_test(gbm.opt,test.pca)