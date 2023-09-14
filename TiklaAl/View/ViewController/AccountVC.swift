//
//  AccountVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 8.09.2023.
//

import UIKit

class AccountVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
    }
    
    @IBAction func ordersButton(_ sender: Any) {
        let orderVC = storyboard?.instantiateViewController(identifier: "toOrderVC") as! OrdersVC
        navigationController?.pushViewController(orderVC, animated: true)
    }
    
    @IBAction func sellButton(_ sender: Any) {
        let ilanVerVC = storyboard?.instantiateViewController(identifier: "toIlanVerVC") as! IlanVerVC
        navigationController?.pushViewController(ilanVerVC, animated: false)
    }
    
    @IBAction func favoriteButton(_ sender: Any) {
        let favoriteVC = storyboard?.instantiateViewController(identifier: "toFavoriteVC") as! FavoriteVC
        navigationController?.pushViewController(favoriteVC, animated: false)
    }
    
    @IBAction func basketButton(_ sender: Any) {
        let basketVC = storyboard?.instantiateViewController(identifier: "toBasketVC") as! BasketVC
        navigationController?.pushViewController(basketVC, animated: false)
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
    
    @IBAction func goToBasketPageButton(_ sender: Any) {
        let basketVC = storyboard?.instantiateViewController(identifier: "toBasketVC") as! BasketVC
        navigationController?.pushViewController(basketVC, animated: false)
    }

}
