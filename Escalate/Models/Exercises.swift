//
//  Item.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import Foundation
import SwiftData

/// Exercises is the model of a single activity
/// e.g. You go to the gym for 1h, in which you did bench press. The bench press is the "Exercises"
/// Note: I know the plural is a bit confusing, that's because I cannot call Set "Set", plus each @Model is a database anyway, which often uses plural.
@Model
class Exercises: Codable {
    enum CodingKeys: CodingKey {
        case name, order, skipped, remark, sets
    }
    
    var name: String
    var order: Int // TODO: for some reason order was not preserved the layer above (Exercise)
    var skipped: Bool
    var remark: String?
    @Relationship(deleteRule: .cascade) var sets: [Sets]
    
    init(
        name: String,
        order: Int,
        sets: [Sets] = [],
        skipped: Bool = false,
        remark: String? = nil
    ) {
        self.name = name
        self.order = order
        self.sets = sets
        self.skipped = skipped
        self.remark = remark
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.order = try container.decode(Int.self, forKey: .order)
        self.skipped = try container.decode(Bool.self, forKey: .skipped)
        self.remark = try container.decode(String.self, forKey: .remark)
        self.sets = try container.decode([Sets].self, forKey: .sets)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(order, forKey: .order)
        try container.encode(skipped, forKey: .skipped)
        try container.encode(remark, forKey: .remark)
        try container.encode(sets, forKey: .sets)
    }
    
    func getCommonReps() -> Int? {
        return sets.allSatisfy { set in
            set.reps == sets.first?.reps
        } ? sets.first?.reps : nil
    }
    
    func getCommonWeight() -> Float? {
        return sets.allSatisfy { set in
            set.weight == sets.first?.weight
        } ? sets.first?.weight : nil
    }
}

