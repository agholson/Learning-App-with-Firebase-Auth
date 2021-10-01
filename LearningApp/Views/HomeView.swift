//
//  ContentView.swift
//  LearningApp
//
//  Created by Shepherd on 9/23/21.
//

import SwiftUI

struct HomeView: View {
    
    // Access our shared model here
    @EnvironmentObject var model: ContentModel
    
    
    var body: some View {
        ScrollView {
            // Aligns elements vertically, but only loads what appears on screen
            LazyVStack {
                
                // Loads each of our modules here
                ForEach(model.modules) { module in
                    
                    // Learning card
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
                            Image(module.content.image)
                                .resizable()
                                .frame(width: 116, height: 116, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/) // binds it to a specific size
                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/) // makes into a circle
                            
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 10) {
                                // Headline
                                Text("Learn \(module.category)")
                                    .bold()
                                
                                // Description
                                Text(module.content.description)
                                    .padding(.bottom, 20)
                                    .font(.caption)  // Makes the description font much smaller
                                
                                // Icons
                                HStack {
                                    // Number of lessons
                                    Image(systemName: "text.book.closed")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text("\(module.content.lessons.count) lessons")
                                        .font(.caption)
                                    
                                    Spacer()
                                    
                                    // Time
                                    Image(systemName: "clock")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text(module.content.time)
                                        .font(.caption)
                                }
                                
                            }
                            .padding(.leading, 20)
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Test card
                    
                }
                
            }
                .padding()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
