//
//  EditableText.swift
//  Escalate
//
//  Created by Louis Tsai on 25.12.23.
//

import SwiftUI

/// https://www.polpiella.dev/swiftui-editable-list-text-items
struct EditableText: View {
    @Binding var text: String

    @State private var temporaryText: String
    @FocusState private var isFocused: Bool

    init(text: Binding<String>) {
        self._text = text
        self.temporaryText = text.wrappedValue
    }

    var body: some View {
        TextField("", text: $temporaryText, onCommit: { text = temporaryText })
            .focused($isFocused, equals: true)
            .onTapGesture { isFocused = true }
    }
}

#Preview {
    EditableText(text: .constant("Hello"))
}
