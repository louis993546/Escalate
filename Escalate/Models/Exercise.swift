//
//  Item.swift
//  Escalate
//
//  Created by Louis Tsai on 02.12.23.
//

import Foundation
import SwiftData

// TODO: add location
@Model
 class Exercise: Codable {
    enum CodingKeys: CodingKey {
        case sets, startTime, comment
    }
    
    @Relationship(deleteRule: .cascade) var sets: [Sets]
    var startTime: Date
    var comment: String?
    
    init(startTime: Date, sets: [Sets] = [], comment: String? = nil) {
        self.sets = sets
        self.startTime = startTime
        self.comment = comment
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sets = try container.decode([Sets].self, forKey: .sets)
        self.startTime = try container.decode(Date.self, forKey: .startTime)
        self.comment = try container.decode(String.self, forKey: .comment)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sets, forKey: .sets)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(comment, forKey: .comment)
    }
}

