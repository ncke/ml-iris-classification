# ml-iris-classification
Sharing a KNN classifier with SwiftUI using a Kotlin Multiplatform Library.

I wanted to evaluate Kotlin Multiplatform (KMP) as a way to share code between iOS, macOS, and Android applications.

## Background to the ML task.
The k-nearest neighbour (KNN) algorithm can be used to solve classification problems. When challenged with an example, it finds the k most-similar examples in the training set. Similarity is based on a distance metric, usually the euclidean distance between the parameters of the challenge example and the training set example. Since the nearest neighbours in the training set have known classifications, a voting mechanism can then be used to predict the classification of the challenge.

Classifying Iris varieties using the Iris data set is a classic machine learning exercise. The data set consists of 150 examples, each having four measurements from an Iris specimen and its correct variety: either Iris Setosa, Iris Versicolour, or Iris Virginica. The ML task is to use the data set to train a model that is capable of classifying further specimens given only the four measurements. Typically, a subset of the data set is used for training, while the remainder is used to test the trained model. KNN is suitable for this task.

## Implementation.

### Kotlin Multiplatform library.

The KMP-KNN project provides an implementation of the k-nearest neighbour algorithm in the `KNN` module. The implementation is independent of the Iris classification domain.

The `KNNClassifier` is instantiated with a given value for k, and a set of training examples. It can then predict the classification of further examples.

The `KNNDataSet` is used to store examples. It provides a `classify` method that randomly partitions the data set into training and test data. The training data is used to instantiate a classifier. The classifier is then used to predict values for the test data.

Unit tests are included for both classes.

### SwiftUI application.

The SwiftUI application targets iPhone, iPad, and macOS desktop.

The `IrisClassifier` model consumes the Iris data and uses it to establish a `KNNDataSet` of Iris specimens. The model provides interactivity with the k-parameter and the size of the training set. The data set is reclassified each time one of these parameters is changed.

The `ClassifierView` provides the user interface for interactivity with an `IrisClassifier`.

The `IrisChartView` uses the Swift Charts library to present a scatter plot of the data (the first two parameters for each specimen are used to provide an x-y position).

The plot has three modes:
- 'Iris Variety' shows the known classifications for every example in the data set.
- 'Data Set Membership' shows whether the example was used as training data or test data for the current iteration of classifications.
- 'KNN Outcome' focusses on test data, showing whether the classifier successfully predicted the variety.

### Screenshots.
| Iris Varieties | Data Set Membership | KNN Outcome |
|------------|------------|------------|
|![image](https://github.com/ncke/ml-iris-classification/blob/5676d610b9825fa578de72ad87161a2c884304d7/screenshots/varieties.png)|![image](https://github.com/ncke/ml-iris-classification/blob/5676d610b9825fa578de72ad87161a2c884304d7/screenshots/set-membership.png)|![image](https://github.com/ncke/ml-iris-classification/blob/5676d610b9825fa578de72ad87161a2c884304d7/screenshots/knn-outcome.png)|
- Iris varieties are colour-coded as Setosa, Versicolour, or Virginica.
- Data set membership shows whether each example is in the training data or was used as test data.
- KNN outcome labels successful predictions in green and failed predictions in red. Training data is not used for prediction (so grey).
## Conclusions.

Kotlin Multiplatform is a workable alternative for code sharing. Some frameworks, such as Flutter or React Native, require that the entirety of the application is wrapped developed inside the framework. KML, however, is unopiniated about the boundary between native code and shared code. This makes it particularly suitable for building shared libraries.

The KMP library is built in Xcode using a run script which generates a linkable framework. Once the necessary build settings have been established, accessing the framework in Swift is as simple as `import KNN`. Build times were not problematic, and built frameworks can be cached if necessary.

Interoperability with Swift works well. Some primitive types, such as `Int`, must be cast to a known size, such as `Int32`, but this is understandable given the need for ABI-compatibility.

In addition to Xcode, the development toolchain also includes Android Studio which is used to develop the KMP library itself. While debugging the library from Xcode would be challenging, it is symbolicated with readable stack traces going back into Kotlin source code. Kotlin unit tests can also be used as a mechanism to investigate and resolve issues.

## Resources.
Fisher, R. A. (1936) 'Iris Data Set'. Available online: https://archive.ics.uci.edu/ml/datasets/iris

Kotlin (2023) 'Create and publish a multiplatform library'. Available online: https://kotlinlang.org/docs/multiplatform-library.html
