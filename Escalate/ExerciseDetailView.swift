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
                    if exercise.comment != nil {
                        Text(exercise.comment!)
                    } // TODO: else button to add comment
                    
                    Separator()
                    ExerciseHeaderRowView()
                    Separator()
                    
                    ForEach(exercise.sets.sorted(by: { $0.order < $1.order }), id: \.id) { set in
                        SetsRowView(
                            set: set,
                            onSetChange: { diff in
                                print("diff = \(diff)")
                                
                                exercise.sets = exercise.sets.map { (s) -> Sets in
                                    if set == s {
                                        var newReps = s.reps.map {
                                            return Reps(rep: $0.rep, weightNumber: $0.weightNumber)
                                        }
                                        guard let lastRep = newReps.last else { return s }
                                        if (diff < 0) {
                                            let count = abs(diff)
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
                                            reps: newReps
                                        )
                                    } else {
                                        return s
                                    }
                                }
                            }
                        )
                        Separator()
                    }
                }
                .padding()
            }
            .navigationTitle(exercise.startTime.formatted())
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
//                                modelContext.delete(exercise)
//                                self.commitDataEntry()
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
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
//        .onAppear(perform: loadStateVariables)
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

struct SetsRowView: View {
    @AppStorage("dragSensitivity") private var dragSensitivity = 24
    
    // TODO: (double) tap => Edit mode
    @State private var isDragging = false
    @State private var repsDiff: Float = 0
    
    let set: Sets
    let onSetChange: ((Int) -> Void)
    
    var body: some View {
        let longPressGesture = LongPressGesture()
            .onEnded { value in
                withAnimation {
                    isDragging = true
                }
            }
        let dragGesture = DragGesture()
            .onChanged { value in repsDiff = Float(value.translation.width) / Float(dragSensitivity) }
            .onEnded { _ in
                onSetChange(Int(repsDiff))
                
                repsDiff = 0
                isDragging = false
            }
        
        let combinedGesture = longPressGesture.sequenced(before: dragGesture)
        
        GridRow {
            Text(set.name)
            Text(String(format: "%.0f", max(Float(set.reps.count) + repsDiff, 0)))
                .gesture(combinedGesture)
            Text(String(set.getCommonWeight() ?? 0))
            Text(String(set.getCommonReps() ?? 0))
        }
    }
}

struct ExerciseHeaderRowView: View {
    var body: some View {
        GridRow {
            Text("#")
            Text("Sets")
            Text("Weight")
            Text("Reps")
        }.bold()
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

private struct Separator: View {
    var body: some View {
        Rectangle()
            .fill(.secondary)
            .frame(height: 1)
            .foregroundStyle(.gray)
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
    )
}
