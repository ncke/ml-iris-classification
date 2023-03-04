//
//  IrisChartView.swift
//  ml-iris-classification
//
//  Created by Nick on 03/03/2023.
//

import Charts
import KNN
import SwiftUI

// MARK: - Iris Chart View

struct IrisChartView: View {
    
    enum Mode {
        case varieties
        case membership
        case knnOutcome
    }
    
    @Binding var mode: Mode
    @Binding var data: KNNDataSet
    
    var body: some View {
        let examples = data.examples()
        
        Chart {
            let examples = data.examples()
            
            ForEach(0..<examples.count, id: \.self) { idx in
                let example = examples[idx]
                
                let categoryName = categoryName(for: mode)
                let groupName = groupName(for: example, mode: mode)
                let x = Double(truncating: example.features[0])
                let y = Double(truncating: example.features[1])
                
                PointMark(
                    x: .value("Sepal length", x),
                    y: .value("Sepal width", y)
                )
                .foregroundStyle(
                    by: .value(categoryName, groupName))
            }
            
        }
        .chartForegroundStyleScale(
            domain: domain(mode: mode),
            range: range(mode: mode)
        )
        .chartXScale(domain: .automatic(includesZero: false))
        .chartYScale(domain: .automatic(includesZero: false))
        .chartLegend(position: .overlay, alignment: .bottomTrailing)
    }
    
}

// MARK: - Chart Scale Helpers

extension IrisChartView {
    
    func categoryName(for mode: Mode) -> String {
        switch mode {
        case .varieties: return "Variety"
        case .membership: return "Dataset"
        case .knnOutcome: return "Outcome"
        }
    }
    
    func groupName(for example: KNNDataSet.Example, mode: Mode) -> String {
        switch mode {
        case .varieties:
            let known = Int(example.knownClassification)
            let iris = IrisClassifier.IrisClass(rawValue: known)!
            return iris.description
            
        case .membership:
            return example.knnClassification != nil ? "Test Set" : "Training Set"
            
        case .knnOutcome:
            guard let knnClassification = example.knnClassification else {
                return "Not Classified"
            }
            
            let knn = Int(truncating: knnClassification)
            let known = Int(example.knownClassification)
            return knn == known ? "Succeeded" : "Failed"
        }
    }
    
    func domain(mode: Mode) -> [String] {
        switch mode {
        case .varieties:
            return [ "Iris Setosa", "Iris Versicolour", "Iris Virginica" ]
        case .membership:
            return [ "Training Set", "Test Set" ]
        case .knnOutcome:
            return [ "Succeeded", "Failed", "Not Classified" ]
        }
    }
    
    func range(mode: Mode) -> [Color] {
        switch mode {
        case .varieties:
            return [ .red, .green, .blue ]
        case .membership:
            return [ .green, .red ]
        case .knnOutcome:
            return [ .green, .red, .gray ]
        }
    }
    
}
