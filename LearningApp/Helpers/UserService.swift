//
//  UserService.swift
//  LearningApp
//
//  Created by Leone on 1/6/22.
//

import Foundation

/*
 Use the UserService with a private init method in order to create a singleton, or a single instance in memory of our user
 */
class UserService {
    
    var user = User()
    
    // Use a static property of this this class in order to only have one exist in memory
    static var shared = UserService()
    
    // Stops this from being initialized anywhere else
    private init() {
        
    }
}
