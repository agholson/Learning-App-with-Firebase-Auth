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
        Text("Hello, world!")
            .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
