//
//  Workouts.swift
//  Escalate
//
//  Created by Louis Tsai on 25.12.23.
//

import Foundation
import SwiftData

/// Workouts is the model of a workout session
/// e.g. You go to gym today for 1h, that is a 1 hour "Workouts"
/// Note: I know the plural is a bit confusing, that's because I cannot call Set "Set", plus each @Model is a database anyway, which often uses plural.
@Model
class Workouts: Codable {
    enum CodingKeys: CodingKey {
        case exercises, startTime, comment
    }
    
    @Relationship(deleteRule: .cascade) var exercises: [Exercises]
    var startTime: Date
    var comment: String?
    // TODO: add location
    
    init(startTime: Date, exercises: [Exercises] = [], comment: String? = nil) {
        self.startTime = startTime
        self.exercises = exercises
        self.comment = comment
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.exercises = try container.decode([Exercises].self, forKey: .exercises)
        self.startTime = try container.decode(Date.self, forKey: .startTime)
        self.comment = try container.decode(String.self, forKey: .comment)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(exercises, forKey: .exercises)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(comment, forKey: .comment)
    }
}
