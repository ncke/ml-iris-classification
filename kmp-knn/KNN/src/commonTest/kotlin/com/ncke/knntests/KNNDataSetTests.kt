package com.ncke.knntests

import com.ncke.kml_knn.KNNDataSet
import kotlin.test.Test
import kotlin.test.assertEquals

class KNNDataSetTests {

    fun makePopulatedDataSet(): KNNDataSet {
        val dataSet = KNNDataSet()
        dataSet.addExample(1, listOf(1.0, 2.0, 3.0))
        dataSet.addExample(2, listOf(2.0, 1.0, 4.0))
        dataSet.addExample(3, listOf(1.0, 2.5, 5.5))
        dataSet.addExample(1, listOf(8.0, 1.0, 3.0))
        dataSet.addExample(1, listOf(5.0, 2.1, 2.9))
        dataSet.addExample(2, listOf(2.0, 1.0, 5.0))
        dataSet.addExample(1, listOf(8.0, 2.5, 7.0))
        dataSet.addExample(3, listOf(6.0, 4.2, 4.0))
        dataSet.addExample(2, listOf(2.0, 3.5, 9.0))
        dataSet.addExample(1, listOf(1.0, 7.0, 4.5))

        return dataSet
    }

    @Test
    fun testAddExample() {
        val sut = KNNDataSet()
        assertEquals(0, sut.size())
        sut.addExample(1, listOf(1.0, 2.0, 3.0))
        assertEquals(1, sut.size())
    }

    @Test
    fun testPartition() {
        val sut = makePopulatedDataSet()
        assertEquals(10, sut.size())

        val parts = sut.partition(6)
        assertEquals(4, parts.first.size())
        assertEquals(6, parts.second.size())
    }

    @Test
    fun testMerge() {
        val original = makePopulatedDataSet()
        assertEquals(10, original.size())
        val parts = original.partition(6)

        val sut = parts.first.merge(parts.second)
        assertEquals(10, sut.size())
    }

    @Test
    fun testClassify() {
        val sut = makePopulatedDataSet()

        var before = 0
        for (example in sut.examples()) {
            if (example.knnClassification != null)
                before += 1
        }
        assertEquals(0, before)

        sut.classify(3,7)

        var after = 0
        for (example in sut.examples()) {
            if (example.knnClassification != null)
                after += 1
        }
        assertEquals(3, after)
    }

    @Test
    fun testResetClassifications() {
        val sut = makePopulatedDataSet()
        sut.classify(3,7)

        var before = 0
        for (example in sut.examples()) {
            if (example.knnClassification != null)
                before += 1
        }
        assertEquals(3, before)

        sut.resetKNNClassifications()

        var after = 0
        for (example in sut.examples()) {
            if (example.knnClassification != null)
                after += 1
        }
        assertEquals(0, after)
    }

    @Test
    fun testFeatureCount() {
        val sut = makePopulatedDataSet()
        assertEquals(3,sut.featureCount())
    }

}