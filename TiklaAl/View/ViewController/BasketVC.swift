//
//  BasketVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 8.09.2023.
//

import UIKit
import CoreData

class BasketVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toplamPriceLabel: UILabel!
    
    var products: Products?
    
    var titleArray = [String]()
    var imageArray = [String]()
    var priceArray = [Int]()
    var idArray = [UUID]()
    var chosenTitle = ""
    var chosenID: [UUID]?
    
    var adet = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
        
        getData()
        NotificationCenter.default.addObserver(self, selector: #selector(adetDegisti(notification:)), name: NSNotification.Name(rawValue: "adetDegisti"), object: nil)
        updateTotalPrice()
        
    }
    
    @objc func adetDegisti(notification: Notification) {
        updateTotalPrice()
    }
    
    func updateTotalPrice() {
        if titleArray.isEmpty {
            toplamPriceLabel.text = "Sepetiniz Boş"
        } else {
            var totalPrice = 0

            for (row, cell) in tableView.visibleCells.enumerated() {
                if let basketCell = cell as? BasketTableViewCell {
                    let adetText = basketCell.adetLabel.text ?? "0"
                    if let adet = Int(adetText), adet > 0 {
                        let price = priceArray[row]
                        let productTotalPrice = adet * price
                        totalPrice += productTotalPrice
                    }
                }
            }
            toplamPriceLabel.text = "$\(String(totalPrice))"
        }

    }
    
    @objc func getData() {
        titleArray.removeAll(keepingCapacity: false)
        priceArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Basket")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let title = result.value(forKey: "titlebasket") as? String {
                        self.titleArray.append(title)
                    }
                    if let price = result.value(forKey: "pricebasket") as? Int {
                        self.priceArray.append(price)
                    }
                    if let image = result.value(forKey: "imagebasket") as? String {
                        self.imageArray.append(image)
                    }
                    if let id = result.value(forKey: "idbasket") as? UUID {
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
    
    @IBAction func goToFavoritePageButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    @IBAction func goToIlanVerPageButton(_ sender: Any) {
        let ilanVerVC = storyboard?.instantiateViewController(identifier: "toIlanVerVC") as! IlanVerVC
        navigationController?.pushViewController(ilanVerVC, animated: false)
    }
    
    @IBAction func goToAccountPageButton(_ sender: Any) {
        let accountVC = storyboard?.instantiateViewController(identifier: "toAccountVC") as! AccountVC
        navigationController?.pushViewController(accountVC, animated: false)
    }
    
    func sepetiOnayla() {
//        moveDataToOrderVC()
        
        titleArray.removeAll()
        priceArray.removeAll()
        imageArray.removeAll()
        idArray.removeAll()
        
        clearBasketData()
        getData()
        tableView.reloadData()
    }

    
    @IBAction func sepetiOnaylaButton(_ sender: Any) {
        let alert = UIAlertController(title: "Sepetiniz Onaylandı", message: "Alışverişe devam et", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hayır", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Evet", style: .cancel, handler: { action in
            self.sepetiOnayla()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func moveDataToOrderVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let orderEntity = NSEntityDescription.entity(forEntityName: "Basket", in: context)
        
        for (index, id) in idArray.enumerated() {
            if let order = NSManagedObject(entity: orderEntity!, insertInto: context) as? Basket {
                order.titlebasket = titleArray[index]
                order.pricebasket = Int16(priceArray[index])
                order.imagebasket = imageArray[index]
                order.idbasket = id
            }
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func clearBasketData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Basket")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                context.delete(result)
            }
            
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basketCell", for: indexPath) as! BasketTableViewCell
        
        let title = titleArray[indexPath.row]
        let price = priceArray[indexPath.row]
        let imageUrl = imageArray[indexPath.row]
        
        cell.basketTitleLabel.text = title
        cell.basketPriceLabel.text = "$\(String(price))"
        cell.adetLabel.text = String(cell.quantity)
        
        if let imageUrl = URL(string: imageUrl), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.basketImageView.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 208
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Basket")
            fetchRequest.returnsObjectsAsFaults = false
            let idString = idArray[indexPath.row].uuidString
            fetchRequest.predicate = NSPredicate(format: "idbasket = %@", idString)
            
            do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "idbasket") as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                titleArray.remove(at: indexPath.row)
                                priceArray.remove(at: indexPath.row)
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
