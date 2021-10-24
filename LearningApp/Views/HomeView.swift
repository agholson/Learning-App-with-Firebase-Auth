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
        
        NavigationView {
            VStack(alignment: .leading) {
                
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                
                ScrollView {
                    // Aligns elements vertically, but only loads what appears on screen
                    LazyVStack {
                        
                        // Loads each of our modules here
                        ForEach(model.modules) { module in
                            
                            VStack(spacing: 20) {
                                
                                // Link to the next view
                                NavigationLink(
                                    // When the user clicks this, we execute the code to determine our current module
                                    destination: ContentView()
                                        .onAppear(perform: {
                                            model.beginModule(module.id)
                                        }),
                                    tag: module.id,
                                    selection: $model.currentContentSelected, // Make binding here that matches tag
                                    label: {
                                        // If user clicks on the learning card, then that's the destination
                                        // Learning card
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) lessons", time: module.content.time)
                                        
                                    })
                                
                                // Test card
                                HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) questions", time: module.test.time)
                            }
                        }
                        
                    }
                    .padding()
                    .accentColor(.black)
                    
                }
            }
            .navigationTitle("Get Started")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
