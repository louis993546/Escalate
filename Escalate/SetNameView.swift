//
//  SetNameView.swift
//  Escalate
//
//  Created by Louis Tsai on 05.12.23.
//

import SwiftUI

struct SetNameView: View {
    let name: String
    let skipped: Bool
    
    let onSkipPressed: ((Bool) -> Void)
    
    var body: some View {
        Text(name)
            .frame(minWidth: 40, minHeight: 22, alignment: .leading)
            .contentShape(Rectangle())
            .contextMenu {
                Button(role: .destructive) {
                    // TODO
                } label: {
                    Label("Delete (coming soon)", systemImage: "trash")
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
    SetNameView(
        name: "01", 
        skipped: false,
        onSkipPressed: { _ in }
    )
}

#Preview("skipped") {
    SetNameView(
        name: "01",
        skipped: true,
        onSkipPressed: { _ in }
    )
}
