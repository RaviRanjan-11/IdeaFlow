//
//  Viewmodel.swift
//  IdeaFlow
//
//  Created by Ravi Ranjan on 19/05/24.
//

import Foundation


class ViewModel {
    
    
    
    private let data = DataModel(
        hashTaglist: [
            "idea",
            "technology",
            "innovation",
            "data",
            "science",
            "research",
            "business",
            "development",
            "programming",
            "engineering"
        ],
        Namelist: [
            "Cody",
            "Raveena",
            "Ravi",
            "Marie",
            "Grace",
            "Steve",
                        
        ],
        Relationlist: [
            "Tesla-Motors",
            "Analytical-Engine",
            "IdeaFlow",
            "Artificial-Intelligence",
            "Quantum-Computing",
            "Genetic-Engineering",
            "Machine-Learning",
            "Blockchain-Technology"
        ]
    )
    
    func getHashTagsContaining(string: String) -> [String] {
        if string.isEmpty {
            return data.hashTaglist
        } else {
            return data.hashTaglist.filter { $0.lowercased().contains(string.lowercased()) }
        }
    }
    
    func getMentionsContaining(string: String) -> [String] {
        if string.isEmpty {
            return data.Namelist
        } else {
            return data.Namelist.filter { $0.lowercased().contains(string.lowercased()) }
        }
    }
    
    func getRelationList(string:String) -> [String] {
        if string.isEmpty {
            return data.Relationlist
        } else {
            return data.Relationlist.filter { $0.lowercased().contains(string.lowercased()) }
        }
       
    }
    
    
}
