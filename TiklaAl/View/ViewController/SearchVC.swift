//
//  SearchVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 9.09.2023.
//

import UIKit

class SearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var products = [Products]()
    var searchCategory = String()
    var chosenCategory = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchCollectionView.dataSource = self
        searchCollectionView.delegate = self

        navigationController?.navigationBar.isHidden = true
        
        searchCategories()
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        searchCategory = searchTextField.text!
        let url = "https://dummyjson.com/products/category/\(searchCategory)"
        guard let url = URL(string: url) else { return }
        
        Webservices().searchCategory(url: url) { result in
            switch result {
            case .success(let product):
                if let product = product {
                    self.products = product
                    DispatchQueue.main.async {
                        self.searchCollectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchCategories () {
        let url = "https://dummyjson.com/products/category/\(chosenCategory)"
        guard let url = URL(string: url) else { return }
        
        Webservices().searchCategory(url: url) { result in
            switch result {
            case .success(let product):
                if let product = product {
                    self.products = product
                    DispatchQueue.main.async {
                        self.searchCollectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        let product = products[indexPath.row]
        cell.searchTitleLabel.text = product.title
        cell.searchPrice.text = "$\(String(product.price))"
        cell.searchRatingLabel.text = String(product.rating)
        
        if let imageUrl = URL(string: product.thumbnail ?? ""), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.searchImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItemProduct = products[indexPath.row]
        
        let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
        detailsVC.products = selectedItemProduct
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
