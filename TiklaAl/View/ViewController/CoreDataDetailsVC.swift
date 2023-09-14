//
//  CoreDataDetailsVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 10.09.2023.
//

import UIKit
import CoreData

class CoreDataDetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var coreDataCollectionView: UICollectionView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var coreDataTitleLabel: UILabel!
    @IBOutlet weak var coreDataRatingLabel: UILabel!
    @IBOutlet weak var coreDataCountLabel: UILabel!
    @IBOutlet weak var coreDataDescriptionLabel: UILabel!
    @IBOutlet weak var coreDataPriceLabel: UILabel!
    
    var chosenTitle = String()
    var chosenTitleID: UUID?
    var imageArray = [String]()
    var titleArray = [String]()
    var priceArray = [Int]()
    var idArray = [UUID]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        coreDataCollectionView.dataSource = self
        coreDataCollectionView.delegate = self
        
        getCoreData()
        coreDataCollectionView.reloadData()
                
    }
    
    func getCoreData () {
        if !chosenTitle.isEmpty {
            likeBtn.setImage(UIImage(named: "heartdolu"), for: .normal)
            likeBtn.tag = 1

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            let idString = chosenTitleID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false

            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let title = result.value(forKey: "title") as? String {
                            coreDataTitleLabel.text = title
                            self.titleArray.append(title)
                        }
                        if let price = result.value(forKey: "price") as? Int {
                            coreDataPriceLabel.text = "$\(String(price))"
                            self.priceArray.append(price)
                        }
                        if let rating = result.value(forKey: "rating") as? Double {
                            coreDataRatingLabel.text = String(rating)
                        }
                        if let count = result.value(forKey: "discountPercentage") as? Double {
                            coreDataCountLabel.text = String(count)
                        }
                        if let description = result.value(forKey: "overview") as? String {
                            coreDataDescriptionLabel.text = description
                        }
                        if let imageUrl = result.value(forKey: "image") as? String {
                            self.imageArray = [imageUrl]
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func likedButton(_ sender: Any) {
        if likeBtn.tag == 1 {
            likeBtn.setImage(UIImage(named: "heartbos"), for: .normal)
            likeBtn.tag = 0

            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            if let selectedID = chosenTitleID {
                fetchRequest.predicate = NSPredicate(format: "id = %@", selectedID as CVarArg)
            }
            do {
                let result = try context.fetch(fetchRequest)
                if let objectToDelete = result.first {
                    context.delete(objectToDelete as! NSManagedObject)
                    try context.save()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    @IBAction func searchPageButton(_ sender: Any) {
        let searchVC = storyboard?.instantiateViewController(identifier: "toSearchVC") as! SearchVC
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sepeteEkleButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newFavoriteProduct = NSEntityDescription.insertNewObject(forEntityName: "Basket", into: context)
        
        newFavoriteProduct.setValue(titleArray, forKey: "titlebasket")
        newFavoriteProduct.setValue(priceArray, forKey: "pricebasket")
        newFavoriteProduct.setValue(imageArray, forKey: "imagebasket")
        newFavoriteProduct.setValue(UUID(), forKey: "idbasket")
        
        do {
            try context.save()
            print("kayıt başarılı")
        } catch {
            print(error.localizedDescription)
        }
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        let basketVC = storyboard?.instantiateViewController(identifier: "toBasketVC") as! BasketVC
        navigationController?.pushViewController(basketVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coreDataCollectionView.dequeueReusableCell(withReuseIdentifier: "coreDataCell", for: indexPath) as! CoreDataCollectionViewCell
        if let imageUrl = URL(string: imageArray[indexPath.row]), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.coreDataImageView.image = image
        }
        return cell
    }
    
}
