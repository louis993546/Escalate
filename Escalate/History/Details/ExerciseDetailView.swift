//
//  ExerciseDetailView.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import SwiftUI
import SwiftData

struct ExerciseDetailView: View {
    @Environment(\.modelContext) private var modelContext
    //    @Environment(\.presentationMode) var presentationMode
    
    let exercise: Exercise
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {
                    AttributesView(exercise: exercise)
                    Separator()
                    ExerciseHeaderRowView()
                    Separator()
                    
                    ForEach(exercise.sets.sorted(by: { $0.order < $1.order }), id: \.id) { set in
                        SetsRowView(
                            set: set,
                            onSetChange: { diff in
                                updateSet(diff: diff, oldSet: set)
                            }
                        )
                        Separator()
                    }
                }
                .scrollTargetLayout()
                .padding()
            }
            .scrollTargetBehavior(.viewAligned)
            .navigationTitle(exercise.startTime.prettyPrint())
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem {
                    ShareLink(
                        item: exercise,
                        preview: .init(exercise.startTime.formatted() + ".json")
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
    
    private func updateSet(diff: Int, oldSet set: Sets) {
        exercise.sets = exercise.sets.map { (s) -> Sets in
            if set.id == s.id {
                var newReps = s.reps.map {
                    return Reps(rep: $0.rep, weightNumber: $0.weightNumber)
                }
                guard let lastRep = newReps.last else { return s }
                if (diff < 0) {
                    let count = min(abs(diff), newReps.count - 1)
                    count.times {
                        newReps.removeLast()
                    }
                } else {
                    diff.times {
                        newReps.append(
                            Reps(rep: lastRep.rep, weightNumber: lastRep.weightNumber)
                        )
                    }
                }
                return Sets(
                    name: s.name,
                    order: s.order,
                    reps: newReps,
                    skipped: s.skipped,
                    remark: s.remark
                )
            } else {
                return s
            }
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

extension Exercise: Transferable {
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
    ExerciseDetailView(
        exercise: Exercise(
            startTime: Date(),
            sets: [
                Sets(
                    name: "01",
                    order: 1,
                    reps: [
                        Reps(rep: 8, weightNumber: 40.0)
                    ]
                )
            ]
        )
    ).modelContainer(for: Exercise.self, inMemory: true)
}
