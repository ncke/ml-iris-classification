//
//  IrisClassifier.swift
//  ml-iris-classification
//
//  Created by Nick on 03/03/2023.
//

import Combine
import Foundation
import KNN


class IrisClassifier: ObservableObject {
    
    @Published var examples: [Example]
    
    @Published var trainingSetSize: Int? {
        didSet {
            recompute()
        }
    }
    
    init() {
        examples = IrisClassifier.readData()
        trainingSetSize = examples.count / 2
    }
    
}

extension IrisClassifier {
    
    private func recompute() {
        guard let size = trainingSetSize, !examples.isEmpty else {
            return
        }
        
        let partitioned = partition(examples, size: size)
        let classified = classify(partitioned)
        
        examples = classified
    }
    
    private func classify(_ examples: [Example]) -> [Example] {
        let classifier = KNNClassifier()
        
        for example in examples where example.dataSet == .training {
            example.knnClassification = nil
            let classification = Int32(example.knownClassification.rawValue)
            let features = example.features.map { KotlinDouble(double: $0) }
            classifier.train(classification: classification, features: features)
        }
        
        for example in examples where example.dataSet == .test {
            let features = example.features.map { KotlinDouble(double: $0) }
            guard
                let outcome = classifier.classify(k: 3, features: features),
                let knnClassification = IrisClass(
                    rawValue: Int(truncating: outcome))
            else {
                fatalError()
            }
            
            example.knnClassification = knnClassification
        }
        
        return examples
    }
    
    private func partition(_ examples: [Example], size: Int) -> [Example] {
        var available = examples
        let actualSize = min(available.count, max(1, size))
        var training = [Example]()
        
        available.forEach { example in example.dataSet = .test }
    
        for _ in 1...actualSize {
            guard let idx = (0..<available.count).randomElement() else {
                fatalError()
            }
            
            let example = available[idx]
            example.dataSet = .training
            training.append(example)
            available.remove(at: idx)
        }
        
        return available + training
    }
    
}

extension IrisClassifier {
    
    class Example {
        
        enum DataSet {
            case training, test
        }
        
        let knownClassification: IrisClass
        var knnClassification: IrisClass?
        let features: [Double]
        var dataSet: DataSet
        
        init(knownClassification: IrisClass, knnClassification: IrisClass?, features: [Double], dataSet: DataSet) {
            self.knownClassification = knownClassification
            self.features = features
            self.dataSet = dataSet
        }
        
        func isSuccessfulClassification() -> Bool? {
            guard let knnClassification = knnClassification else {
                return nil
            }
            
            return knownClassification == knnClassification
        }
        
    }

}

extension IrisClassifier {
    
    enum IrisClass: Int, CustomStringConvertible {
        case setosa
        case versicolour
        case virginica
        
        init(dataName: String) {
            switch dataName {
            case "Iris-setosa": self = .setosa
            case "Iris-versicolor": self = .versicolour
            case "Iris-virginica": self = .virginica
            default: fatalError()
            }
        }
        
        var description: String {
            switch self {
            case .setosa: return "Iris Setosa"
            case .versicolour: return "Iris Versicolour"
            case .virginica: return "Iris Virginica"
            }
        }
    }
    
}

extension IrisClassifier {
    
    private static func readData() -> [Example] {
        let url = Bundle.main.url(forResource: "iris", withExtension: "data")!
        let content = try! String(contentsOf: url)
        let records = content.components(separatedBy: .newlines)
        let commas = CharacterSet(charactersIn: ",")
        var examples = [Example]()
        
        for record in records {
            let fields = record.components(separatedBy: commas)
            guard fields.count == 5 else {
                continue
            }
            
            let features = fields.prefix(4).map { featureString in
                guard let featureDouble = Double(featureString) else {
                    fatalError()
                }
                
                return featureDouble
            }
            
            let irisName = fields.suffix(1).first!
            let classification = IrisClass(dataName: irisName)
            
            let example = Example(
                knownClassification: classification,
                knnClassification: nil,
                features: features,
                dataSet: .training)
            
            examples.append(example)
        }
        
        return examples
    }
    
}
