package com.ncke.knntests

import com.ncke.kml_knn.KNNClassifier
import com.ncke.kml_knn.KNNDataSet
import kotlin.test.Test
import kotlin.test.assertEquals

class KNNClassifierTests {

    fun makeClassifiableDataSet(): KNNDataSet {
        val dataSet = KNNDataSet()

        // Cluster 1.
        dataSet.addExample(1, listOf(1.0, 2.0))
        dataSet.addExample(1, listOf(0.0, 1.0))
        dataSet.addExample(1, listOf(1.0, 1.0))
        dataSet.addExample(1, listOf(1.0, 0.0))
        dataSet.addExample(1, listOf(0.0, 2.0))

        // Cluster 2.
        dataSet.addExample(2, listOf(8.0, 7.0))
        dataSet.addExample(2, listOf(7.0, 8.0))
        dataSet.addExample(2, listOf(9.0, 7.0))
        dataSet.addExample(2, listOf(9.0, 9.0))
        dataSet.addExample(2, listOf(8.0, 8.0))

        // Outlier.
        dataSet.addExample(2, listOf(5.0, 5.0))

        return dataSet
    }

    @Test
    fun testClusterClassifications() {
        val dataSet = makeClassifiableDataSet()

        val trainingSet = KNNDataSet()
        val examples = dataSet.examples()
        val idxs = listOf<Int>(0, 1, 2, 3, 5, 6, 7, 8)
        for (idx in idxs) {
            val example = examples[idx]
            trainingSet.addExample(example.knownClassification, example.features)
        }

        val classifier = KNNClassifier(3, trainingSet)

        val test1 = examples[4]
        val classification1 = classifier.classify(test1.features)
        assertEquals(1, classification1)

        val test2 = examples[9]
        val classification2 = classifier.classify(test2.features)
        assertEquals(2, classification2)

        val test3 = examples[10]
        val classification3 = classifier.classify(test3.features)
        assertEquals(2, classification3)
    }

}