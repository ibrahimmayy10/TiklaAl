//
//  ProductsModel.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 8.09.2023.
//

import Foundation

struct ProductsModel: Codable {
    let products: [Products]
}

struct Products: Codable {
    let title: String
    let description: String
    let price: Int
    let discountPercentage: Double
    let rating: Double
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String?
    let images: [String]
}
