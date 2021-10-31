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
    
    // Tracks the answer chosen by the user
    @State var selectedAnswerIndex:Int? // Make it an optional integer, so we can track, if answer chosen yet
    
    // Track whether/ not the person submitted the answer
    @State var submitted = false
    
    @State var numCorrect = 0
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack (alignment: .leading) {
                
                // Qustion number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading, 20)
                
                // Question
                CodeTextView()
                    .padding(.horizontal, 18)
                
                // Answers
                ScrollView {
                    
                    VStack {
                        
                        // Loop through all the answers for this question
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                           
                            // Allow user to select the answer through a button
                            Button {
                                // Track the selectedAnswerIndex
                                selectedAnswerIndex = index
                            } label: {
                                // Place the entire ZStack within the label, so we register if the user clicks anywhere on the button
                                ZStack {
                                    
                                    // If not submitted, then do this
                                    if submitted == false {
                                        // Place a rectangle for each answer, then overlay the text
                                        // In-line if statement tracks, if the user selected this card
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48) // Makes button/ rectangle larger
                                    }
                                    // Else Answer has been submitted
                                    else {
                                        // If it is the right answer selected, then make the rectangle green
                                        if index == selectedAnswerIndex && selectedAnswerIndex == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 48) // Makes button/ rectangle larger
                                        }
                                        // Else, if user chose, the wrong card, then make it red
                                        else if index == selectedAnswerIndex && selectedAnswerIndex != model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .red)
                                                .frame(height: 48) // Makes button/ rectangle larger
                                        }
                                        // Show that this button is the correct answer
                                        else if index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                        }
                                        // Else the card should be white
                                        else {
                                            RectangleCard()
                                                .frame(height: 48)
                                        }
                                        
                                    }
                                    
                                        Text("\(model.currentQuestion!.answers[index])")
                                    
                                }
                                
                            }
                            .disabled(submitted) // If the person, clicks submit, then the button becomes disabled
                             
                        }
                        
                    }
                    .padding()
                    .accentColor(.black)
                    
                }
                
                // MARK: - Submit Button
                Button {
                    
                    // Track that the person submitted the answer, so they cannot change it any more
                    submitted = true
                    
                    // Check the answer and increment the number, if correct
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                    }
                    
                } label: {
                    
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text("Submit")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding()
                    
                }
                .disabled(selectedAnswerIndex == nil) // Person cannot click the submit button, unless answer selected
                
                
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
            
        }
        else {
            // Triggers the .onAppear in the other view
            ProgressView()
        }
        
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
