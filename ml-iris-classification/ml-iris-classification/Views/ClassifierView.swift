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
    @StateObject private var irisClassifier = IrisClassifier()
    
    var body: some View {
        VStack {

            IrisChartView(
                mode: $chartMode,
                data: $irisClassifier.data
            )
            
            ChartModePicker(mode: $chartMode)
            
            IntegerSlider(
                requestedSize: $irisClassifier.k,
                text: "K nearest:",
                step: 1,
                maximum: 9
            )
            
            IntegerSlider(
                requestedSize: $irisClassifier.trainingSetSize,
                text: "Size of training set:",
                step: 5,
                maximum: irisClassifier.dataSetSize
            )
            
        }
        .padding()
    }
}

// MARK: - Integer Slider

private struct IntegerSlider: View {
    @Binding var requestedSize: Int
    var text: String
    var step: Int
    var maximum: Int
    
    @State var sizeSlider: Double = 0.0
    
    var body: some View {
        HStack {
            Text(text)
            
            Slider(
                value: $sizeSlider,
                in: 0...Double(maximum),
                step: Double(step)
            ) { isEditing in
                guard !isEditing else { return }
                let trainingSize = max(1, Int(sizeSlider))
                requestedSize = trainingSize
                
            }.onAppear {
                sizeSlider = Double(requestedSize)
            }
            
            Text("\(Int(sizeSlider))")
        }
    }
    
}

// MARK: - Chart Mode Picker

private struct ChartModePicker: View {
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
