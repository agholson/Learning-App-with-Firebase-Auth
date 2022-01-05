//
//  TestResultView.swift
//  LearningApp
//
//  Created by Shepherd on 10/31/21.
//

import SwiftUI

/*
 Displays how well someone did on the test
 */
struct TestResultView: View {
    
    @EnvironmentObject var model:ContentModel
    
    // Track how many questions the person got correct
    var numCorrect: Int
    
    /*
     Displays different text based on how well the person did
     */
    var resultHeading: String {
        
        // Make sure the model is not nil - a way to handle the potential error below
        guard model.currentModule != nil else  {
            return ""
        }
        
        let pct = Double(numCorrect) / Double(model.currentModule!.test.questions.count)
        
        if pct > 0.5 {
            return "Awesome!"
        }
        else if pct > 0.2 {
            return "Doing great!"
        }
        else {
            return "Keep learning."
        }
        
    }
    
    var body: some View {
       
        VStack {
            
            Spacer()
            Text(resultHeading)
                .font(.title)
            
            Spacer()
            Text("You scored \(numCorrect) out of \(model.currentModule?.test.questions.count ?? 0) questions")
            
            Spacer()
            
            // MARK: - Complete Button
            Button {
                
                // Binding property used in the NavigationLink selection to track this test, equivalent to the module.id
                // Setting this to nil, will pop user back to the main screen
                model.currentTestSelected = nil
                
            } label: {
                // RectangleCard
                ZStack {
                    
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .foregroundColor(.white)
                        .bold()
                    
                }
                
            }
            .padding()
            
            Spacer()
            
        }
        
        
    }
}
