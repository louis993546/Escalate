//
//  Item.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import Foundation
import SwiftData

@Model
final class Exercise {
    var sets: [Set]
    var startTime: Date
    
    init(sets: [Set], startTime: Date) {
        self.sets = sets
        self.startTime = startTime
    }
}
