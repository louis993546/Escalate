//
//  SettingsView.swift
//  Escalate
//
//  Created by Louis Tsai on 03.12.23.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Workouts.startTime, order: .reverse) private var workouts: [Workouts]
    
    @AppStorage("dragSensitivity") private var dragSensitivity = 24
    
    @State private var showingDeleteAlert = false
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent {
                        Stepper(value: $dragSensitivity, in: 10...100) {
                            Text(dragSensitivity.formatted(.number))
                        }
                    } label: {
                        Text("Drag Sensitivity: ")
                    }
                }
                
                Section {
                    ShareLink(
                        item: ExerciseWrapper(workouts: workouts),
                        preview: .init("WTF")
                    ) {
                        LabeledContent("Export", value: "")
                    }
                    LabeledContent("Import", value: "Coming soon")
                }
                
                Section {
                    LabeledContent("Version", value: appVersion ?? "unknown")
                }
                
                Section {
                    Button(
                        role: .destructive,
                        action: { showingDeleteAlert = true }
                    ) {
                        Text("Delete all data")
                    }
                    .confirmationDialog("Are you sure?", isPresented: $showingDeleteAlert) {
                        Button("Yes, delete everything", role: .destructive) {
                            // TODO: https://stackoverflow.com/a/76541334
//                            do {
//                                try modelContext.delete(Exercise.self)
//                                try modelContext.delete(Sets.self)
//                                try modelContext.delete(Reps.self)
//                            } catch {
//                                print(error.localizedDescription)
//                            }
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ExerciseWrapper: Codable {
    let workouts: [Workouts]
}

extension ExerciseWrapper: Transferable {
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
    }
}

#Preview {
    SettingsView()
}
