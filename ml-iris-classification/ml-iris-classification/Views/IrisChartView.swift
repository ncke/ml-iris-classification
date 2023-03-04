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
                let categoryName = categoryName(mode: mode)
                let groupName = groupName(example: example, mode: mode)
                let xPosn = Double(truncating: example.features[0])
                let yPosn = Double(truncating: example.features[1])
                
                PointMark(
                    x: .value("Sepal length", xPosn),
                    y: .value("Sepal width", yPosn)
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
        .chartLegend(position: .overlay, alignment: .bottomLeading)
    }
    
}

// MARK: - Chart Scale Helpers

extension IrisChartView {
    
    private func categoryName(mode: Mode) -> String {
        switch mode {
        case .varieties: return "Variety"
        case .membership: return "Dataset"
        case .knnOutcome: return "Outcome"
        }
    }
    
    private func groupName(example: KNNDataSet.Example, mode: Mode) -> String {
        switch mode {
        case .varieties:
            let known = Int(example.knownClassification)
            let iris = IrisClassifier.Variety(rawValue: known)!
            return iris.description
        case .membership:
            return example.knnClassification != nil ? "Test Set" : "Training Set"
        case .knnOutcome:
            guard let knnClassification = example.knnClassification else {
                return "Training Set"
            }
            
            let knn = Int(truncating: knnClassification)
            let known = Int(example.knownClassification)
            return knn == known ? "Succeeded" : "Failed"
        }
    }
    
    private func domain(mode: Mode) -> [String] {
        switch mode {
        case .varieties:
            return [ "Iris Setosa", "Iris Versicolour", "Iris Virginica" ]
        case .membership:
            return [ "Training Set", "Test Set" ]
        case .knnOutcome:
            return [ "Succeeded", "Failed", "Training Set" ]
        }
    }
    
    private func range(mode: Mode) -> [Color] {
        switch mode {
        case .varieties:
            return [ .red, .green, .blue ]
        case .membership:
            return [ .blue, .yellow ]
        case .knnOutcome:
            return [ .green, .red, .gray ]
        }
    }
    
}
