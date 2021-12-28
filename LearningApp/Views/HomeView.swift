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
                                    // Need to get the Integer value of our String for use in the tag
                                    tag: module.id.hash,
                                    selection: $model.currentContentSelected, // Make binding here that matches tag
                                    label: {
                                        // If user clicks on the learning card, then that's the destination
                                        // Learning card
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) lessons", time: module.content.time)
                                        
                                    })
                                
                                // MARK: - Test card
                                NavigationLink(
                                    // When the user clicks this, we execute the code to determine our current module
                                    destination: TestView()
                                        .onAppear(perform: {
                                            model.beginTest(module.id)
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentTestSelected, // Make binding here that matches tag
                                    label: {
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) questions", time: module.test.time)
                                        
                                    })
//                                NavigationLink(
//                                    tag: module.id,
//                                    selection: $model.currentTestSelected,
//                                    destination:
//                                        TestView()
//                                        .onAppear(perform: model.beginTest(module.id))
//                                ) {
//                                    HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) questions", time: module.test.time)
//                                }
                                
                                
                            }
                                .padding(.bottom, 10)
                            
                        }
                        
                    }
                    .padding()
                    .accentColor(.black)
                    
                }
            }
            .navigationTitle("Get Started")
            // Executes this code as soon as value changed, after user returns from a nested view. Prevents a bug with on-loads from occurring
            .onChange(of: model.currentContentSelected) { changedValue in
                if changedValue == nil {
                    model.currentModule = nil
                }
            }
            .onChange(of: model.currentTestSelected) { changedValue in
                // If the test selected is nil, then make sure to set currentModule to nil
                if changedValue == nil {
                    model.currentModule = nil
                }
            }
            
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
