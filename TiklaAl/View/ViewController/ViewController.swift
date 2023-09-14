//
//  ViewController.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 6.09.2023.
//

import UIKit

var categories = [
    Category(text: "T-shirt", imageName: "tshirt", category: "mens-shirts"),
    Category(text: "Ayakkabı", imageName: "ayakkabi", category: "mens-shoes"),
    Category(text: "Telefon", imageName: "electronics", category: "smartphones"),
    Category(text: "Elbise", imageName: "elbise", category: "womens-dresses"),
    Category(text: "Takı & Mücevher", imageName: "jewellery", category: "womens-jewellery"),
    Category(text: "Güneş Gözlüğü", imageName: "gozluk", category: "sunglasses")
]

var design = [
    Design(image: "apple"),
    Design(image: "pullbear"),
    Design(image: "xiaomi"),
    Design(image: "nike"),
    Design(image: "adidas")
]

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var ozelCollectionView: UICollectionView!
    @IBOutlet weak var designCollectionView: UICollectionView!
    
    var productsViewModel = ProductsViewModel()
    var products = [Products]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        ozelCollectionView.dataSource = self
        ozelCollectionView.delegate = self
        
        designCollectionView.dataSource = self
        designCollectionView.delegate = self
        
        designCollectionView.isPagingEnabled = false
        let timer = Timer(timeInterval: 3.0, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .common)
        
        productsViewModel.downloadProducts {
            DispatchQueue.main.async {
                self.categoryCollectionView.reloadData()
                self.ozelCollectionView.reloadData()
                self.designCollectionView.reloadData()
            }
        }
        getData()
    }
    
    func getData() {
        let url = "https://dummyjson.com/products/category/laptops"
        guard let url = URL(string: url) else { return }
        
        Webservices().searchCategory(url: url) { result in
            switch result {
            case .success(let product):
                if let product = product {
                    self.products = product
                    DispatchQueue.main.async {
                        self.ozelCollectionView.reloadData()
                    }
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func autoScroll () {
        if let indexPath = designCollectionView.indexPathsForVisibleItems.first {
            var nextIndex = indexPath.item + 1
            if nextIndex >= design.count {
                nextIndex = 0
            }
            let nextIndexPath = IndexPath(item: nextIndex, section: 0)
            designCollectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    @IBAction func goToAllProductsPageButton(_ sender: Any) {
        let allVC = storyboard?.instantiateViewController(identifier: "toAllVC") as! AllProductsVC
        navigationController?.pushViewController(allVC, animated: true)
    }
    
    @IBAction func goToSearchPageButton(_ sender: Any) {
        let searchVC = storyboard?.instantiateViewController(identifier: "toSearchVC") as! SearchVC
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @IBAction func goToFavoritePageButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categories.count
        } else if collectionView == ozelCollectionView {
            return products.count
        } else if collectionView == designCollectionView {
            return design.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == categoryCollectionView {
            
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CategoryCollectionViewCell
            let category = categories[indexPath.item]
            cell.categoryImageView.image = UIImage(named: category.imageName)
            cell.categoryLabel.text = category.text
            return cell
            
        } else if collectionView == ozelCollectionView {
            
            let cell = ozelCollectionView.dequeueReusableCell(withReuseIdentifier: "ozelCell", for: indexPath) as! OzelCollectionViewCell
            let products = products[indexPath.row]
            
            if let imageURL = URL(string: products.thumbnail ?? ""), let imageData = try? Data(contentsOf: imageURL) {
                let image = UIImage(data: imageData)
                cell.ozelImageView.image = image
            }
            
            cell.ozelTitleLabel.text = products.title
            cell.ozelPriceLabel.text = "$\(products.price)"
            return cell
            
        } else if collectionView == designCollectionView {
            
            let cell = designCollectionView.dequeueReusableCell(withReuseIdentifier: "designCell", for: indexPath) as! DesignCollectionViewCell
            let design = design[indexPath.item]
            cell.designImageView.image = UIImage(named: design.image)
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == ozelCollectionView {
            let selectedPopularItem = products[indexPath.row]
            if let detailsVC = storyboard?.instantiateViewController(withIdentifier: "toDetailsVC") as? DetailsVC {
                detailsVC.products = selectedPopularItem
                navigationController?.pushViewController(detailsVC, animated: true)
            }
        } else if collectionView == categoryCollectionView {
            let selectedCategoryItem = categories[indexPath.item]
            let searchVC = storyboard?.instantiateViewController(identifier: "toSearchVC") as! SearchVC
            searchVC.chosenCategory = selectedCategoryItem.category
            navigationController?.pushViewController(searchVC, animated: true)
        }
    }

}
