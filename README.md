# Learning App
Displays how to make a learning app with Swift, iOS's programming language. Based on module five in the fantastic codewithchris.com iOS Foundations course.

## Special Styling
The JSON data combines styles from HTML/ CSS into something useable in iOS/ Swift. From [Module 
5 Lesson 3 of Code with Chris](https://learn.codewithchris.com/courses/take/foundations/lessons/22274485-lesson-3-parsing-the-json-data)

## Videos
You can use the AVKit to show a video player for different lessons. First, you must click the project settings (blue icon
top left), then you scroll down to frameworks -> click the plus button, and search for AVKit. Then you import `AVKit`, at the top of the SwiftUI file you want to include your information.
![AVKit button](img/framework.png)

Code to include video within app with an external link:
```
let url = ``

// Expects a AVPlayer object with a URL object
VideoPlayer(player: AVPlayer(url: <#T##URL#>))
```

### Video Hosting Options
You can link to the videos on GitHub (after converting the repo to a GitHub pages project), Vimeo, or another publicly accessible streaming platform that allows for the direct download of the `.mp4` file.

## Displaying UIKit Elements in SwiftUI
We can use the UIViewRepresentable protocol to display UIKit elements within SwiftUI views.
