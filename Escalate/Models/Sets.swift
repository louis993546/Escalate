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
        case name, order, reps, skipped, remark
    }
    
    var name: String
    var order: Int // TODO: for some reason order was not preserved the layer above (Exercise)
    @Relationship(deleteRule: .cascade) var reps: [Reps]
    var skipped: Bool
    var remark: String?
    
    init(name: String, order: Int, reps: [Reps] = [], skipped: Bool = false, remark: String? = nil) {
        self.name = name
        self.order = order
        self.reps = reps
        self.skipped = skipped
        self.remark = remark
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
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.order = try container.decode(Int.self, forKey: .order)
        self.reps = try container.decode([Reps].self, forKey: .reps)
        self.skipped = try container.decode(Bool.self, forKey: .skipped)
        self.remark = try container.decode(String.self, forKey: .remark)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(order, forKey: .order)
        try container.encode(reps, forKey: .reps)
        try container.encode(skipped, forKey: .skipped)
        try container.encode(remark, forKey: .remark)
    }
}
