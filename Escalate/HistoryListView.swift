//
//  HistoryView.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import SwiftUI

struct HistoryListView: View {
    let exercises: [Exercise]
    
    let onAdd: (() -> Void)
    let onDelete: ((IndexSet) -> Void)
    
    var body: some View {
        List {
            ForEach(exercises, id: \.id) { exercise in
                NavigationLink {
                    ExerciseDetailView(exercise: exercise)
                } label: {
                    Text("\(exercise.startTime)")
                }
            }
            .onDelete(perform: onDelete)
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem {
                Button(action: onAdd) {
                    Label(
                        title: { Text("Add Exercise") },
                        icon: { Image(systemName: "plus") }
                    )
                }
            }
        }
    }
}

//#Preview {
//    HistoryView()
//}
