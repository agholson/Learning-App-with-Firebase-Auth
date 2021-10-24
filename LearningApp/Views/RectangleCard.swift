//
//  RectangleCard.swift
//  LearningApp
//
//  Created by Shepherd on 10/24/21.
//

import SwiftUI

/*
 Displays a green rectangle-like button/ card that we re-use in our app
 */
struct RectangleCard: View {
    
    var color = Color.white
    
    var body: some View {
        
        Rectangle()
            .foregroundColor(color)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
}

struct RectangleCard_Previews: PreviewProvider {
    static var previews: some View {
        RectangleCard()
    }
}
