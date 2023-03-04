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
    
    let k = 3
    
    @Published var data: KNNDataSet
    
    @Published var trainingSetSize: Int = 0 {
        didSet {
            recompute()
        }
    }
    
    var dataSetSize: Int {
        return Int(data.size())
    }
    
    init() {
        data = IrisClassifier.readData()
        trainingSetSize = Int(data.size()) / 2
    }
    
}

extension IrisClassifier {
    
    private func recompute() {
        let kk = Int32(k)
        let sz = Int32(trainingSetSize)
        data = data.classify(k: kk, trainingSetSize: sz)
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
    
    private static func readData() -> KNNDataSet {
        let dataSet = KNNDataSet()
        let url = Bundle.main.url(forResource: "iris", withExtension: "data")!
        let content = try! String(contentsOf: url)
        let records = content.components(separatedBy: .newlines)
        let commas = CharacterSet(charactersIn: ",")
        
        for record in records {
            let fields = record.components(separatedBy: commas)
            guard fields.count == 5 else { continue }
            
            let irisFeatures = fields.prefix(4).map { str in
                guard let feature = Double(str) else { fatalError() }
                return KotlinDouble(value: feature)
            }
            
            let irisName = fields.suffix(1).first!
            let irisClass = Int32(IrisClass(dataName: irisName).rawValue)
            
            dataSet.addExample(
                knownClassification: irisClass,
                features: irisFeatures)
        }
        
        return dataSet
    }
    
}
