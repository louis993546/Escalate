//
//  Set.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import Foundation
import SwiftData

@Model
final class Sets {
    var name: String
    var reps: [Reps]
    
    init(name: String, reps: [Reps]) {
        self.name = name
        self.reps = reps
    }
    
    func getCommonReps() -> Int? {
        return reps.allSatisfy { rep in
            rep.rep == reps.first?.rep
        } ? reps.first?.rep : nil
    }
    
    func getCommonWeight() -> Float? {
        return reps.allSatisfy { rep in
            rep.weightNumber == reps.first?.weightNumber
        } ? reps.first?.weightNumber : nil
    }
}
