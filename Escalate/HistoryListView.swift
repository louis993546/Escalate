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
                                        selectedExercise = addExercise()
                                        
                                    } label: {
                                        Label("Again", systemImage: "doc.on.doc")
                                    }

                                    ShareLink(
                                        item: exercise,
                                        preview: .init(exercise.startTime.formatted() + ".json")
                                    )

                                    Button(role: .destructive) {
                                        removeExercise(exercise: exercise)
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
                                    selectedExercise = addExercise()
                                } label: {
                                    Label("Add from scratch", systemImage: "plus.square")
                                }

                                // TODO: not just hide it, if there is no history, just skip the menu
                                if !exercises.isEmpty {
                                    Button {
                                       selectedExercise = addExercise()
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

    private func addExercise() -> Exercise {
        return withAnimation {
            let newExercise = Exercise(startTime: Date(), comment: "")
            modelContext.insert(newExercise)

            newExercise.sets.append(Sets(name: "01", order: 1, reps: [Reps(rep: 12, weightNumber: 40), Reps(rep: 12, weightNumber: 40), Reps(rep: 12, weightNumber: 40)]))
            newExercise.sets.append(Sets(name: "02", order: 2, reps: [Reps(rep: 8, weightNumber: 35), Reps(rep: 8, weightNumber: 35), Reps(rep: 8, weightNumber: 35)]))
            newExercise.sets.append(Sets(name: "03", order: 3, reps: [Reps(rep: 10, weightNumber: 50), Reps(rep: 10, weightNumber: 50), Reps(rep: 10, weightNumber: 50)]))
            newExercise.sets.append(Sets(name: "04(A)", order: 4, reps: [Reps(rep: 14, weightNumber: 15), Reps(rep: 14, weightNumber: 15), Reps(rep: 14, weightNumber: 15)], remark: "😕"))
            newExercise.sets.append(Sets(name: "05(A)", order: 5, reps: [Reps(rep: 8, weightNumber: 57.5), Reps(rep: 8, weightNumber: 57.5), Reps(rep: 8, weightNumber: 57.5)]))
            newExercise.sets.append(Sets(name: "06", order: 6, reps: [Reps(rep: 8, weightNumber: 20), Reps(rep: 8, weightNumber: 20), Reps(rep: 8, weightNumber: 20)]))
            newExercise.sets.append(Sets(name: "07", order: 7, reps: [Reps(rep: 10, weightNumber: 100), Reps(rep: 10, weightNumber: 100), Reps(rep: 10, weightNumber: 100)]))
            newExercise.sets.append(Sets(name: "07(L)", order: 8, reps: [Reps(rep: 8, weightNumber: 20), Reps(rep: 8, weightNumber: 20), Reps(rep: 8, weightNumber: 20)], remark: "+"))
            newExercise.sets.append(Sets(name: "08", order: 9, reps: [Reps(rep: 8, weightNumber: 55), Reps(rep: 8, weightNumber: 55), Reps(rep: 8, weightNumber: 55)], remark: "+"))
            newExercise.sets.append(Sets(name: "09", order: 10, reps: [Reps(rep: 8, weightNumber: 55), Reps(rep: 8, weightNumber: 55), Reps(rep: 8, weightNumber: 55)]))
            newExercise.sets.append(Sets(name: "13 👍", order: 11, reps: [Reps(rep: 12, weightNumber: 22.5), Reps(rep: 12, weightNumber: 22.5), Reps(rep: 12, weightNumber: 22.5)]))
            newExercise.sets.append(Sets(name: "14", order: 12, reps: [Reps(rep: 10, weightNumber: 30), Reps(rep: 10, weightNumber: 30), Reps(rep: 10, weightNumber: 30)]))
            newExercise.sets.append(Sets(name: "17", order: 13, reps: [Reps(rep: 15, weightNumber: 30), Reps(rep: 15, weightNumber: 30), Reps(rep: 15, weightNumber: 30)]))
            newExercise.sets.append(Sets(name: "21", order: 14, reps: [Reps(rep: 10, weightNumber: 20), Reps(rep: 10, weightNumber: 20), Reps(rep: 10, weightNumber: 20)], remark: "+"))
            newExercise.sets.append(Sets(name: "22 👍", order: 15, reps: [Reps(rep: 9, weightNumber: 12.5), Reps(rep: 9, weightNumber: 12.5), Reps(rep: 9, weightNumber: 12.5)]))
            newExercise.sets.append(Sets(name: "23 single", order: 16, reps: [Reps(rep: 8, weightNumber: 15), Reps(rep: 8, weightNumber: 15), Reps(rep: 8, weightNumber: 15)]))

            newExercise.sets.append(Sets(name: "24", order: 17, reps: [Reps(rep: 12, weightNumber: 22.5), Reps(rep: 12, weightNumber: 22.5), Reps(rep: 12, weightNumber: 22.5)]))
            newExercise.sets.append(Sets(name: "120 L", order: 18, reps: [Reps(rep: 8, weightNumber: 17.5), Reps(rep: 8, weightNumber: 17.5), Reps(rep: 8, weightNumber: 17.5)]))
            newExercise.sets.append(Sets(name: "120 R", order: 19, reps: [Reps(rep: 8, weightNumber: 17.5), Reps(rep: 8, weightNumber: 17.5), Reps(rep: 8, weightNumber: 17.5)]))
            newExercise.sets.append(Sets(name: "Pectoral", order: 20, reps: [Reps(rep: 12, weightNumber: 15), Reps(rep: 12, weightNumber: 15), Reps(rep: 12, weightNumber: 15)], remark: "😕"))

            // Dummy
            newExercise.sets.append(Sets(name: "test", order: 21, reps: [Reps(rep: 12, weightNumber: 22.5), Reps(rep: 12, weightNumber: 22.5), Reps(rep: 12, weightNumber: 22.5)], skipped: true))
            
            return newExercise
        }
    }

    private func removeExercise(offsets: IndexSet) {
        for index in offsets {
            removeExercise(exercise: exercises[index])
        }
    }

    private func removeExercise(exercise: Exercise) {
        withAnimation {
            modelContext.delete(exercise)
        }
    }
}

#Preview {
    HistoryListView()
}
