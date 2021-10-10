//
//  HomeViewRow.swift
//  LearningApp
//
//  Created by Shepherd on 9/30/21.
//

import SwiftUI

struct HomeViewRow: View {
    
    // Pass in values from the other view
    var image: String
    var title: String
    var description: String
    var count: String // Tracks how many lessons, or questions
    var time: String
    
    var body: some View {
        ZStack {
            
            // Provides background for the card
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)// will take up as much space as possible within the screen with the aspect ratio
            
            // Contains our image and other elements
            HStack {
                
                // Image
                Image(image)
                    .resizable()
                    .frame(width: 116, height: 116, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) // binds it to a specific size
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/) // makes into a circle
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    // Headline
                    Text(title)
                        .bold()
                    
                    // Description
                    Text(description)
                        .padding(.bottom, 20)
                        .font(.caption)  // Makes the description font much smaller
                    
                    // Icons
                    HStack {
                        // Number of lessons
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(count)
                            .font(.caption)
                        
                        Spacer()
                        
                        // Time
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 15, height: 15)
                        Text(time)
                            .font(.caption)
                    }
                    
                }
                .padding(.leading, 20)
                
            }
            .padding(.horizontal, 20)
        }
        
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "Some description goes far here", count: "10 Lessons", time: "30 minutes")
    }
}
