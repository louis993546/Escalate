//
//  ContentView.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var exercises: [Exercise]
    
    var body: some View {
        TabView {
            NavigationSplitView {
                HistoryListView(
                    exercises: exercises,
                    onAdd: addExercise,
                    onDelete: removeExercise
                )
            } detail: {
                Text("Select an entry")
            }.tabItem {
                Label("History", systemImage: "gym.bag.fill")
            }
            
            Text("Coming soon")
                .tabItem {
                    Label("Settings", systemImage: "gear")
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
        withAnimation {
            for index in offsets {
                modelContext.delete(exercises[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Exercise.self, inMemory: true)
}
