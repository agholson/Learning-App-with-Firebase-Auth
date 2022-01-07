//
//  LoginView.swift
//  LearningApp
//
//  Created by Leone on 1/4/22.
//
/*
 Contains both the app login and sign up forms
 */

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    
    // Used to track the state within the Picker using the cases in the enum
    @State var loginMode = Constants.LoginMode.login
    
    // Variables for the sign up properties
    @State var name = ""
    @State var email = ""
    @State var password = ""
    
    // Used to track sign in or account creation errors
    @State var errorMessage: String?
    
    // Computed property that defines our greeting based on the Picker choices
    var buttonText: String {
        if loginMode == Constants.LoginMode.login {
            return "Login"
        }
        else {
            return "Sign up"
        }
    }
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            Spacer()
            
            // MARK: - Logo
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(width: 150)
            
            // MARK: - Title
            Text("Learn Swift")
            
            Spacer()
            
            // MARK: - Picker
            Picker(selection: $loginMode, label: Text("hey")) {
                // Options shown on screen, correspond to our enum
                Text("Login")
                    .tag(Constants.LoginMode.login)
                
                Text("Sign up")
                    .tag(Constants.LoginMode.createAccount)
            }
            .pickerStyle(.segmented)
            
            // MARK: - Sign up Form
            // Use a group, so we do not reach the 10 element limit for a VStack
            Group {
                // Only show name field, if this related to a new account
                if loginMode == Constants.LoginMode.createAccount {
                    TextField("Name", text: $name)
                }
                TextField("Email", text: $email)
                
                SecureField("Password", text: $password)
                
                // Show any errors
                if errorMessage != nil {
                    Text(errorMessage!)
                        .foregroundColor(.red)
                }
            }
            
            // MARK: - Submit Button
            Button {
                // MARK: - Login code
                // If it is currently set to the login tab and the button is pressed, then do this
                if loginMode == Constants.LoginMode.login {
                    // Log the user in
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        // Check for errors
                        guard error == nil else {
                            
                            // Update the error message in the View
                            errorMessage = error!.localizedDescription
                            
                            return
                        }
                        
                        // If no error, then set it to nil
                        errorMessage = nil
                        
                        // Fetch the user metadata
                        model.getUserData()
                        
                        // Make loggedIn flip to true, which will also change our current view
                        model.checkLogin()
                       
                    }
                }
                // Else it is set to the other tab, so submit new account details
                else {
                    // MARK: - Create new account
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        
                        // Check for any errors
                        guard error == nil else {
                            
                            // Update the error message
                            errorMessage = error!.localizedDescription
                            
                            return
                        }
                        
                        // Disable any set error
                        errorMessage = nil
                        
                        let firebaseUser = Auth.auth().currentUser
                        
                        // Save the first name
                        let db = Firestore.firestore()
                        
                        // Not nil, because user just created an account
                        let ref = db.collection("users").document(firebaseUser!.uid)
                        
                        // Use merge = true, so it does not overwrite entire document's contents
                        ref.setData(["name": name], merge: true)
                        
                        // Update the user's metadata with the name above by accessing our single instance of user
                        let user = UserService.shared.user
                        user.name = name
                        
                        
                        // Change the view to logged in view, by checking to see if we are logged in/ not
                        model.checkLogin()
                        
                        
                        
                    }
                    
                }
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .frame(height: 40)
                        .cornerRadius(10)
                    Text(buttonText)
                        .foregroundColor(.white)
                    
                }
            }
            
            Spacer()
            
        }
        // 40 left and right padding
        .padding(.horizontal, 40)
        .textFieldStyle(.roundedBorder)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
