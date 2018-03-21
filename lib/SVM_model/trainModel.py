import numpy as np
from sklearn import svm
from sklearn.externals import joblib

import CrossValidation

label_train_dir = "../data/train/label/"
output_train_dir = "../output/train/"
output_model_dir = "../output/model/"

def trainClassifier(featureSelect, C_opt, gamma_opt):
    trainData = np.load(output_train_dir + featureSelect + "_constructData.npy")    
    trainData = np.float32(trainData)
    trainLabel = np.load(label_train_dir + "label.npy")
    trainLabel = trainLabel.reshape(-1)

    clf = svm.SVC(C=C_opt, gamma = gamma_opt, kernel='rbf') 
    clf.fit(trainData, trainLabel)  
    print("Classifier:")
    print(clf)
    
    filename = output_model_dir + featureSelect + "_SVM_model.pkl"
    joblib.dump(clf, filename)  