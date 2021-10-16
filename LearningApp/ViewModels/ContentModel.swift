//
//  ContentModel.swift
//  LearningApp
//
//  Created by Shepherd on 9/23/21.
//

import Foundation

class ContentModel: ObservableObject {
    // Stores our list of modules
    @Published var modules = [Module]() // Initialize into empty list of Modules, which we load later
    
    // Current module
    @Published var currentModule: Module?
    var currentModuleIndex = 0
    
    // Current lesson
    @Published var currentLesson: Lesson? // @Published notifies any views that rely on this property that it changed
    var currentLessonIndex = 0
    
    // Make styleData property with nill allowed. This tracks our CSS/ HTML styles
    var styleData: Data?
    
    init() {
        getLocalData()
    }
    
    // MARK: - Data Methods
    
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
    
    // MARK: - Module navigation methods
    
    /*
     Sets the current module, and finds the index for this module as well
     */
    func beginModule(_ moduleid: Int) {
        
        // Find index for this module ID
        for index in 0..<modules.count {
            
            // Loop through our list of modules to see, which index in the modules we belong
            if modules[index].id == moduleid {
                // Set the current module index to this matching module
                currentModuleIndex = index
                
                // Break, because we found what we needed
                break
            }
            
            
        }
        
        // Set the current module
        currentModule = modules[currentModuleIndex]
        
    }
    
    /*
     Sets the currentLesson/ lessonIndex that we use to track in the views
     */
    func beginLesson(_ lessonIndex:Int) {
        
        // Check that the lesson index is in the range of module lessons
        if lessonIndex < currentModule!.content.lessons.count {
            
            // If it is within the range, then we set the current lesson
            currentLessonIndex = lessonIndex
        }
        else {
            currentLessonIndex = 0
        }
        
        // Set the current lesson
        currentLesson = currentModule!.content.lessons[currentLessonIndex]
    }
    
    /*
     Advances to the next lesson, if there is one
     */
    func nextLesson() {
        // Advance the lesson
        currentLessonIndex += 1
        
        // Check that it is within range
        if currentLessonIndex < currentModule!.content.lessons.count {
            // Set the current lesson
            currentLesson = currentModule!.content.lessons[currentLessonIndex]
        }
        else {
            // Else if it is out of bounds, we reset the sate
            currentLessonIndex = 0
            currentLesson = nil
        }
        
        
    }
    
    /*
     Determines whether or not there is a next lesson
     */
    func hasNextLesson() -> Bool {
        // If there is still another lesson, then we return true/ false here 
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
        
    }
    
}
