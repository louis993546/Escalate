//
//  ExerciseHeaderRowView.swift
//  Escalate
//
//  Created by Louis Tsai on 05.12.23.
//

import SwiftUI

struct ExerciseHeaderRowView: View {
    var body: some View {
        GridRow {
            Text("#")
            Text("Sets")
            Text("Weight")
            Text("Reps")
        }.bold()
    }
}


#Preview {
    Grid {
        ExerciseHeaderRowView()
    }
}
