//
//  ExerciseDetailView.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    
    var body: some View {
        NavigationStack {
            Text("thing")
                .navigationTitle(exercise.startTime.formatted())
        }
    }
}

#Preview {
    ExerciseDetailView(
        exercise: Exercise(sets: [], startTime: Date())
    )
}
