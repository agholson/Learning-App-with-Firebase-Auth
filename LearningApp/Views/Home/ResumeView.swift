//
//  ResumeView.swift
//  LearningApp
//
//  Created by Leone on 1/8/22.
//

import SwiftUI

/*
 Creates a button like view that shows the person the last question/ lesson he or she left off
 */
struct ResumeView: View {
    
    @EnvironmentObject var model: ContentModel
    
    // Tells the view, which lesson/ question the user selected
    @State var resumeSelected: Int?
    
    let user = UserService.shared.user
    
    var resumeTitle: String {
        // Get the last module
        let module = model.modules[user.lastModule ?? 0]
        
        // If this was set to something other than zero that means the user was looking at a lesson
        if user.lastLesson != 0 {
            // Add one to the lastLesson, because it uses 0 for the starting index
            return "Learn \(module.category): Lesson \(user.lastLesson! + 1)"
        }
        // Else he or she was doing a test, so show the last question
        else {
            return "\(module.category) Test: Question \(user.lastQuestion! + 1)"
        }
    }
    // MARK: - Compute Destination View
    var destination: some View {
        // Determine if we go into a single content detail view (lesson), or a TestView
        
        return Group {
            
            let module = model.modules[user.lastModule ?? 0]
            
            if user.lastLesson ?? 0 > 0 {
                ContentDetailView()
                    .onAppear(perform: {
                        // Fetch lesson
                        model.getLessons(module: module) {
                            // Launch the lessons view only after we fetch the lessons
                            model.beginModule(module.id)
                            // Set the module, then go to the beginLesson
                            model.beginLesson(user.lastLesson!)
                        }
                        
                    })
            }
            // Else go to the TestView
            else {
                TestView()
                    .onAppear(perform: {
                        // Set the questions for the chosen module
                        model.getQuestions(module: module) {
                            // Then set the model's current module in order to switch screens
                            model.beginTest(module.id)
                            
                            model.currentQuestionIndex = user.lastQuestion!
                            
                        }
                        
                    })
            }
            
        }
    }
    
    var body: some View {
        
        let module = model.modules[user.lastModule ?? 0]
        
        NavigationLink(
            tag: module.id.hash,
            selection: $resumeSelected
        ) {
            destination
        } label: {
            // MARK: - Continue Card
            ZStack {
                
                // Re-use the re-usable common Rectangle card
                RectangleCard()
                    .frame(height: 66)
                
                
                // Place this on top of the card
                HStack {
                    // Make the text elements align towards the left with .leading, otherwise they don't match up
                    VStack (alignment: .leading) {
                        Text("Continue where you left off: ")
                        // Use computed property to determine text, where the user left off
                        Text(resumeTitle)
                            .bold()
                    }
                    .foregroundColor(.black)
                    Spacer()
                    Image("play")
                        .resizable()
                        .scaledToFit() // Fits the parent view, the HStack
                        .frame(width: 40, height: 40)
                }
                .padding() // Makes the text not hit the edges
            }
        }
        
        
        
        
    }
}

struct ResumeView_Previews: PreviewProvider {
    static var previews: some View {
        ResumeView()
    }
}
