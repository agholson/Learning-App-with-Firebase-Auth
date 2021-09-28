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
    
    var id: Int
    var category: String
    var content: Content
    var test: Test
}


struct Content : Decodable, Identifiable {
    
    var id: Int
    var image: String
    var time: String
    var description: String
    var lessons: [Lesson]
}


struct Lesson : Decodable, Identifiable {
    
    var id: Int
    var title: String
    var video: String
    var duration: String
    var explanation: String
}

struct Test : Decodable, Identifiable {
    
    var id: Int
    var image: String
    var time: String
    var description: String
    var questions: [Question]
}

struct Question : Decodable, Identifiable {
    
    var id: Int
    var content: String
    var correctIndex: Int
    var answers: [String]
}
