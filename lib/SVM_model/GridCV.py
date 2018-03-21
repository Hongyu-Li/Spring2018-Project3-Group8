import numpy as np
from sklearn import svm
from sklearn.model_selection import GridSearchCV
from matplotlib.colors import Normalize
import matplotlib.pyplot as plt

class MidpointNormalize(Normalize):

    def __init__(self, vmin=None, vmax=None, midpoint=None, clip=False):
        self.midpoint = midpoint
        Normalize.__init__(self, vmin, vmax, clip)

    def __call__(self, value, clip=None):
        x, y = [self.vmin, self.midpoint, self.vmax], [0, 0.5, 1]
        return np.ma.masked_array(np.interp(value, x, y))
    
label_train_dir = "../data/train/label/"
output_train_dir = "../output/train/"

def GridCV(featureSelect, N_CV_fold):
    print("Now conduct cross validation ...")
    
    trainData = np.load(output_train_dir + featureSelect + "_constructData.npy")    
    trainData = np.float32(trainData)
    trainLabel = np.load(label_train_dir + "label.npy")
    trainLabel = trainLabel.reshape(-1)
    
    C_range = np.logspace(-2, 7, 10)
    gamma_range = np.logspace(-5, 4, 10)
    parameters = dict(gamma=gamma_range, C=C_range)
    svc = svm.SVC(kernel="rbf")
    grid = GridSearchCV(svc, parameters, cv=N_CV_fold)
    grid.fit(trainData, trainLabel)
    
    scores = grid.cv_results_['mean_test_score'].reshape(len(C_range),len(gamma_range))


    plt.figure(figsize=(8, 6))
    plt.subplots_adjust(left=.2, right=0.95, bottom=0.15, top=0.95)
    plt.imshow(scores, cmap=plt.cm.hot, interpolation="Nearest",
              norm=MidpointNormalize(vmin=0.2, midpoint=0.6))
    plt.xlabel('gamma')
    plt.ylabel('C')
    plt.colorbar()
    plt.xticks(np.arange(len(gamma_range)), gamma_range, rotation=45)
    plt.yticks(np.arange(len(C_range)), C_range)
    plt.title('Cross Validation for rbf-kernel SVM')
    plt.savefig("../figs/CV_" + featureSelect + "_SVM.jpg") 
    plt.show()
    
    parameters_opt = grid.cv_results_['params'][np.argmax(grid.cv_results_['mean_test_score'])]
    print('Select tuning parameter C =', parameters_opt['C'])
    print('Select tuning parameter gamma =', parameters_opt['gamma'])
    print('Corresponding test score = ', np.max(grid.cv_results_['mean_test_score']))
   
    return parameters_opt
    
    
    
    