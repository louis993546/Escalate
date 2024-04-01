//
//  ExerciseDetailView.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import SwiftUI
import SwiftData

struct WorkoutsDetailView: View {
    @Environment(\.modelContext) private var modelContext
    //    @Environment(\.presentationMode) var presentationMode
    
    let workout: Workouts
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {
                    AttributesView(workout: workout)
                    Separator()
                    ExerciseHeaderRowView()
                    Separator()
                    
                    ForEach(workout.exercises.sorted(by: { $0.order < $1.order }), id: \.id) { exercise in
                        ExercisesRowView(
                            exercise: exercise,
                            onSetChange: { diff in
                                updateSet(diff: diff, oldExercise: exercise)
                            },
                            onWeightChange: { diff in
                                updateWeight(diff: diff, oldExercise: exercise)
                            },
                            onRepChange: { diff in
                                updateRep(diff: diff, oldExercise: exercise)
                            },
                            onDeletePressed: {
                                removeExercise(exercise: exercise)
                            }
                        )
                        Separator()
                    }
                }
                .scrollTargetLayout()
                .padding()
            }
            .scrollTargetBehavior(.viewAligned)
            .navigationTitle(workout.startTime.prettyPrint())
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem {
                    ShareLink(
                        item: workout,
                        preview: .init(workout.startTime.formatted() + ".json")
                    )
                }
                
                ToolbarItem {
                    Menu {
                        Button(role: .destructive) {
                            withAnimation {
                                // modelContext.delete(exercise)
                                // self.commitDataEntry()
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            // TODO:
                        } label: {
                            Label("Reorder (Coming soon)", systemImage: "arrow.up.arrow.down")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .onAppear {
            UIApplication.shared.isIdleTimerDisabled = true
        }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
        }
        //.onAppear(perform: loadStateVariables)
    }
    
    private func updateSet(diff: Int, oldExercise exercise: Exercises) {
        guard abs(diff) > 0 else { return }
        
        workout.exercises = workout.exercises.map { (e) -> Exercises in
            if exercise.id == e.id {
                var newSets = e.sets.map {
                    return Sets(reps: $0.reps, weight: $0.weight)
                }
                guard let lastRep = newSets.last else { return e }
                if (diff < 0) {
                    let count = min(abs(diff), newSets.count - 1)
                    count.times {
                        newSets.removeLast()
                    }
                } else {
                    diff.times {
                        newSets.append(
                            Sets(reps: lastRep.reps, weight: lastRep.weight)
                        )
                    }
                }
                return Exercises(
                    name: e.name,
                    order: e.order,
                    sets: newSets,
                    skipped: e.skipped,
                    remark: e.remark
                )
            } else {
                return e
            }
        }
    }
    
    // TODO: ExerciseRowView separately does the rounding. Maybe put it in an extension?
    private func updateWeight(diff: Float, oldExercise exercise: Exercises) {
        let roundedDiff = diff.round(nearest: 0.5)
        guard abs(roundedDiff) > 0.1 else { return }
        
        workout.exercises = workout.exercises.map { (e) -> Exercises in
            if exercise.id == e.id {
                let newSets = e.sets.map {
                    let newWeight = $0.weight + roundedDiff
                    return Sets(reps: $0.reps, weight: max(0.5, newWeight))
                }
                return Exercises(
                    name: e.name,
                    order: e.order,
                    sets: newSets,
                    skipped: e.skipped,
                    remark: e.remark
                )
            } else {
                return e
            }
        }
    }
    
    private func updateRep(diff: Int, oldExercise exercise: Exercises) {
        guard abs(diff) > 0 else { return }
        
        workout.exercises = workout.exercises.map { (e) -> Exercises in
            if exercise.id == e.id {
                let newSets = e.sets.map {
                    let newReps = $0.reps + diff
                    return Sets(reps: max(1, newReps), weight: $0.weight)
                }
                return Exercises(
                    name: e.name,
                    order: e.order,
                    sets: newSets,
                    skipped: e.skipped,
                    remark: e.remark
                )
            } else { return e }
        }
    }
    
    private func removeExercise(exercise: Exercises) {
        withAnimation {
            workout.exercises = workout.exercises.filter { e in
                e.id != exercise.id
            }
            modelContext.delete(exercise)
        }
    }
}

// https://stackoverflow.com/a/30554255
extension Int {
    func times(_ f: () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
    
    func times(_ f: @autoclosure () -> ()) {
        if self > 0 {
            for _ in 0..<self {
                f()
            }
        }
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
}

extension Workouts: Transferable {
    static func jsonEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = .prettyPrinted
        
        return encoder
    }
    
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(
            contentType: .json,
            encoder: jsonEncoder(),
            decoder: JSONDecoder()
        )
        .suggestedFileName {
            $0.startTime.formatted() + ".json"
        }
    }
}

#Preview {
    WorkoutsDetailView(
        workout: Workouts(
            startTime: Date(),
            exercises: [
                Exercises(
                    name: "01",
                    order: 1,
                    sets: [
                        Sets(reps: 8, weight: 40.0)
                    ]
                )
            ]
        )
    ).modelContainer(for: Workouts.self, inMemory: true)
}
