import numpy as np
from sklearn import svm
from sklearn.externals import joblib

output_test_dir = "../output/test/"
output_model_dir = "../output/model/"

label_test_dir = "../data/test/label/"

def classify(featureSelect):
    svm = joblib.load(output_model_dir + featureSelect + "_SVM_model.pkl") 
    testData = np.load(output_test_dir + featureSelect + "_constructData.npy")
    testData = np.float32(testData)
    testLabel = np.load(label_test_dir + "label.npy")
    testLabel = testLabel.reshape(-1)
            
    crt = 0        
    count = 0
    for i in range(testLabel.shape[0]):
        if testLabel[i] == svm.predict(testData[i].reshape(1, -1)):
            crt += 1
        count += 1

    print("Total accuracy: ", str(crt), "/", str(count), "=", str(round(crt/count,4)))