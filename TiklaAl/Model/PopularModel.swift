//
//  PopularModel.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 6.09.2023.
//

import Foundation

struct PopularModel: Codable {
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String?
    let rating: Rating
}

struct Rating: Codable {
    let rate: Double
    let count: Int
}
