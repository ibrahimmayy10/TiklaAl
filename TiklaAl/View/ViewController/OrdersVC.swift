//
//  OrdersVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 13.09.2023.
//

import UIKit
import CoreData

class OrdersVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var orderTableView: UITableView!
    
    var chosenTitle = String()
    var idArray = [UUID]()
    var titleArray = [String]()
    var imageArray = [String]()
    var priceArray = [Int]()
    
    var orderArray = [Basket]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orderTableView.dataSource = self
        orderTableView.delegate = self
        
        moveDataToOrderVC()
        
    }
    
    func moveDataToOrderVC() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let orderEntity = NSEntityDescription.entity(forEntityName: "Order", in: context)
        
        for (index, id) in idArray.enumerated() {
            if let order = NSManagedObject(entity: orderEntity!, insertInto: context) as? Basket {
                order.titlebasket = titleArray[index]
                order.pricebasket = Int16(priceArray[index])
                order.imagebasket = imageArray[index]
                order.idbasket = id
                
                // Veriyi orderArray'e ekle
                orderArray.append(order)
            }
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = orderTableView.dequeueReusableCell(withIdentifier: "orderCell", for: indexPath) as! OrderTableViewCell
        let order = orderArray[indexPath.row]
        
        cell.orderTitleLabel.text = order.titlebasket
        cell.orderPriceLabel.text = "$\(order.pricebasket)"
        
        if let imageUrl = URL(string: order.imagebasket ?? ""), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.orderImageView.image = image
        }
        
        return cell
    }
    
}
