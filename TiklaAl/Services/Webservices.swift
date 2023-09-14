//
//  Webservices.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 6.09.2023.
//

import Foundation

enum CategoryError: Error {
    case serverError
    case parsingError
}

class Webservices {
    static let shared = Webservices()
    
    func downloadPopular (completion: @escaping ([PopularModel]?) -> Void ) {
        guard let url = URL(string: "https://fakestoreapi.com/products") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode([PopularModel].self, from: data)
                completion(response)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func downloadProducts (completion: @escaping ([Products]?) -> Void ) {
        guard let url = URL(string: "https://dummyjson.com/products") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let response = try JSONDecoder().decode(ProductsModel.self, from: data)
                completion(response.products)
            } catch let error {
                print("JSON çözümleme hatası: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    func searchCategory(url: URL, completion: @escaping (Result<[Products]?, CategoryError>) -> Void ) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.serverError))
            } else if let data = data {
                let searchCategory = try? JSONDecoder().decode(ProductsModel.self, from: data)
                let searchItem = searchCategory?.products
                completion(.success(searchItem))
            }
        }.resume()
    }
}
