//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Shepherd on 9/23/21.
//

import SwiftUI
import Firebase

@main
struct LearningApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            // Initialize our HomeView with the content model environment object
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
