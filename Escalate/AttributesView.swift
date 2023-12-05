//
//  AttributesView.swift
//  Escalate
//
//  Created by Louis Tsai on 05.12.23.
//

import SwiftUI

struct AttributesView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(exercise.startTime.time())
            
            if let string = exercise.comment, !string.isEmpty {
                Text(string)
            } else {
                Text("Add comment").foregroundStyle(.gray)
            }
        }
    }
}

extension Date {
    func time() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: self)
    }
}

#Preview("No comment") {
    AttributesView(
        exercise: Exercise(startTime: Date())
    )
}

#Preview("With comment") {
    AttributesView(
        exercise: Exercise(startTime: Date(), comment: "Deserunt eu cupidatat ut deserunt et commodo consectetur occaecat sit qui deserunt. Nostrud eu exercitation incididunt nisi incididunt exercitation aute occaecat commodo labore sunt pariatur anim. Esse esse deserunt lorem consectetur et deserunt laboris ad eu sint.")
    )
}
