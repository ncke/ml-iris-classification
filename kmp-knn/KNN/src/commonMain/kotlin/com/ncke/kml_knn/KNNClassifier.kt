package com.ncke.kml_knn

class KNNClassifier constructor(val k: Int, val trainingDataSet: KNNDataSet) {

    fun classify(features: List<Double>): Int? {
        if (trainingDataSet.size() == 0)
            return null

        if (features.size != trainingDataSet.featureCount())
            throw Exception("Feature count is inconsistent with trained examples")

        val nearest = nearestNeighboursOf(features)
        val classification = modalClassificationOf(nearest)

        return classification
    }

    private fun modalClassificationOf(nearest: List<KNNDataSet.Example>): Int? {
        return nearest
            .map { it.knownClassification }
            .groupingBy { it }
            .eachCount()
            .maxByOrNull { it.value }
            ?.key
    }

    private fun nearestNeighboursOf(features: List<Double>): List<KNNDataSet.Example> {
        return trainingDataSet
            .examples()
            .map { Pair(it, distanceTo(it, features)) }
            .sortedBy { it.second }
            .take(k)
            .map { it.first }
    }

    private fun distanceTo(example: KNNDataSet.Example, features: List<Double>): Double {
        var sum = 0.0

        for (pair in features.zip(example.features)) {
            val diff = pair.first - pair.second
            sum += diff * diff
        }

        return sum
    }

}