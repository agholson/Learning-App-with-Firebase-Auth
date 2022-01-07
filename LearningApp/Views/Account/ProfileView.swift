//
//  ProfileView.swift
//  LearningApp
//
//  Created by Leone on 1/4/22.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        // MARK: - Sign out Button
        Button {
            // Upon button press, sign the user out
            try! Auth.auth().signOut()
            
            // Calling checkLogin will show, we are logged out, which will change the view code
            model.checkLogin()
            
        } label: {
            Text("Sign out")
        }

       
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
