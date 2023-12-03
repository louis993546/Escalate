//
//  ContentView.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Exercise.startTime, order: .reverse) private var exercises: [Exercise]
    
    var body: some View {
        TabView {
            HistoryListView(
                exercises: exercises
            ).tabItem {
                Label("History", systemImage: "gym.bag.fill")
            }
            
            NavigationStack {
                Text("Coming soon")
                    .navigationTitle("Statistics")
            }
            .tabItem {
                Label("Statistics", systemImage: "chart.line.uptrend.xyaxis")
            }
            
            NavigationStack {
                Text("Coming soon")
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Exercise.self, inMemory: true)
}
