//
//  CategoryVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 13.09.2023.
//

import UIKit

class CategoryVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryTableView: UITableView!
    
    var categories = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        categories = ["Telefon", "Laptop", "Parfüm", "Cilt Bakımı", "Ev Dekorasyonu", "Tişört", "Elbise", "Ayakkabı", "Gömlek", "Saat", "Çanta", "Gözlük", "Araba", "Motosiklet"]

    }

    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = categories[indexPath.row]
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ilanOlusturVC = storyboard?.instantiateViewController(identifier: "toIlanOlusturVC") as! IlanOlusturVC
        ilanOlusturVC.chosenCategory = categories[indexPath.row]
        navigationController?.pushViewController(ilanOlusturVC, animated: true)
    }
    
}
