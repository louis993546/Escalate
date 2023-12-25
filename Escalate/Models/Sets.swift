//
//  Set.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import Foundation
import SwiftData

@Model
final class Sets: Codable {
    enum CodingKeys: CodingKey {
        case reps, weight
    }
    
    var reps: Int
    var weight: Float
    
    init(reps: Int, weight: Float) {
        self.reps = reps
        self.weight = weight
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.reps = try container.decode(Int.self, forKey: .reps)
        self.weight = try container.decode(Float.self, forKey: .weight)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(reps, forKey: .reps)
        try container.encode(weight, forKey: .weight)
    }
}
