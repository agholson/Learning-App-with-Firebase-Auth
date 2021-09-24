//
//  LearningAppApp.swift
//  LearningApp
//
//  Created by Shepherd on 9/23/21.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            // Initialize our HomeView with the content model environment object
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
