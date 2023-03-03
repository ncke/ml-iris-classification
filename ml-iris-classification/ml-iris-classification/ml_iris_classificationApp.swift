//
//  ml_iris_classificationApp.swift
//  ml-iris-classification
//
//  Created by Nick on 03/03/2023.
//

import SwiftUI
import KNN

@main
struct ml_iris_classificationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                let op = KNN.Greeting().greet()
                print(op)
            }
        }
    }
}
