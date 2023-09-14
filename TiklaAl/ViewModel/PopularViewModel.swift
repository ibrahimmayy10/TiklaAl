//
//  PopularViewModel.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 6.09.2023.
//

import Foundation

class PopularViewModel {
    var popular = [PopularModel]()
    
    func downloadPopular (completion: @escaping () -> Void ) {
        Webservices.shared.downloadPopular { [weak self] popular in
            if let popular = popular {
                self?.popular = popular
            }
            completion()
        }
    }
}
