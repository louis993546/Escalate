//
//  Item.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import Foundation
import SwiftData

// TODO: add title/comment/something like that
// TODO: add location
@Model
final class Exercise {
    var sets: [Sets]
    var startTime: Date
    
    init(sets: [Sets], startTime: Date) {
        self.sets = sets
        self.startTime = startTime
    }
}
