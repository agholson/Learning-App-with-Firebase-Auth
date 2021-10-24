//
//  ContentDetailView.swift
//  LearningApp
//
//  Created by Shepherd on 10/16/21.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
        
    var body: some View {

        // Get this from the view
        let lesson = model.currentLesson
        // We use an optional here in case the lesson has not been set yet
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack(alignment: .leading) {
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            
            // MARK: - UIKit Description with HTML
            CodeTextView()
            
            // MARK: - Green Next Lesson Button
            // Show next lesson button, only if there is a next lesson
            if model.hasNextLesson() {
                Button(action: {
                    
                    // Because this view tracks the @Published lesson property, we can change that property here, and it will display that video
                    model.nextLesson()
                    
                }, label: {
                    
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        // Display the next lesson with its title
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .bold()
                            .foregroundColor(.white)
                    }
                })
            }
            // MARK: - Completed Lessons Button
            else {
                // Show the completed lessons Button to bounce back out
                Button(action: {
                    
                    // Set this to nil, so we bounce back to the home screen
                    model.currentContentSelected = nil
                    
                }, label: {
                    
                    ZStack {
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                        
                        // Display the next lesson with its title
                        Text("Complete")
                            .bold()
                            .foregroundColor(.white)
                    }
                })
            }
        }
            .padding()
            .navigationBarTitle(lesson?.title ?? "") // Sets the title or empty quote, if blank
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
