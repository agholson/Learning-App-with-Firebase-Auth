//
//  ContentModel.swift
//  LearningApp
//
//  Created by Shepherd on 9/23/21.
//

import Foundation
import Firebase
import FirebaseAuth

class ContentModel: ObservableObject {
    
    // Tracks whether/ not the person is logged in, then uses @Published to update all the views that use this upon change
    @Published var loggedIn = false
    
    let db = Firestore.firestore()
    
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
        
    }
    
    // MARK: - Authentication Methods
    /*
     Determines whether/ not the current person is logged in
     */
    func checkLogin() {
        
        // If the current user is logged in, then set loggedIn to true, else false
        loggedIn = Auth.auth().currentUser != nil ? true : false
        
        // If user previously logged in, then we need to get his or her last place in the app
        if UserService.shared.user.name == "" {
            // Then we get the user's data
            getUserData()
        }
    }
    
    // MARK: - Data Methods
    /*
     Saves the current state information within the app, e.g. the index data for each module/ question/ test
     */
    func saveData() {
        // Only run this code if the loggedIn user existed
        if let loggedInUser = Auth.auth().currentUser {
            // Save the progress data locally
            let user = UserService.shared.user
            
            user.lastQuestion = currentQuestionIndex
            user.lastLesson = currentLessonIndex
            user.lastModule = currentModuleIndex
            
            // Save to the database
            let db = Firestore.firestore()
            
            let ref = db.collection("users").document(loggedInUser.uid)
            
            
            // Use merge, so that we do not overwrite the user's name, because not included here
            ref.setData([
                "lastModule" : user.lastModule!,
                "lastQuestion": user.lastQuestion!,
                "lastLesson": user.lastLesson!
            ],
                merge: true
            )
        }
        
        
        
    }
    
    /*
     Gets the metadata for the user
     */
    func getUserData() {
        // Check that there's a logged in user
        guard Auth.auth().currentUser != nil else {
            // If nil, then return
            return
        }
        
        // Get the metadata for that user
        let db = Firestore.firestore()
        let ref = db.collection("users").document(Auth.auth().currentUser!.uid)
        
        // Fetch the document for this user
        ref.getDocument { snapshot, error in
            // Ensure that the error is nil and that the snapshot exists
            guard error == nil, snapshot != nil else {
                return
            }
            
            // Parse the data into the user
            let data = snapshot!.data()
            // Access our one and only shared user service
            let user = UserService.shared.user
            
           // Assign the name from the database to the shared name in our app
            user.name = data?["name"] as? String ?? "" // If nil, then set this to empty
            user.lastModule = data?["lastModule"] as? Int // Because it's already an optional property, we don't need to assign to nil 
            user.lastLesson = data?["lastLesson"] as? Int
            user.lastQuestion = data?["lastQuestion"] as? Int
        }
        
    }
    
    /*
     Gets our lessons from the database and sets it for the module in question
     
     Also uses a completion handler, which allows us to ensure this code executes first. We wait for all results from the
     database before trying to set the module.
     */
    func getLessons(module: Module, completion: @escaping () -> Void) {
        
        // Parse the local data, and append to the modules property
        getLocalStyles()
        
        // Specify path
        let collection = db.collection("modules").document(module.id).collection("lessons")
        
        // Get documents
        collection.getDocuments { querySnapshot, error in
            // Ensure no errors, and documents returned
            if error == nil && querySnapshot != nil {
                
                // Create an array to track the lessons
                var lessons = [Lesson]()
                
                // Loop through the documents in the snapshot and build an array of lessons
                for doc in querySnapshot!.documents {
                    var lesson = Lesson()
                    
                    lesson.id = doc["id"] as? String ?? UUID().uuidString
                    lesson.title = doc["title"] as? String ?? ""
                    lesson.video = doc["video"] as? String ?? ""
                    lesson.duration = doc["duration"] as? String ?? ""
                    lesson.explanation = doc["explanation"] as? String ?? ""
                    
                    // Add lesson to the array
                    lessons.append(lesson)
                }
                
                // Cannot do this, because the module passed in is a struct/ a let constant copy of the struct
                // Versus passing in a class, we would pass the reference of that class allowing us to change it
                // Make these lessons belong to the correct module
//                module.content.lessons = lessons
                
                // Determine the module we want to change
                for (index, value) in self.modules.enumerated() {
                    // If this is the ID of the module we wanted to add the lessons to, then we can use this
                    if value.id == module.id {
                        // Update this particular module with the lessons
                        self.modules[index].content.lessons = lessons
                        
                        // Call the completion closure
                        completion() 
                    }
                }
                
            }
        }
        
    }
    
    func getQuestions(module: Module, completion: @escaping () -> Void) {
        // Define the path to the collection
        let collection = db.collection("modules").document(module.id).collection("questions")
        
        // Get all the documents in the questions collection
        collection.getDocuments { querySnapshot, error in
            // Only process this code, if the querySnapshot has documents, and no errors
            if querySnapshot != nil && error == nil {
                // Setup a questions array to hold the returned questions
                var questions = [Question]()
                // Loop through all the documents
                for doc in querySnapshot!.documents {
                    var question = Question()
                    
                    question.id = doc["id"] as? String ?? UUID().uuidString
                    question.answers = doc["questions"] as? [String] ?? [String]()
                    question.content = doc["content"] as? String ?? ""
                    question.correctIndex = doc["correctIndex"] as? Int ?? 0
                    
                    // Add this question to our temporary list
                    questions.append(question)
                    
                }
                
                // Update the questions for that module
                for (index, value) in self.modules.enumerated() {
                    // If the ID matches of our current module, then...
                    if value.id == module.id {
                        // Update that specific module index with these questions
                        self.modules[index].test.questions = questions
                        
                        // Call the completion handler here
                        completion()
                    }
                }
                
                
            }
        }
        
    }
    
    /*
     Gets all of the modules and parses each one
     */
    func getDatabaseData() {
        
        // Parse the styles
        getLocalStyles()
        
        // Specifiy path
        let collection = db.collection("modules")
        
        // Get documents in modules collection
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                // Create new array for the modules
                var modules = [Module]()
                
                // Loop through returned documents
                for doc in snapshot!.documents {
                    // Create new module instance
                    var module = Module()
                    
                    // Parse document into module properties
                    module.id = doc["id"] as? String ?? UUID().uuidString
                    module.category = doc["category"] as? String ?? ""
                    
                    // Parse the content map
                    let contentMap = doc["content"] as! [String: Any]
                    
                    module.content.id = contentMap["id"] as? String ?? ""
                    module.content.description = contentMap["description"] as? String ?? ""
                    module.content.image = contentMap["image"] as? String ?? ""
                    module.content.time = contentMap["time"] as? String ?? ""
                    
                    // Parse the test content
                    let testMap = doc["test"] as! [String: Any]
                    
                    module.test.id = testMap["id"] as? String ?? ""
                    module.test.image = testMap["image"] as? String ?? ""
                    module.test.time = testMap["time"] as? String ?? ""
                    
                    
                    // Add to modules array
                    modules.append(module)
                    
                }
                
                // Update UI code via the main thread
                DispatchQueue.main.async {
                    // Assign modules to the published property
                    self.modules = modules
                }
                
                
            }
            
        }
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
    
    /*
     Parses the HTML/ CSS as needed
     */
    func getLocalStyles() {
        
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
                DispatchQueue.main.async {
                    self.modules += modules
                }
                
                
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
    func beginModule(_ moduleid: String) {
        
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
     Advances to the next lesson, if there is one, also saves our progress
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
        
        // Save progress to the database
        saveData()
        
    }
    
    /*
     Determines whether or not there is a next lesson
     */
    func hasNextLesson() -> Bool {
        
        // Ensure currentModule exists, so we can safely force unwrap
        guard currentModule != nil else {
            // Says there is no next lesson
            return false
        }
        
        // If there is still another lesson, then we return true/ false here 
        return (currentLessonIndex + 1 < currentModule!.content.lessons.count)
        
    }
    
    /*
     Sets the current module, and the first question
     */
    func beginTest(_ moduleId:String) {
        
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
     Proceeds to the next test question, if there was one available, then saves the progress to the database
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
        
        // Save progress to the database
        saveData()
        
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
