//
//  Models.swift
//  LearningApp
//
//  Created by Shepherd on 9/26/21.
//

import Foundation


/*
 Represents our modules. This mirrors the structure of our JSON, so we can directly code the JSON keys to the corresponding variables here.
 :Decodable makes it, so we can parse it directly from JSON
 :Identifiable makes it, so we can track changes to it across the app
 */
struct Module: Decodable, Identifiable {
    
    var id: String = ""
    var category: String = ""
    var content: Content = Content()
    var test: Test = Test()
}


struct Content : Decodable, Identifiable {
    
    var id: String = ""
    var image: String = "" 
    var time: String = ""
    var description: String = ""
    var lessons: [Lesson] = [Lesson]()
}


struct Lesson : Decodable, Identifiable {
    
    var id: String = ""
    var title: String = ""
    var video: String = ""
    var duration: String = ""
    var explanation: String = ""
}

struct Test : Decodable, Identifiable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var questions: [Question] = [Question]()
}

struct Question : Decodable, Identifiable {
    
    var id: String = ""
    var content: String = ""
    var correctIndex: Int = 0
    var answers: [String] = [String]()
}

/*
 Represents our user for interactions with the Firestore database
 
 Use a class, so we reference the same object in memory versus creating multiple copies with struct
 */
class User {
    var name: String = ""
    var lastModule: Int? // Tracks the last module the user was using
    var lastLesson: Int?
    var lastQuestion: Int?
}
