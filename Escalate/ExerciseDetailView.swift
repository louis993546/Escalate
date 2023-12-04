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
                Grid(alignment: .leading, horizontalSpacing: 12, verticalSpacing: 12) {
                    if exercise.comment != nil {
                        Text(exercise.comment!)
                    } // TODO: else button to add comment
                    
                    Separator()
                    
                    GridRow {
                        Text("#")
                        Text("Sets")
                        Text("Weight")
                        Text("Reps")
                    }.bold()
                    
                    Separator()
                    
                    ForEach(exercise.sets.sorted(by: { $0.order < $1.order }), id: \.id) { set in
                        GridRow {
                            Text(set.name)
                            Text(String(set.reps.count))
                            Text(String(set.getCommonWeight() ?? 0))
                            Text(String(set.getCommonReps() ?? 0))
                        }
                        
                        Separator()
                    }
                }
                .padding()
            }
            .navigationTitle(exercise.startTime.formatted())
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem() {
                    ShareLink(
                        item: exercise,
                        preview: .init(exercise.startTime.formatted() + ".json")
                    )
                }
            }
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
