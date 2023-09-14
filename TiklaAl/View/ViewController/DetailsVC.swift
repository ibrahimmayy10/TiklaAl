//
//  DetailsVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 8.09.2023.
//

import UIKit
import CoreData

class DetailsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    var products: Products?
    
    var chosenTitle = String()
    var chosenTitleID: UUID?
    
    var chosenMyTitle = String()
    var chosenMyTitleID: UUID?
    var imageArray = [Data]()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        navigationController?.navigationBar.isHidden = true
        
        write()
        getData()

    }
    
    func getData () {
        if !chosenMyTitle.isEmpty {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ilan")
            let idString = chosenMyTitleID?.uuidString
            fetchRequest.predicate = NSPredicate(format: "ilanid = %@", idString!)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let title = result.value(forKey: "ilantitle") as? String {
                            titleLabel.text = title
                        }
                        if let price = result.value(forKey: "ilanprice") as? Int {
                            priceLabel.text = "$\(price)"
                        }
                        if let description = result.value(forKey: "ilandescription") as? String {
                            descriptionLabel.text = description
                        }
                        if let image1 = result.value(forKey: "ilanimage1") as? Data, let image2 = result.value(forKey: "ilanimage2") as? Data, let image3 = result.value(forKey: "ilanimage3") as? Data {
                            self.imageArray.append(image1)
                            self.imageArray.append(image2)
                            self.imageArray.append(image3)
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func write() {
        titleLabel.text = products?.title
        
        guard let price = products?.price else { return }
        priceLabel.text = "$\(String(price))"

        descriptionLabel.text = products?.description

        guard let rating = products?.rating else { return }
        rateLabel.text = String(rating)

        guard let discountPercentage = products?.discountPercentage else { return }
        let count = Int(discountPercentage * 100)
        countLabel.text = String(count)
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let searchVC = storyboard?.instantiateViewController(identifier: "toSearchVC") as! SearchVC
        navigationController?.pushViewController(searchVC, animated: true)
    }

    @IBAction func likedButton(_ sender: Any) {
        if likeBtn.tag == 0 {
            likeBtn.setImage(UIImage(named: "heartdolu"), for: .normal)
            likeBtn.tag = 1
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newFavoriteProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: context)
            
            newFavoriteProduct.setValue(products?.title, forKey: "title")
            newFavoriteProduct.setValue(products?.price, forKey: "price")
            newFavoriteProduct.setValue(products?.rating, forKey: "rating")
            newFavoriteProduct.setValue(products?.description, forKey: "overview")
            newFavoriteProduct.setValue(products?.discountPercentage, forKey: "discountPercentage")
            let indexPath = collectionView.indexPathsForVisibleItems.first
            let image = products?.images[indexPath?.row ?? 0]
            newFavoriteProduct.setValue(image, forKey: "image")
            newFavoriteProduct.setValue(products?.thumbnail, forKey: "thumbnail")
            newFavoriteProduct.setValue(UUID(), forKey: "id")
            
            do {
                try context.save()
                print("kayıt başarılı")
            } catch {
                print(error.localizedDescription)
            }
            NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        } else {
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
    
    @IBAction func sepeteEkleButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newFavoriteProduct = NSEntityDescription.insertNewObject(forEntityName: "Basket", into: context)
        
        newFavoriteProduct.setValue(products?.title, forKey: "titlebasket")
        newFavoriteProduct.setValue(products?.price, forKey: "pricebasket")
        newFavoriteProduct.setValue(products?.thumbnail, forKey: "imagebasket")
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
        if !(products?.images.isEmpty ?? true) {
            if products?.images.count ?? 0 > 1 {
                return products?.images.count ?? 0
            } else {
                return products?.thumbnail?.count ?? 0
            }
        } else if !imageArray.isEmpty {
            return imageArray.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailsCell", for: indexPath) as! DetailsCollectionViewCell
        
        if !(products?.images.isEmpty ?? true) {
            if products?.images.count ?? 0 > 1 {
                if let imageUrlString = products?.images[indexPath.row], let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
                    let image = UIImage(data: imageData)
                    cell.detailsImageView.image = image
                }
            } else {
                if let imageUrlString = products?.images.first, let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl) {
                    let image = UIImage(data: imageData)
                    cell.detailsImageView.image = image
                }
            }
        } else if !imageArray.isEmpty {
            let imageData = imageArray[indexPath.row]
            let image = UIImage(data: imageData)
            cell.detailsImageView.image = image
        }
        
        return cell
        
    }
    
}
