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
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ]
                ) {
                    ForEach(exercise.sets, id: \.id) { set in
                        Text(set.name)
                        Text(String(set.reps.count))
                        Text(String(set.getCommonWeight() ?? 0))
                        Text(String(set.getCommonReps() ?? 0))
                    }
                }
            }
            .navigationTitle(exercise.startTime.formatted())
        }
    }
}

#Preview {
    ExerciseDetailView(
        exercise: Exercise(
            sets: [
                Sets(
                    name: "01",
                    reps: [
                        Reps(rep: 8, weightNumber: 40)
                    ]
                )
            ],
            startTime: Date()
        )
    )
}
