//
//  IrisClassifier.swift
//  ml-iris-classification
//
//  Created by Nick on 03/03/2023.
//

import Combine
import Foundation
import KNN

// MARK: - Iris Classifier

class IrisClassifier: ObservableObject {
    
    @Published var data: KNNDataSet
    
    @Published var k = 3 {
        didSet { reclassify() }
    }
    
    @Published var trainingSetSize = 0 {
        didSet { reclassify() }
    }
    
    var dataSetSize: Int { Int(data.size()) }
    
    init() {
        data = IrisClassifier.readData()
        trainingSetSize = Int(data.size()) / 2
    }
    
    private func reclassify() {
        let kk = Int32(k)
        let sz = Int32(trainingSetSize)
        data = data.classify(k: kk, trainingSetSize: sz)
    }
    
}

// MARK: - Variety

extension IrisClassifier {
    
    enum Variety: Int, CustomStringConvertible {
        case setosa
        case versicolour
        case virginica
        
        init(dataName: String) {
            switch dataName {
            case "Iris-setosa": self = .setosa
            case "Iris-versicolor": self = .versicolour
            case "Iris-virginica": self = .virginica
            default: fatalError("Unexpected iris name in the data set.")
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

// MARK: - Resource Helper

extension IrisClassifier {
    
    private static func readData() -> KNNDataSet {
        let dataSet = KNNDataSet()
        
        guard
            let url = Bundle.main.url(
                forResource: "iris",
                withExtension: "data"),
            let content = try? String(contentsOf: url)
        else {
            fatalError("Could not load iris data set.")
        }
        
        let records = content.components(separatedBy: .newlines)
        let commas = CharacterSet(charactersIn: ",")
        
        for record in records {
            let fields = record.components(separatedBy: commas)
            guard fields.count == 5 else { continue }
            
            let irisFeatures = fields.prefix(4).map { str in
                guard let feature = Double(str) else {
                    fatalError("Expected a double, got: \(str)")
                }
                return KotlinDouble(value: feature)
            }
            
            let irisName = fields.suffix(1).first!
            let irisClass = Int32(Variety(dataName: irisName).rawValue)
            
            dataSet.addExample(
                knownClassification: irisClass,
                features: irisFeatures)
        }
        
        return dataSet
    }
    
}
