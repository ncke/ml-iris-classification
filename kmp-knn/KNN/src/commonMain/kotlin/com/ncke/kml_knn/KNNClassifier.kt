package com.ncke.kml_knn

class KNNClassifier {

    private data class Example(val classification: Int, val features: List<Double>)
    private var examples: List<Example> = emptyList()
    private var featureCount: Int? = null

    fun train(classification: Int, features: List<Double>) {
        if (featureCount != null && features.size != featureCount)
            throw Exception("Feature count is inconsistent with previous examples")

        var example = Example(classification, features)
        examples += example

        if (featureCount == null)
            featureCount = features.size
    }

    fun classify(k: Int, features: List<Double>): Int? {
        if (examples.size == 0)
            return null

        if (featureCount != null && features.size != featureCount)
            throw Exception("Feature count is inconsistent with previous examples")

        var nearest = nearestNeighbours(k, features)
        var classification = modalClassificationOf(nearest)

        return classification
    }

    fun reset() {
        examples = emptyList()
        featureCount = null
    }

    private fun modalClassificationOf(nearest: List<Example>): Int? {
        return nearest
            .map { it.classification }
            .groupingBy { it }
            .eachCount()
            .maxByOrNull { it.value }
            ?.key
    }

    private fun nearestNeighbours(k: Int, features: List<Double>): List<Example> {
        return examples
            .map { Pair(it, distanceTo(it, features)) }
            .sortedBy { it.second }
            .take(k)
            .map { it.first }
    }

    private fun distanceTo(example: Example, features: List<Double>): Double {
        var sum = 0.0

        for (pair in features.zip(example.features)) {
            var diff = pair.first - pair.second
            sum += diff * diff
        }

        return sum
    }

}