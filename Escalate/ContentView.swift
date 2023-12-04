//
//  ContentView.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HistoryListView()
                .tabItem {
                Label("History", systemImage: "gym.bag.fill")
            }
            
            NavigationStack {
                // TODO: https://www.appcoda.com/swiftui-line-charts/
                Text("Coming soon")
                    .navigationTitle("Statistics")
            }
            .tabItem {
                Label("Statistics", systemImage: "chart.line.uptrend.xyaxis")
            }
            
            SettingsView()
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
