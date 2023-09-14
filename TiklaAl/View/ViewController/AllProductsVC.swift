//
//  AllProductsVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 11.09.2023.
//

import UIKit

class AllProductsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var allCollectionView: UICollectionView!
    
    var productsViewModel = ProductsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        allCollectionView.dataSource = self
        allCollectionView.delegate = self
        
        productsViewModel.downloadProducts {
            for products in self.productsViewModel.products {
                print(products.title)
            }
            DispatchQueue.main.async {
                self.allCollectionView.reloadData()
            }
        }
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let searchVC = storyboard?.instantiateViewController(identifier: "toSearchVC") as! SearchVC
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func goToFavoriteButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    @IBAction func goToIlanButton(_ sender: Any) {
        let ilanVerVC = storyboard?.instantiateViewController(identifier: "toIlanVerVC") as! IlanVerVC
        navigationController?.pushViewController(ilanVerVC, animated: false)
    }
    
    @IBAction func goToBasketButton(_ sender: Any) {
        let basketVC = storyboard?.instantiateViewController(identifier: "toBasketVC") as! BasketVC
        navigationController?.pushViewController(basketVC, animated: false)
    }
    
    @IBAction func goToAccountButton(_ sender: Any) {
        let accountVC = storyboard?.instantiateViewController(identifier: "toAccountVC") as! AccountVC
        navigationController?.pushViewController(accountVC, animated: false)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsViewModel.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = allCollectionView.dequeueReusableCell(withReuseIdentifier: "allCell", for: indexPath) as! AllProductsCollectionViewCell
        let product = productsViewModel.products[indexPath.row]
        cell.allTitleLabel.text = product.title
        cell.allPriceLabel.text = "$\(String(product.price))"
        cell.allRatingLabel.text = String(product.rating)
        
        if let imageUrl = URL(string: product.thumbnail ?? ""), let imageData = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: imageData)
            cell.allImageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProductItem = productsViewModel.products[indexPath.row]
        let detailsVC = storyboard?.instantiateViewController(identifier: "toDetailsVC") as! DetailsVC
        detailsVC.products = selectedProductItem
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
