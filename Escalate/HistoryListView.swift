//
//  HistoryView.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import SwiftUI
import SwiftData

struct HistoryListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Exercise.startTime, order: .reverse) private var exercises: [Exercise]
    
    @State private var selectedExercise: Exercise?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedExercise) {
                ForEach(exercises, id: \.id) { exercise in
                    NavigationLink(value: exercise) {
                        Text(exercise.startTime.formatted())
                            .contextMenu {
                                Button {
                                    addExercise()
                                } label: {
                                    Label("Again", systemImage: "doc.on.doc")
                                }
                                
                                ShareLink(
                                    item: exercise,
                                    preview: .init(exercise.startTime.formatted() + ".json")
                                )
                                
                                Button(role: .destructive) {
                                    deleteExercise(exercise: exercise)
                                } label: {
                                    Label("Delete", systemImage: "trash")
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
            let newExercise = Exercise(startTime: Date(), comment: "Elit est amet ipsum voluptate ut exercitation adipiscing tempor duis culpa incididunt.")
            modelContext.insert(newExercise)
            
            newExercise.sets.append(Sets(name: "01", order: 1, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "02", order: 2, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "03", order: 3, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "04", order: 4, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "05", order: 5, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "06", order: 6, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "07", order: 7, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "08", order: 8, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "09", order: 9, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "10", order: 10, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "11", order: 11, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "12", order: 12, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "13", order: 13, reps: [Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40),Reps(rep: 8, weightNumber: 40)]))
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
    HistoryListView()
}
