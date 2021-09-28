//
//  ContentModel.swift
//  LearningApp
//
//  Created by Shepherd on 9/23/21.
//

import Foundation

class ContentModel: ObservableObject {
    // Stores our modules
    @Published var modules = [Module]() // Initialize into empty list of Modules, which we load later
    
    // Make styleData property with nill allowed
    var styleData: Data?
    
    init() {
        getLocalData()
    }
    
    func getLocalData() {
        // Parses the local JSON file
        // Get URL to the local JSON object
        let jsonUrl = Bundle.main.url(forResource: "data", withExtension: "json")
        
        do {
            // Read a file into a data object
            let jsonData = try Data(contentsOf: jsonUrl!)
            
            let jsonDecoder = JSONDecoder()
            
            // Decode it into an array of modules; use self, when passing a type into an initializer call
            let modules = try jsonDecoder.decode([Module].self, from: jsonData)
            
            // Assign parsed modules to modules property
            self.modules = modules
            
        }
        catch {
            // Log Error
            print("Couldn't parse JSON data in ViewModels.ContentModel.getLocalData")
        }
        
        // Parse the style
        let styleUrl = Bundle.main.url(forResource: "style", withExtension: "html")

        // Try to decode the style
        do {
            // Read the file into a data object
            let styleData = try Data(contentsOf: styleUrl!)
            
            self.styleData = styleData
        }
        catch {
            // Log error
            print("Couldn't parse style data")
        }
    }
    
}
