//
//  HistoryView.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import SwiftUI

struct HistoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedExercise: Exercise?
    
    let exercises: [Exercise]
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedExercise) {
                ForEach(exercises, id: \.id) { exercise in
                    NavigationLink(value: exercise) {
                        Text(exercise.startTime.formatted())
                            .contextMenu {
                                Button {
                                    deleteExercise(exercise: exercise)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                
                                Button {
                                    addExercise()
                                } label: {
                                    Label("Again", systemImage: "doc.on.doc")
                                }
                            }
                    }
                }
                .onDelete(perform: removeExercise)
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem {
                    Menu {
                        Button {
                            addExercise()
                        } label: {
                            Label("Add from scratch", systemImage: "plus.square")
                        }
                        
                        // TODO: not just hide it, if there is no history, just skip the menu
                        if !exercises.isEmpty {
                            Button {
                                addExercise()
                            } label: {
                                Label("Clone from history", systemImage: "doc.on.doc")
                            }
                        }
                    } label: {
                        Label("Add From Scratch", systemImage: "plus")
                    }
                }
            }
        } detail: {
            if selectedExercise != nil {
                ExerciseDetailView(exercise: selectedExercise!)
            }
        }
    }
    
    private func addExercise() {
        withAnimation {
            let newExercise = Exercise(sets: [], startTime: Date())
            modelContext.insert(newExercise)
        }
    }
    
    private func removeExercise(offsets: IndexSet) {
        for index in offsets {
            deleteExercise(exercise: exercises[index])
        }
    }
    
    private func deleteExercise(exercise: Exercise) {
        withAnimation {
            modelContext.delete(exercise)
        }
    }
}

#Preview {
    HistoryListView(
        exercises: [
            Exercise(sets: [], startTime: Date()),
            Exercise(sets: [], startTime: Date()),
            Exercise(sets: [], startTime: Date())
        ]
    )
}
