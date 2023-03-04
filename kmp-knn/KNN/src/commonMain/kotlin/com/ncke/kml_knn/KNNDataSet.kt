package com.ncke.kml_knn

import kotlin.random.Random

class KNNDataSet private constructor(private var examples: MutableList<Example>) {

    data class Example(
        val knownClassification: Int,
        var knnClassification: Int?,
        val features: List<Double>)

    private var featureCount: Int? = null

    init {
        if (examples.isNotEmpty())
            this.featureCount = examples[0].features.size
    }

    constructor() : this(mutableListOf()) {}

    fun addExample(knownClassification: Int, features: List<Double>) {
        if (features.isEmpty())
            throw Exception("Cannot add a featureless example")

        if (featureCount != null && features.size != featureCount)
            throw Exception("Feature count is inconsistent with previous examples")

        val example = Example(knownClassification, null, features)
        examples.add(example)

        if (featureCount == null)
            featureCount = features.size
    }

    fun size(): Int {
        return examples.size
    }

    fun examples(): List<Example> {
        return examples
    }

    fun featureCount(): Int? {
        return featureCount
    }

    fun classify(k: Int, trainingSetSize: Int): KNNDataSet {
        val parts = partition(trainingSetSize)
        val testSet = parts.first
        val trainingSet = parts.second

        trainingSet.resetKNNClassifications()
        testSet.resetKNNClassifications()

        val classifier = KNNClassifier(k, trainingSet)

        for (example in testSet.examples) {
            val knnClassification = classifier.classify(example.features)
            example.knnClassification = knnClassification
        }

        val result = trainingSet.merge(testSet)
        return result
    }

    fun partition(size: Int): Pair<KNNDataSet, KNNDataSet> {
        val part1 = this.examples.toMutableList()
        val part2: MutableList<Example> = mutableListOf()
        val mostAvailable = if (part1.size > size) size else part1.size

        repeat (mostAvailable) {
            val idx = Random.nextInt(part1.size)
            val elem = part1[idx]

            part1.removeAt(idx)
            part2.add(elem)
        }

        val dataset1 = KNNDataSet(part1)
        val dataset2 = KNNDataSet(part2)
        return Pair(dataset1, dataset2)
    }

    fun merge(other: KNNDataSet): KNNDataSet {
        val mergedSet = KNNDataSet(examples)
        mergedSet.examples.addAll(other.examples)

        return mergedSet
    }

    fun resetKNNClassifications() {
        for (example in examples)
            example.knnClassification = null
    }

}