//
//  SetNameView.swift
//  Escalate
//
//  Created by Louis Tsai on 05.12.23.
//

import SwiftUI

struct ExercisesNameView: View {
    let name: String
    let skipped: Bool
    
    let onDeletePressed: () -> Void
    let onSkipPressed: ((Bool) -> Void)
    
    var body: some View {
        Text(name)
            .frame(minWidth: 40, minHeight: 22, alignment: .leading)
            .contentShape(Rectangle())
            .contextMenu {
                Button(role: .destructive) {
                    onDeletePressed()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                
                Button {
                    onSkipPressed(!skipped)
                } label: {
                    Label(
                        skipped ? "Resume" : "Mark as skipped",
                        systemImage: skipped ? "play" : "pause"
                    )
                }
            }
    }
}

#Preview("not skipped") {
    ExercisesNameView(
        name: "01", 
        skipped: false,
        onDeletePressed: { },
        onSkipPressed: { _ in }
    )
}

#Preview("skipped") {
    ExercisesNameView(
        name: "01",
        skipped: true,
        onDeletePressed: { },
        onSkipPressed: { _ in }
    )
}
