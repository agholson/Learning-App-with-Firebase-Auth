//
//  ContentViewRow.swift
//  LearningApp
//
//  Created by Shepherd on 10/7/21.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    
    var index: Int
    
    /*
     Make this a computed property to safely unwrap it, and avoid index out of range
     */
    var lesson: Lesson {
        
        // If the passed-in index is less than the current count
        if model.currentModule != nil &&
            index < model.currentModule!.content.lessons.count {
            return model.currentModule!.content.lessons[index]
        }
        else {
            return Lesson(id: "", title: "", video: "", duration: "", explanation: "")
        }
        
    }
    
    var body: some View {
        // Create a local lesson
//        let lesson = model.currentModule!.content.lessons[index]
        
        // Lesson card
        ZStack(alignment: .leading) {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
            
            // Video card details
            // The spacing of 30 separates the elements in the HStack
            HStack (spacing: 30){
                
               Text(String(index + 1))
                .bold()
                
                VStack (alignment: .leading) {
                    Text(lesson.title)
                    Text(lesson.duration)
                }
                
            }
            .padding()
            
        }
        .padding(.bottom, 5) // Controls spacing between ZStack cards
    }
}
