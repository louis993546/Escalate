//
//  SetsRowView.swift
//  Escalate
//
//  Created by Louis Tsai on 05.12.23.
//

import SwiftUI

struct ExercisesRowView: View {
    // TODO separate sensitivity for each of the slider
    @AppStorage("dragSensitivity") private var dragSensitivity = 24
    
    // TODO: (double) tap => Edit mode
    @State private var isSetsPopoverOpen = false
    @State private var isWeightPopoverOpen = false
    @State private var isRepsPopoverOpen = false
    @State private var dragDiff: Float = 0
    
    let exercise: Exercises
    let onSetChange: ((Int) -> Void)
    let onWeightChange: ((Float) -> Void)
    let onRepChange: ((Int) -> Void)
    
    var body: some View {
        GridRow {
            ExercisesNameView(
                name: exercise.name,
                skipped: exercise.skipped,
                onSkipPressed: { newValue in
                    exercise.skipped = newValue
                }
            )
            Text(String(exercise.sets.count))
                .longPressAndDrag(
                    dragSensitivity: dragSensitivity,
                    isDragging: $isSetsPopoverOpen,
                    offset: $dragDiff
                )
                .popover(isPresented: $isSetsPopoverOpen) {
                    Text(String(max(exercise.sets.count + Int(dragDiff.rounded()), 1)))
                        .presentationCompactAdaptation((.popover))
                }
                .onChange(of: isSetsPopoverOpen, initial: false) { oldValue, newValue  in
                    if oldValue == true && newValue == false { // i.e. just got closed
                        onSetChange(Int(dragDiff.rounded()))
                    } else if oldValue == false && newValue == true { // i.e. just got opened
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
            Text(String(exercise.getCommonWeight()?.clean ?? "WTF"))
                .longPressAndDrag(
                    dragSensitivity: dragSensitivity,
                    isDragging: $isWeightPopoverOpen,
                    offset: $dragDiff
                )
                .popover(isPresented: $isWeightPopoverOpen) {
                    Text("\(max(0, dragDiff + (exercise.getCommonWeight() ?? 0)).round(nearest: 0.5).decimalPlaces(decimalPlaces: 1))")
                        .presentationCompactAdaptation((.popover))
                }
                .onChange(of: isWeightPopoverOpen, initial: false) { oldValue, newValue  in
                    if oldValue == true && newValue == false { // i.e. just got closed
                        onWeightChange(dragDiff)
                    } else if oldValue == false && newValue == true { // i.e. just got opened
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
            Text(String(exercise.getCommonReps() ?? 0))
                .longPressAndDrag(
                    dragSensitivity: dragSensitivity,
                    isDragging: $isRepsPopoverOpen,
                    offset: $dragDiff
                )
                .popover(isPresented: $isRepsPopoverOpen) {
                    //                    Text(String(max(set.getCommonReps() ?? 0 + Int(dragDiff.rounded()), 0)))
                    Text("\(max(0, (Int(dragDiff.rounded()) + (exercise.getCommonReps() ?? 0))))")
                    .presentationCompactAdaptation((.popover))
                }
                .onChange(of: isRepsPopoverOpen, initial: ((exercise.getCommonReps() ?? 0) != 0)) { oldValue, newValue in
                    if oldValue == true && newValue == false { // i.e. just got closed
                        onRepChange(Int(dragDiff.rounded()))
                    } else if oldValue == false && newValue == true { // i.e. just got opened
                        UINotificationFeedbackGenerator().notificationOccurred(.success)
                    }
                }
            // TODO: put remark back
            //            + Text(" \(set.remark ?? "")").font(.footnote)
        }.if({return exercise.skipped}()) { view in
            view.foregroundStyle(.gray)
        }
    }
}

struct LongPressAndDrag: ViewModifier {
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
            .onChanged { value in
                print("\(Float(value.translation.width) / Float(dragSensitivity))")
                offset = Float(value.translation.width) / Float(dragSensitivity)
            }
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
    
    func decimalPlaces(decimalPlaces: Int) -> String {
        String(format: "%.\(decimalPlaces)f", self)
    }
    
    func round(nearest: Float) -> Float {
        let n = 1 / nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
    
    func floor(nearest: Float) -> Float {
        let intDiv = Float(Int(self / nearest))
        return intDiv * nearest
    }
}

#Preview {
    Grid {
        ExercisesRowView(
            exercise: Exercises(name: "01", order: 1),
            onSetChange: { _ in },
            onWeightChange: { _ in },
            onRepChange: { _ in }
        )
    }
}
