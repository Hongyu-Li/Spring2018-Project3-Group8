import cv2
import numpy as np
import os
import random
import pandas as pd
from sklearn.cluster import MiniBatchKMeans


def calFeature(img, whichOne):
    gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY)
    if whichOne == "SIFT": feature = cv2.xfeatures2d.SIFT_create(50)
    if whichOne == "SURF": feature = cv2.xfeatures2d.SURF_create(3000)
    if whichOne == "ORB": feature = cv2.ORB_create()
    (kps, des) = feature.detectAndCompute(gray, None)
    return des

def calcFeatVec(features, centers, K):
	featVec = np.zeros((1, K))
	for i in range(0, features.shape[0]):
		fi = features[i]
		diffMat = np.tile(fi, (K, 1)) - centers
		sqSum = (diffMat**2).sum(axis=1)
		dist = sqSum**0.5
		sortedIndices = dist.argsort()
		idx = sortedIndices[0] # index of the nearest center
		featVec[0][idx] += 1	
	return featVec

def extractFeature(in_dir, out_dir, featureSelect, d):
    featureSet = np.float32([]).reshape(0, d)
    count = len(os.listdir(in_dir)) 

    for file_name in os.listdir(in_dir):
        img = cv2.imread(in_dir + file_name)
        des = calFeature(img, featureSelect)
        featureSet = np.append(featureSet, des, axis=0)
    print("Extract", str(featureSet.shape), featureSelect, "features from", str(count), "images")
    
    filename = out_dir + featureSelect + "_features.npy"
    np.save(filename, featureSet)
    f = pd.DataFrame(featureSet)
    filename = out_dir + featureSelect + "_features.csv"
    f.to_csv(filename,index=False,sep=',')
    
def sampleFeature(out_dir, featureSelect, N_sample):
    filename = out_dir + featureSelect + "_features.npy"
    featureSet = np.load(filename)
    random.seed(2018)
    sample_index = random.sample(range(0, featureSet.shape[0]), N_sample)
    featureSet_sample = featureSet[sample_index]
    
    filename = out_dir + featureSelect + "_sampleFeatures.npy"
    np.save(filename, featureSet_sample)
    f = pd.DataFrame(featureSet_sample)
    filename = out_dir + featureSelect + "_sampleFeatures.csv"
    f.to_csv(filename,index=False,sep=',')

def learnVocabulary(out_dir, featureSelect, wordCnt):
    filename = out_dir + featureSelect + "_features.npy"
    features = np.load(filename)
          
    print("Method: Mini-Batch Kmeans")
    mbk = MiniBatchKMeans(init='k-means++', n_clusters=wordCnt, batch_size=50,
                          n_init=3, init_size=wordCnt*3, max_no_improvement=10, verbose=0)
    mbk.fit(features)
    centers = np.sort(mbk.cluster_centers_, axis=0)
        
    filename = out_dir + featureSelect + "_vocabularyCenters.npy"
    np.save(filename, centers)

def constructData(in_dir, out_dir, output_train_dir, featureSelect, K):    
    constructData = np.float32([]).reshape(0, K)
    filename = output_train_dir + featureSelect + "_vocabularyCenters.npy"
    centers = np.load(filename)

    for file_name in os.listdir(in_dir):
        img = cv2.imread(in_dir + file_name)
        des = calFeature(img, featureSelect)
        featVec = calcFeatVec(des, centers, K)
        constructData = np.append(constructData, featVec, axis=0)

    filename = out_dir + featureSelect + "_constructData.npy"
    np.save(filename, constructData)
    print("The shape of construct data is", str(constructData.shape))
    f = pd.DataFrame(constructData)
    filename = out_dir + featureSelect + "_constructData.csv"
    f.to_csv(filename,index=False,sep=',')
    
    
    
    
    