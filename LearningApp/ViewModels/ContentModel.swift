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
    
    // Current test question
    @Published var currentQuestion: Question?
    var currentQuestionIndex = 0
    
    // Current lesson explanation
    @Published var codeText = NSAttributedString()
    
    // Tracks tag for current selected content and test
    @Published var currentContentSelected: Int?
    @Published var currentTestSelected:Int?
    
    
    // Make styleData property with nill allowed. This tracks our CSS/ HTML styles
    var styleData: Data?
    
    init() {
        // Parse the local data, and append to the modules property
        getLocalData()
        
        // Also call the remote data
        getRemoteData()
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
    
    
    func getRemoteData() {
        
        // String path for content
        let urlString = "https://raw.githubusercontent.com/agholson/Learning-App/master/LessonConfigData/module2.json"
        
        // Create a URL object that returns an optional URL
        let url = URL(string: urlString)
        
        // Check that the URL exists
        guard url != nil else {
            // Could not create the URL
            return
        }
        
        // Create a URLRequest object - where we force unwrap our URL object, because we already checked it exists
        let request = URLRequest(url: url!)
        
        // Create a session based on the single session object for each app
        let session = URLSession.shared
        
        // Raw data fetched in data, response contains more details, while error contains any errors
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            // Check if it hit any errors
            guard error == nil else {
                return
            }
            
            // Handle the response
            // Create a JSON decoder
            do {
                let decoder = JSONDecoder()
                
                // Decode - can safely force unrwapp, because checked for errors above
                let modules = try decoder.decode([Module].self, from: data!)
                
                // Append parsed modules into modules property
                self.modules += modules
                
            }
            catch {
                // Could not parse the JSON
            }
            
        }
        
        // Issue GET request, then parses it in the handler above
        dataTask.resume()
        
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
        // Add the HTML/ CSS styling explanation
        codeText = addStyling(currentLesson!.explanation)
        
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
            // Update the description
            codeText = addStyling(currentLesson!.explanation)
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
    
    /*
     Sets the current module, and the first question
     */
    func beginTest(_ moduleId:Int) {
        
        // Set the current module
        beginModule(moduleId)
        
        // Set the current question
        currentQuestionIndex = 0
        
        // If there are questions, set the current question to the first one
        if currentModule?.test.questions.count ?? 0 > 0 {
            currentQuestion = currentModule?.test.questions[currentQuestionIndex]
            
            // Set the codeText, which also represents our question's content
            codeText = addStyling(currentQuestion!.content) // Takes HTML string/ styling and adds it
        }
        
    }
    
    /*
     Proceeds to the next test question, if there was one available
     */
    func nextQuestion() {
        
        // Advance the currentQuestionIndex
        currentQuestionIndex += 1
        
        // Check if there's still another question
        if currentQuestionIndex < currentModule!.test.questions.count {
            // Set the current question
            currentQuestion = currentModule!.test.questions[currentQuestionIndex]
            
            // Update the description for the current question
            codeText = addStyling(currentQuestion!.content)
            
        }
        else {
            // Else reset the current test properties
            currentQuestionIndex = 0
            
            // Set this to nil, so we do not display any questions
            currentQuestion = nil
        }
        
        
    }
    
    // MARK: - Code Styling
    
    private func addStyling(_ htmlString: String) -> NSAttributedString {
        
        var resultString = NSAttributedString()
        var data = Data()
        
        // Add the styling data
        if styleData != nil {
            data.append(self.styleData!)
        }
        
        // Add the HTML data
        data.append(Data(htmlString.utf8))
        
        // Convert to attributed string
        // Technique 1 - use if we do not care to handle
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            // If above fails, then this does not execute
            resultString = attributedString
        }
        
        // Technique 2
//        do {
//            // If this fails, then it throws an error we catch down below
//            let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//
//            resultString = attributedString
//        }
//        catch {
//            print("Could not parse HTML into attributed string")
//        }
        
        return resultString
        
    }
    
}
