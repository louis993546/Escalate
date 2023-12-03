//
//  Set.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import Foundation
import SwiftData

@Model
final class Set {
    var reps: [Rep]
    
    init(reps: [Rep]) {
        self.reps = reps
    }
}
