//
//  SetsRowView.swift
//  Escalate
//
//  Created by Louis Tsai on 05.12.23.
//

import SwiftUI

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
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                }
            }
        let dragGesture = DragGesture()
            .onChanged { value in repsDiff = Float(value.translation.width) / Float(dragSensitivity) }
            .onEnded { _ in
                onSetChange(Int(repsDiff.rounded()))
                
                repsDiff = 0
                isDragging = false
            }
        
        let combinedGesture = longPressGesture.sequenced(before: dragGesture)
        
        GridRow {
            Text(set.name)
                .frame(minWidth: 40, minHeight: 22, alignment: .leading)
                .contentShape(Rectangle())
                .contextMenu {
                    Button(role: .destructive) {
                        // TODO
                    } label: {
                        Label("Delete (coming soon)", systemImage: "trash")
                    }
                    
                    Button {
                        set.skipped = !set.skipped
                    } label: {
                        Label(
                            set.skipped ? "Resume" : "Mark as skipped",
                            systemImage: set.skipped ? "play" : "pause"
                        )
                    }
                }
            Text(String(set.reps.count))
                .gesture(combinedGesture)
                .popover(isPresented: $isDragging) {
                    Text(
                        String(
                            max(
                                set.reps.count + Int(repsDiff.rounded()),
                                0
                            )
                        )
                    )
                    .presentationCompactAdaptation((.popover))
                }
            Text(String(set.getCommonWeight()?.clean ?? "WTF"))
            Text(String(set.getCommonReps() ?? 0)) + Text(" \(set.remark ?? "")").font(.footnote)
        }.if({return set.skipped}()) { view in
            view.foregroundStyle(.gray)
        }
    }
}

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

#Preview {
    Grid {
        SetsRowView(
            set: Sets(name: "01", order: 1),
            onSetChange: { _ in }
        )
    }
}
