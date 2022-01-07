//
//  LaunchView.swift
//  LearningApp
//
//  Created by Leone on 1/4/22.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        // MARK: - Authenticated View
        // If the person is logged in already, then show that view
        if model.loggedIn {
           // Show the authenticated view
            TabView {
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book")
                            Text("Learn")
                        }
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("Learn")
                    }
            }
            .onAppear {
                model.getDatabaseData()
            }
        }
        // MARK: - Login/ Create Account Screen
        // Else prompt user to login, or create an account
        else {
            // Prompt for login/ create account
            // Show logged in view
            LoginView()
                .onAppear {
                    // Check if the user is truly logged in or out
                    // Happens before user even sees the code
                    model.checkLogin()
                }
        }
    }
}

//struct LaunchView_Previews: PreviewProvider {
//    static var previews: some View {
//        let previewModel = ContentModel()
//        LaunchView(model: previewModel)
//    }
//}
