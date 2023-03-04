//
//  ContentView.swift
//  ml-iris-classification
//
//  Created by Nick on 03/03/2023.
//

import SwiftUI

// MARK: - Classifier View

struct ClassifierView: View {
    
    @State private var chartMode: IrisChartView.Mode = .varieties
    @State private var sizeSlider: Double = 100
    
    @StateObject private var irisClassifier = IrisClassifier()
    
    var body: some View {
        VStack {

            IrisChartView(
                mode: $chartMode,
                data: $irisClassifier.data
            )
            
            TrainingSizeSlider(
                requestedSize: $irisClassifier.trainingSetSize,
                initialSize: 100,
                maximumSize: irisClassifier.dataSetSize
            )
            
            ChartModePicker(mode: $chartMode)
            
        }
        .padding()
    }
}

// MARK: - Training Size Slider

fileprivate struct TrainingSizeSlider: View {
    @Binding var requestedSize: Int
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

// MARK: - Chart Mode Picker

fileprivate struct ChartModePicker: View {
    
    @Binding var mode: IrisChartView.Mode
    
    var body: some View {
        Picker(selection: $mode, label: Text("Chart mode")) {
            Text("Iris Variety").tag(IrisChartView.Mode.varieties)
            Text("Data Set Membership").tag(IrisChartView.Mode.membership)
            Text("KNN Outcome").tag(IrisChartView.Mode.knnOutcome)
        }
    }
    
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ClassifierView()
    }
}
