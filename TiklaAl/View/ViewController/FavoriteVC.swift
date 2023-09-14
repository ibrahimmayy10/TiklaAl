//
//  FavoriteVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 8.09.2023.
//

import UIKit
import CoreData

class FavoriteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var imageArray = [String]()
    var priceArray = [Int]()
    var ratingArray = [Double]()
    var countArray = [Double]()
    var descriptionArray = [String]()
    var idArray = [UUID]()
    var thumbnailArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        
        getData()
                
    }
    
    @objc func getData () {
        titleArray.removeAll(keepingCapacity: false)
        priceArray.removeAll(keepingCapacity: false)
        ratingArray.removeAll(keepingCapacity: false)
        countArray.removeAll(keepingCapacity: false)
        descriptionArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "title") as? String {
                        self.titleArray.append(title)
                    }
                    if let price = result.value(forKey: "price") as? Int {
                        self.priceArray.append(price)
                    }
                    if let rating = result.value(forKey: "rating") as? Double {
                        self.ratingArray.append(rating)
                    }
                    if let count = result.value(forKey: "discountPercentage") as? Double {
                        self.countArray.append(count)
                    }
                    if let description = result.value(forKey: "overview") as? String {
                        self.descriptionArray.append(description)
                    }
                    if let image = result.value(forKey: "image") as? String {
                        self.imageArray.append(image)
                    }
                    if let thumbnail = result.value(forKey: "thumbnail") as? String {
                        self.thumbnailArray.append(thumbnail)
                    }
                    if let id = result.value(forKey: "id") as? UUID {
                        idArray.append(id)
                    }
                    tableView.reloadData()
                    print("geldi")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func goToHomePageButton(_ sender: Any) {
        let homeVC = storyboard?.instantiateViewController(identifier: "viewController") as! ViewController
        navigationController?.pushViewController(homeVC, animated: false)
    }
    
    @IBAction func goToIlanVerPageButton(_ sender: Any) {
        let ilanVerVC = storyboard?.instantiateViewController(identifier: "toIlanVerVC") as! IlanVerVC
        navigationController?.pushViewController(ilanVerVC, animated: false)
    }
    
    @IBAction func goToBasketPageButton(_ sender: Any) {
        let basketVC = storyboard?.instantiateViewController(identifier: "toBasketVC") as! BasketVC
        navigationController?.pushViewController(basketVC, animated: false)
    }
    
    @IBAction func goToAccountPageButton(_ sender: Any) {
        let accountVC = storyboard?.instantiateViewController(identifier: "toAccountVC") as! AccountVC
        navigationController?.pushViewController(accountVC, animated: false)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! FavoriteTableViewCell
        
        let title = titleArray[indexPath.row]
        let price = priceArray[indexPath.row]
        let count = countArray[indexPath.row]
        let rating = ratingArray[indexPath.row]
        let imageUrl = imageArray[indexPath.row]
        
        cell.favoriteTitleLabel.text = title
        cell.favoritePriceLabel.text = "$\(String(price))"
        cell.favoriteCountLabel.text = String(count)
        cell.favoriteRatingLabel.text = String(rating)
        
        if let imageUrl = URL(string: imageUrl), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.favoriteImageView.image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coreDataVC = storyboard?.instantiateViewController(identifier: "toCoreDataVC") as! CoreDataDetailsVC
        coreDataVC.chosenTitle = titleArray[indexPath.row]
        coreDataVC.chosenTitleID = idArray[indexPath.row]
        navigationController?.pushViewController(coreDataVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 245
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
            fetchRequest.returnsObjectsAsFaults = false
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                titleArray.remove(at: indexPath.row)
                                ratingArray.remove(at: indexPath.row)
                                countArray.remove(at: indexPath.row)
                                descriptionArray.remove(at: indexPath.row)
                                priceArray.remove(at: indexPath.row)
                                thumbnailArray.remove(at: indexPath.row)
                                imageArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                
                                do {
                                    try context.save()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }

}
