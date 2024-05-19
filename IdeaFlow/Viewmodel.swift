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
            "Jacob Cole",
            "Elon Musk",
            "Ada Lovelace",
            "Marie Curie",
            "Alan Turing",
            "Grace Hopper",
            "Steve Jobs",
            "Bill Gates",
            "Mark Zuckerberg",
            "Tim Berners-Lee"
        ],
        Relationlist: [
            "Tesla Motors",
            "Analytical Engine",
            "Artificial Intelligence",
            "Quantum Computing",
            "Space Exploration",
            "Genetic Engineering",
            "Renewable Energy",
            "Internet of Things",
            "Machine Learning",
            "Blockchain Technology"
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
