//
//  Rep.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import Foundation
import SwiftData

@Model
final class Rep {
    var rep: Int
    var weightNumber: Float
    
    init(rep: Int, weightNumber: Float) {
        self.rep = rep
        self.weightNumber = weightNumber
    }
}
