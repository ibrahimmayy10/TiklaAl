//
//  IlanOlusturVC.swift
//  TiklaAl
//
//  Created by İbrahim Ay on 12.09.2023.
//

import UIKit
import CoreData

class IlanOlusturVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextLabel: UITextField!
    @IBOutlet weak var priceTextLabel: UITextField!
    
    var selectedImageView: UIImageView?
    
    var chosenCategory = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        imageView1.isUserInteractionEnabled = true
        let image1TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView1.addGestureRecognizer(image1TapRecognizer)

        imageView2.isUserInteractionEnabled = true
        let image2TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView2.addGestureRecognizer(image2TapRecognizer)

        imageView3.isUserInteractionEnabled = true
        let image3TapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView3.addGestureRecognizer(image3TapRecognizer)
        
        categoryLabel.text = "     \(chosenCategory)"
        
    }
    
    @objc func selectImage(_ sender: UITapGestureRecognizer) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary

        if sender.view == imageView1 {
            selectedImageView = imageView1
        } else if sender.view == imageView2 {
            selectedImageView = imageView2
        } else if sender.view == imageView3 {
            selectedImageView = imageView3
        }

        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage ?? info[.originalImage] as? UIImage {
            selectedImageView?.image = selectedImage
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func selectCategoryButton(_ sender: Any) {
        let categoryVC = storyboard?.instantiateViewController(identifier: "toCategoryVC") as! CategoryVC
        navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        let alert = UIAlertController(title: "İptal Et", message: "İptal ettiğinizde seçimleriniz kaybolacak", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel))
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    @IBAction func loadButton(_ sender: Any) {
        
        var title = titleTextField.text
        var description = descriptionTextLabel.text
        var price = Int(priceTextLabel.text ?? "")
        var image1 = imageView1.image?.pngData()
        var image2 = imageView2.image?.pngData()
        var image3 = imageView3.image?.pngData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Ilan", into: context)
        
        newProduct.setValue(title, forKey: "ilantitle")
        newProduct.setValue(description, forKey: "ilandescription")
        newProduct.setValue(chosenCategory, forKey: "ilancategory")
        newProduct.setValue(price, forKey: "ilanprice")
        newProduct.setValue(image1, forKey: "ilanimage1")
        newProduct.setValue(image2, forKey: "ilanimage2")
        newProduct.setValue(image3, forKey: "ilanimage3")
        newProduct.setValue(UUID(), forKey: "ilanid")
        
        do {
            try context.save()
            print("başarılı kayıt")
        } catch {
            print(error.localizedDescription)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
        let ilanVerVC = storyboard?.instantiateViewController(identifier: "toIlanVerVC") as! IlanVerVC
        self.navigationController?.pushViewController(ilanVerVC, animated: true)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
        let alert = UIAlertController(title: "İptal Et", message: "İptal ettiğinizde seçimleriniz kaybolacak", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel))
        alert.addAction(UIAlertAction(title: "Evet", style: .destructive, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
}
