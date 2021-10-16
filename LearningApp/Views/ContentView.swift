//
//  ContentView.swift
//  LearningApp
//
//  Created by Shepherd on 10/4/21.
//

import SwiftUI

struct ContentView: View {
    
    // Access the environment object for our current module
//    var module: Module
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        ScrollView {
            
            LazyVStack {
                
                // Confirm that the current module is set prior to executing this code
                if model.currentModule != nil {
        
                    // Loop through the lessons in our module
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                        NavigationLink(
                            destination:
                                ContentDetailView()
                                    .onAppear(perform: {
                                        model.beginLesson(index)
                                    }),
                            label: {
                                ContentViewRow(index: index)
                            })
                        // in XCode 13 add a .navigationViewStyle(.stack) modifier
                    }
                }
            }
            .accentColor(.black)
            .padding()
            // If no module category set, then place this category as blank
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
        }
        
    }
}
