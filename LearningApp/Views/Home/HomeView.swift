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
    
    // Reference our singleton user
    let user = UserService.shared.user
    
    // Computed property that determines the text to display for the end user e.g. Get Started or Welcome Back
    var navTitle: String {
        // If these properties were set, then it means the user has already logged in
        // These properties only get set at a later state within the app
        if user.lastLesson != nil || user.lastQuestion != nil {
            
            // If the user name fits on the screen, we show that
            if user.name.count < 9 {
                return "Welcome Back \(user.name.capitalized)"
            }
            // Else show the standard welcome
            else {
                return "Welcome Back"
            }
        }
        else {
            return "Get Started"
        }
    }
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                // Check, if we should display the button for where the user was last set upon
                // If the lastLesson is nil, then user hasn't started any yet
                // If the lastLesson = 0, then the user finished the module
                if user.lastLesson != nil && user.lastLesson ?? 0 > 0 ||
                    user.lastQuestion != nil && user.lastQuestion ?? 0 != 0 {
                    
                    // Show the resumed view
                    ResumeView()
                        .padding(.horizontal)
                }
                // Else the user left off on the homescreen 
                else {
                    Text("What do you want to do today?")
                        .padding(.leading, 20)
                }
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
                                            // Get the lessons here
                                            model.getLessons(module: module) {
                                                // Launch the lessons view only after we fetch the lessons
                                                model.beginModule(module.id)
                                            }
                                            
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
                                            // Set the questions for the chosen module
                                            model.getQuestions(module: module) {
                                                // Then set the model's current module in order to switch screens
                                                model.beginTest(module.id)
                                            }
                                           
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentTestSelected, // Make binding here that matches tag
                                    label: {
                                        HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) questions", time: module.test.time)
                                        
                                    })
                                
                            }
                                .padding(.bottom, 10)
                            
                        }
                        
                    }
                    .padding()
                    .accentColor(.black)
                    
                }
            }
            // Use a computed property that changes depending on the user coming back to the app/ not
            .navigationTitle(navTitle)
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
