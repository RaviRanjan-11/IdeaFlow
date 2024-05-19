//
//  FakeResponse.swift
//  IdeaFlow
//
//  Created by Ravi Ranjan on 19/05/24.
//

import Foundation

struct DataModel: Codable {
    let hashTaglist: [String]
    let Namelist: [String]
    let Relationlist: [String]
}

let data = DataModel(
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
