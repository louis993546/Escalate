//
//  SettingsView.swift
//  Escalate
//
//  Created by Louis Tsai on 03.12.23.
//

import SwiftUI

struct SettingsView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    
    var body: some View {
        NavigationStack {
            ZStack {
                Text("Coming soon")
                
                VStack {
                    Spacer()
                    Text(appVersion ?? "unknown")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
