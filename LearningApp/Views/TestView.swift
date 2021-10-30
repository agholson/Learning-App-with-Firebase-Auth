//
//  TestView.swift
//  LearningApp
//
//  Created by Shepherd on 10/30/21.
//

import SwiftUI

struct TestView: View {
    
    // Tracks state of the app
    @EnvironmentObject var model:ContentModel
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack {
                
                // Qustion number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                
                // Question
                
                // Button
                
                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
            
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
