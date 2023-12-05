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
    @State private var isPopoverOpen = false
    @State private var repsDiff: Float = 0
    
    let set: Sets
    let onSetChange: ((Int) -> Void)
    
    var body: some View {
        GridRow {
            SetNameView(
                name: set.name,
                skipped: set.skipped,
                onSkipPressed: { newValue in
                    set.skipped = newValue
                }
            )
            Text(String(set.reps.count))
                .longPressAndDrag(
                    dragSensitivity: dragSensitivity,
                    isDragging: $isPopoverOpen,
                    offset: $repsDiff
                )
                .popover(isPresented: $isPopoverOpen) {
                    Text(String(max(set.reps.count + Int(repsDiff.rounded()), 1)))
                        .presentationCompactAdaptation((.popover))
                }
                .onChange(of: isPopoverOpen, initial: false) { oldValue, newValue  in
                    if oldValue == true && newValue == false { // i.e. just got closed
                        onSetChange(Int(repsDiff.rounded()))
                    } else if oldValue == false && newValue == true { // i.e. just got opened
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
            Text(String(set.getCommonWeight()?.clean ?? "WTF"))
            Text(String(set.getCommonReps() ?? 0)) + Text(" \(set.remark ?? "")").font(.footnote)
        }.if({return set.skipped}()) { view in
            view.foregroundStyle(.gray)
        }
    }
}

struct LongPressAndDrag: ViewModifier {
    @State private var repsDiff: Float = 0
    
    let dragSensitivity: Int
    @Binding var isDragging: Bool
    @Binding var offset: Float
    
    func body(content: Content) -> some View {
        let longPressGesture = LongPressGesture()
            .onEnded { value in
                offset = 0
                isDragging = true
            }
        let dragGesture = DragGesture()
            .onChanged { value in offset = Float(value.translation.width) / Float(dragSensitivity) }
            .onEnded { _ in
                isDragging = false
            }
        
        let combinedGesture = longPressGesture.sequenced(before: dragGesture)
        
        content.gesture(combinedGesture)
    }
}

extension View {
    func longPressAndDrag(
        dragSensitivity: Int,
        isDragging: Binding<Bool>,
        offset: Binding<Float>
    ) -> some View {
        modifier(
            LongPressAndDrag(
                dragSensitivity: dragSensitivity,
                isDragging: isDragging,
                offset: offset
            )
        )
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
