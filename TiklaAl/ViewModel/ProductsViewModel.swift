//
//  ProductsViewModel.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 8.09.2023.
//

import Foundation

class ProductsViewModel {
    var products = [Products]()
    
    func downloadProducts (completion: @escaping () -> Void ) {
        Webservices.shared.downloadProducts { [ weak self ] products in
            if let products = products {
                self?.products = products
            }
            completion()
        }
    }
}
