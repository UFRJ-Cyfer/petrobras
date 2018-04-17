def convertSparseToClassNotation(y, axis = 0):
    import numpy as numpy
    import numpy.matlib

    if axis == 1:
        y = np.transpose(y)
        
    auxVector = np.arange(1,y.shape[0]+1,dtype=int).reshape((3,1))
    auxVector = np.matlib.repmat(auxVector,1,y.shape[1])
    y_classes = np.multiply(y,auxVector)
    y_classes = np.sum(y_classes,axis = 0)

    return y_classes



def plot_confusion_matrix(cm, classes,
                          normalize=False,
                          title='Confusion matrix',
                          cmap=plt.cm.Blues):
    import itertools
    import numpy as np
    import matplotlib.pyplot as plt
    
    """
    This function prints and plots the confusion matrix.
    Normalization can be applied by setting `normalize=True`.
    """
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Normalized confusion matrix")
    else:
        print('Confusion matrix, without normalization')

    print(cm)

    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)

    fmt = '.2f' if normalize else 'd'
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, format(cm[i, j], fmt),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")

    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')




import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.datasets import make_moons, make_circles, make_classification
from sklearn.neural_network import MLPClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.gaussian_process import GaussianProcessClassifier
from sklearn.gaussian_process.kernels import RBF
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
import sklearn.metrics as skmetrics
import sklearn.utils as skuts
import sklearn.model_selection as skms
import sklearn.preprocessing as skpre
import scipy.io as scio

class_names = ['SP','PE','PI']

names = ["Nearest Neighbors", "Linear SVM", "RBF SVM", "Gaussian Process",
         "Decision Tree", "Random Forest", "Neural Net", "AdaBoost",
         "Naive Bayes", "QDA"]

classifiers = [
    KNeighborsClassifier(3,weights='distance'),
    SVC(kernel="linear", C=0.025,class_weight ='balanced'),
    SVC(gamma=2, C=3, class_weight ='balanced'),
    GaussianProcessClassifier(1.0 * RBF(1.0)),
    DecisionTreeClassifier(max_depth=10, class_weight ='balanced'),
    RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1, class_weight ='balanced'),
    MLPClassifier(hidden_layer_sizes=(10,5), activation = 'tanh',alpha=0.1,solver = 'lbfgs',max_iter=1000),
    AdaBoostClassifier(),
    GaussianNB(),
    QuadraticDiscriminantAnalysis()]




p= scio.loadmat('J:\BACKUPJ\python.mat')
input = np.transpose(p['nnInput'])
target = np.transpose(p['nnTarget'])


input = skpre.StandardScaler().fit_transform(input)



nTries = 50
confMatrixTest = np.zeros((len(class_names), len(class_names), nTries, len(classifiers)))


i = 0

for name, clf in zip(names, classifiers):
    #ax = plt.subplot(1, len(classifiers) + 1, i)
    #print(clf)
    for k in range(0,nTries):
        X_train, X_test, y_train, y_test = \
        skms.train_test_split(input, target, test_size=.3)
        yy = convertSparseToClassNotation(y_train,axis=1)
        class_weights = skuts.compute_class_weight('balanced', np.unique(yy), yy)
        y_class_notation = convertSparseToClassNotation(y_train,axis=1)
        y_test_cn = convertSparseToClassNotation(y_test,axis=1)
        
        y_pred = clf.fit(X_train, y_class_notation).predict(X_test)
        score = clf.score(X_test, y_test_cn)
        confMatrix[:,:, k, i]= skmetrics.confusion_matrix(y_test_cn, y_pred)

   # print(clf)
    print(mean(confMatrix[:,:,:,i],axis=2))
    plt.figure()
    plot_confusion_matrix(mean(confMatrix[:,:,:,i],axis=2), class_names, normalize=True)
    plt.show()
    print(score)
    i+=1



