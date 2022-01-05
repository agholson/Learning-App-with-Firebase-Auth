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
            // Initialize our LaunchView with the ContentModel object
            LaunchView()
                .environmentObject(ContentModel())
        }
    }
}
