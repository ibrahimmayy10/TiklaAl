//
//  CoreDataHelper.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 10.09.2023.
//

import Foundation
import CoreData

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Product")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    func saveImage(images: [String]) {
        let context = persistentContainer.viewContext
        let product = Product(context: context)
        let combinedImages = images.joined(separator: ",")
        product.image = combinedImages
        
        do {
            try context.save()
        } catch {
            print("Error saving images: \(error)")
        }
    }
    
    func getImages() -> [String] {
        let context = persistentContainer.viewContext
        do {
            let request: NSFetchRequest<Product> = Product.fetchRequest()
            let product = try context.fetch(request).first
            if let images = product?.image {
                let image = [images]
                return image
            }
        } catch {
            print("Error fetching images: \(error)")
            return []
        }
        return []
    }
}
