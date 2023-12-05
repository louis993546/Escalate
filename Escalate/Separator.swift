//
//  Separator.swift
//  Escalate
//
//  Created by Louis Tsai on 05.12.23.
//

import SwiftUI

struct Separator: View {
    var body: some View {
        Rectangle()
            .fill(.secondary)
            .frame(height: 1)
            .foregroundStyle(.gray)
    }
}

#Preview {
    Separator()
}
