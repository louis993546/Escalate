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
    @Query(sort: \Workouts.startTime, order: .reverse) private var workouts: [Workouts]
    
    @State private var selectedWorkout: Workouts?
    
    var body: some View {
        
        NavigationSplitView {
            List(selection: $selectedWorkout) {
                ForEach(workouts, id: \.id) { workout in
                    NavigationLink(value: workout) {
                        Text(workout.startTime.prettyPrint())
                            .contextMenu {
                                Button {
                                    modelContext.insert(workout.deepCopy(newDate: Date()))
                                } label: {
                                    Label("Again", systemImage: "doc.on.doc")
                                }
                                
                                ShareLink(
                                    item: workout,
                                    preview: .init(workout.startTime.formatted() + ".json")
                                )
                                
                                Button(role: .destructive) {
                                    removeWorkout(workout: workout)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
                .onDelete(perform: removeWorkout)
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem {
                    Menu {
                        Button {
                            selectedWorkout = addWorkout()
                        } label: {
                            Label("Add from scratch", systemImage: "plus.square")
                        }
                        
                        // TODO: not just hide it, if there is no history, just skip the menu
                        if !workouts.isEmpty {
                            Button {
                                selectedWorkout = addWorkout()
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
            if selectedWorkout != nil {
                WorkoutsDetailView(workout: selectedWorkout!)
            } else {
                Text("Select a workout")
            }
        }
    }
    
    private func addWorkout() -> Workouts {
        return withAnimation {
            let newWorkout = Workouts(startTime: Date(), comment: "testing")
            modelContext.insert(newWorkout)
            
            newWorkout.exercises.append(Exercises(name: "01", order: 1, sets: [Sets(reps: 12, weight: 40), Sets(reps: 12, weight: 40), Sets(reps: 12, weight: 40)]))
            newWorkout.exercises.append(Exercises(name: "02", order: 2, sets: [Sets(reps: 8, weight: 35), Sets(reps: 8, weight: 35), Sets(reps: 8, weight: 35)]))
            newWorkout.exercises.append(Exercises(name: "03", order: 3, sets: [Sets(reps: 10, weight: 50), Sets(reps: 10, weight: 50), Sets(reps: 10, weight: 50)]))
            newWorkout.exercises.append(Exercises(name: "04(A)", order: 4, sets: [Sets(reps: 14, weight: 15), Sets(reps: 14, weight: 15), Sets(reps: 14, weight: 15)], remark: "😕"))
            newWorkout.exercises.append(Exercises(name: "05(A)", order: 5, sets: [Sets(reps: 8, weight: 57.5), Sets(reps: 8, weight: 57.5), Sets(reps: 8, weight: 57.5)]))
            newWorkout.exercises.append(Exercises(name: "06", order: 6, sets: [Sets(reps: 8, weight: 20), Sets(reps: 8, weight: 20), Sets(reps: 8, weight: 20)]))
            newWorkout.exercises.append(Exercises(name: "07", order: 7, sets: [Sets(reps: 10, weight: 100), Sets(reps: 10, weight: 100), Sets(reps: 10, weight: 100)]))
            newWorkout.exercises.append(Exercises(name: "07(L)", order: 8, sets: [Sets(reps: 8, weight: 20), Sets(reps: 8, weight: 20), Sets(reps: 8, weight: 20)], remark: "+"))
            newWorkout.exercises.append(Exercises(name: "08", order: 9, sets: [Sets(reps: 8, weight: 55), Sets(reps: 8, weight: 55), Sets(reps: 8, weight: 55)], remark: "+"))
            newWorkout.exercises.append(Exercises(name: "09", order: 10, sets: [Sets(reps: 8, weight: 55), Sets(reps: 8, weight: 55), Sets(reps: 8, weight: 55)]))
            newWorkout.exercises.append(Exercises(name: "13 👍", order: 11, sets: [Sets(reps: 12, weight: 22.5), Sets(reps: 12, weight: 22.5), Sets(reps: 12, weight: 22.5)]))
            newWorkout.exercises.append(Exercises(name: "14", order: 12, sets: [Sets(reps: 10, weight: 30), Sets(reps: 10, weight: 30), Sets(reps: 10, weight: 30)]))
            newWorkout.exercises.append(Exercises(name: "17", order: 13, sets: [Sets(reps: 15, weight: 30), Sets(reps: 15, weight: 30), Sets(reps: 15, weight: 30)]))
            newWorkout.exercises.append(Exercises(name: "21", order: 14, sets: [Sets(reps: 10, weight: 20), Sets(reps: 10, weight: 20), Sets(reps: 10, weight: 20)], remark: "+"))
            newWorkout.exercises.append(Exercises(name: "22 👍", order: 15, sets: [Sets(reps: 9, weight: 12.5), Sets(reps: 9, weight: 12.5), Sets(reps: 9, weight: 12.5)]))
            newWorkout.exercises.append(Exercises(name: "23 single", order: 16, sets: [Sets(reps: 8, weight: 15), Sets(reps: 8, weight: 15), Sets(reps: 8, weight: 15)]))
            
            newWorkout.exercises.append(Exercises(name: "24", order: 17, sets: [Sets(reps: 12, weight: 22.5), Sets(reps: 12, weight: 22.5), Sets(reps: 12, weight: 22.5)]))
            newWorkout.exercises.append(Exercises(name: "120 L", order: 18, sets: [Sets(reps: 8, weight: 17.5), Sets(reps: 8, weight: 17.5), Sets(reps: 8, weight: 17.5)]))
            newWorkout.exercises.append(Exercises(name: "120 R", order: 19, sets: [Sets(reps: 8, weight: 17.5), Sets(reps: 8, weight: 17.5), Sets(reps: 8, weight: 17.5)]))
            newWorkout.exercises.append(Exercises(name: "Pectoral", order: 20, sets: [Sets(reps: 12, weight: 15), Sets(reps: 12, weight: 15), Sets(reps: 12, weight: 15)], remark: "😕"))
            
            // Dummy
            newWorkout.exercises.append(Exercises(name: "test", order: 21, sets: [Sets(reps: 12, weight: 22.5), Sets(reps: 12, weight: 22.5), Sets(reps: 12, weight: 22.5)], skipped: true))
            
            return newWorkout
        }
    }
    
    private func removeWorkout(offsets: IndexSet) {
        for index in offsets {
            removeWorkout(workout: workouts[index])
        }
    }
    
    private func removeWorkout(workout: Workouts) {
        withAnimation {
            modelContext.delete(workout)
        }
    }
}

extension Date {
    func prettyPrint() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY.MM.dd"
        
        return dateFormatter.string(from: self)
    }
}

// TODO: is there a cleaner way to do this copy?
extension Workouts {
    func deepCopy(newDate date: Date) -> Workouts {
        return Workouts(
            startTime: date,
            exercises: exercises.map { e in
                return Exercises(
                    name: e.name,
                    order: e.order,
                    sets: e.sets.map { s in
                        return Sets(
                            reps: s.reps,
                            weight: s.weight
                        )
                    },
                    skipped: e.skipped,
                    remark: e.remark
                )
            },
            comment: comment
        )
    }
}

#Preview {
    // TODO: insert some fake data here https://www.hackingwithswift.com/quick-start/swiftdata/how-to-use-swiftdata-in-swiftui-previews
    HistoryListView()
        .modelContainer(for: Workouts.self, inMemory: true)
}
