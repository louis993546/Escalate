//
//  Rep.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import Foundation
import SwiftData

@Model
final class Reps: Codable {
    enum CodingKeys: CodingKey {
        case rep, weightNumber
    }
    
    var rep: Int
    var weightNumber: Float
    
    init(rep: Int, weightNumber: Float) {
        self.rep = rep
        self.weightNumber = weightNumber
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.rep = try container.decode(Int.self, forKey: .rep)
        self.weightNumber = try container.decode(Float.self, forKey: .weightNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(rep, forKey: .rep)
        try container.encode(weightNumber, forKey: .weightNumber)
    }
}
