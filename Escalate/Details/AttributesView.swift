//
//  AttributesView.swift
//  Escalate
//
//  Created by Louis Tsai on 05.12.23.
//

import SwiftUI

struct AttributesView: View {
    let workout: Workouts
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(workout.startTime.time())
            
            let commentText = (workout.comment ?? "").isEmpty ? "Add comment" : workout.comment!
            EditableText(
                text: .init(
                    get: { return commentText },
                    set: { newText in
                        workout.comment = newText
                    }
                )
            )
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
        workout: Workouts(startTime: Date())
    )
}

#Preview("With comment") {
    AttributesView(
        workout: Workouts(startTime: Date(), comment: "Deserunt eu cupidatat ut deserunt et commodo consectetur occaecat sit qui deserunt. Nostrud eu exercitation incididunt nisi incididunt exercitation aute occaecat commodo labore sunt pariatur anim. Esse esse deserunt lorem consectetur et deserunt laboris ad eu sint.")
    )
}
