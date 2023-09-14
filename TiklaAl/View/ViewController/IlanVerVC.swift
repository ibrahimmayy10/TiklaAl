//
//  IlanVerVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 8.09.2023.
//

import UIKit
import CoreData

class IlanVerVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var ilanCollectionView: UICollectionView!
    
    var titleArray = [String]()
    var image1Array = [Data]()
    var priceArray = [Int]()
    var idArray = [UUID]()
    var imageArray = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ilanCollectionView.delegate = self
        ilanCollectionView.dataSource = self
        
        navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        
        getData()
        
    }
    
    @objc func getData() {
        titleArray.removeAll(keepingCapacity: false)
        priceArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Ilan")
        fetchRequest.returnsDistinctResults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "ilantitle") as? String {
                        self.titleArray.append(title)
                    }
                    if let price = result.value(forKey: "ilanprice") as? Int {
                        self.priceArray.append(price)
                    }
                    if let image1 = result.value(forKey: "ilanimage1") as? Data {
                        self.image1Array.append(image1)
                    }
                    if let id = result.value(forKey: "ilanid") as? UUID {
                        idArray.append(id)
                    }
                    self.ilanCollectionView.reloadData()
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func addProductButton(_ sender: Any) {
        let ilanOlusturVC = storyboard?.instantiateViewController(identifier: "toIlanOlusturVC") as! IlanOlusturVC
        navigationController?.pushViewController(ilanOlusturVC, animated: true)
    }
    
    @IBAction func goToHomePageButton(_ sender: Any) {
        let homeVC = storyboard?.instantiateViewController(identifier: "viewController") as! ViewController
        navigationController?.pushViewController(homeVC, animated: false)
    }
    
    @IBAction func goToFavoritePageButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    @IBAction func goToBasketPageButton(_ sender: Any) {
        let basketVC = storyboard?.instantiateViewController(identifier: "toBasketVC") as! BasketVC
        navigationController?.pushViewController(basketVC, animated: false)
    }
    
    @IBAction func goToAccountPageButton(_ sender: Any) {
        let accountVC = storyboard?.instantiateViewController(identifier: "toAccountVC") as! AccountVC
        navigationController?.pushViewController(accountVC, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = ilanCollectionView.dequeueReusableCell(withReuseIdentifier: "ilanCell", for: indexPath) as! IlanCollectionViewCell
    
        let title = titleArray[indexPath.row]
        let price = priceArray[indexPath.row]
        let imageData = image1Array[indexPath.row]
        
        cell.ilanTitleLabel.text = title
        cell.ilanPriceLabel.text = "$\(price)"
        
        let image = UIImage(data: imageData)
        cell.ilanImageView.image = image
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
        detailsVC.chosenMyTitle = titleArray[indexPath.row]
        detailsVC.chosenMyTitleID = idArray[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }

}
