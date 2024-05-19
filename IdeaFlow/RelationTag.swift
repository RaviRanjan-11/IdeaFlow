//
//  RelationTag.swift
//  IdeaFlow
//
//  Created by Ravi Ranjan on 19/05/24.
//

import Foundation
enum RelationType {
    case hashTag
    case mention
    case relation
    case none
    
    var description: String {
        switch self {
        case .hashTag:
            return "Hash Tag"
        case .mention:
            return "Mention"
        case .relation:
            return "Relation"
        case .none:
            return "None"
        }
    }
}
