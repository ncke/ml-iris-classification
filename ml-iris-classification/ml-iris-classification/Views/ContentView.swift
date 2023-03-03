//
//  ContentView.swift
//  ml-iris-classification
//
//  Created by Nick on 03/03/2023.
//

import Charts
import SwiftUI

struct ContentView: View {
    
    @State private var chartMode: IrisChart.Mode = .varieties
    @State private var sizeSlider: Double = 100
    
    @StateObject private var irisClassifier = IrisClassifier()
    
    var body: some View {
        VStack {

            IrisChart(
                mode: $chartMode,
                examples: $irisClassifier.examples
            )
            
            TrainingSizeSlider(
                requestedSize: $irisClassifier.trainingSetSize,
                initialSize: 100,
                maximumSize: irisClassifier.examples.count
            )
            
            ChartModePicker(mode: $chartMode)
            
        }
        .padding()
    }
}

fileprivate struct IrisChart: View {
    
    enum Mode {
        case varieties
        case membership
        case knnOutcome
    }
    
    @Binding var mode: Mode
    @Binding var examples: [IrisClassifier.Example]
    
    func category(for example: IrisClassifier.Example, mode: Mode) -> String {
        switch mode {
        case .varieties: return "Variety"
        case .membership: return "Dataset"
        case .knnOutcome: return "Outcome"
        }
    }
    
    func group(for example: IrisClassifier.Example, mode: Mode) -> String {
        switch mode {
        case .varieties:
            return example.knownClassification.description
            
        case .membership:
            return example.dataSet == .training ? "Training Set" : "Test Set"
            
        case .knnOutcome:
            guard let isSuccess = example.isSuccessfulClassification() else {
                return "Unclassified"
            }
            
            return isSuccess ? "Succeeded" : "Failed"
        }
    }
    
    func domain(mode: Mode) -> [String] {
        switch mode {
        case .varieties:
            return [ "Iris Setosa", "Iris Versicolour", "Iris Virginica" ]
        case .membership:
            return [ "Training Set", "Test Set" ]
        case .knnOutcome:
            return [ "Succeeded", "Failed", "Unclassified" ]
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
    
    var body: some View {
        
        Chart {
            ForEach(0..<examples.count, id: \.self) { idx in
                let example = examples[idx]
                
                let category = category(for: example, mode: mode)
                let group = group(for: example, mode: mode)
                
                PointMark(
                    x: .value("Sepal length", example.features[0]),
                    y: .value("Sepal width", example.features[1])
                )
                .foregroundStyle(
                    by: .value(category, group))
            }
            
        }
        .chartForegroundStyleScale(
            domain: domain(mode: mode),
            range: range(mode: mode)
        )
        .chartXScale(domain: .automatic(includesZero: false))
        .chartYScale(domain: .automatic(includesZero: false))
        .chartLegend(position: .overlay, alignment: .topLeading)
        
    }
}

fileprivate struct TrainingSizeSlider: View {
    @Binding var requestedSize: Int?
    var initialSize: Int
    var maximumSize: Int
    
    @State var sizeSlider: Double = 0.0
    
    var body: some View {
        VStack {
            HStack {
                Text("Size of training set")
                Spacer()
            }
            
            HStack {
                Slider(
                    value: $sizeSlider,
                    in: 1...Double(maximumSize),
                    step: 1.0
                ) { isEditing in
                        guard !isEditing else { return }
                        let trainingSize = Int(sizeSlider)
                        requestedSize = trainingSize
                        
                    }
                Text("\(Int(sizeSlider))")
            }
        }
    }
}

fileprivate struct ChartModePicker: View {
    
    @Binding var mode: IrisChart.Mode
    
    var body: some View {
        Picker(selection: $mode, label: Text("Chart mode")) {
            Text("Iris Variety").tag(IrisChart.Mode.varieties)
            Text("Data set").tag(IrisChart.Mode.membership)
            Text("KNN outcome").tag(IrisChart.Mode.knnOutcome)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
