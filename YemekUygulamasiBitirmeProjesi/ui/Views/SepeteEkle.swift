//
//  SepeteEkle.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 4.10.2023.
//

import UIKit
import Kingfisher
import FirebaseAuth
class SepeteEkle: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yemekAdLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var siparisAdetLabel: UILabel!
    @IBOutlet weak var stepperOutlet: UIStepper!
    @IBOutlet weak var yemekPriceLabel: UILabel!
    var isAuthentication = false
    var totalPrice = 0
    var viewModel = SepeteEkleViewModel()
    var yemekler : Yemekler?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let yemek = yemekler {
            if let yemekResimUrl = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") {
                DispatchQueue.main.async {
                    self.imageView.kf.setImage(with: yemekResimUrl)
                }
            }
            self.yemekAdLabel.text = yemek.yemek_adi
            self.priceLabel.text = "0 ₺"
            self.yemekPriceLabel.text = "\(yemek.yemek_fiyat) ₺"
            
            
        }
        self.siparisAdetLabel.text = "0 Adet"
        self.backgroundView.layer.cornerRadius = 20
        
    }
    
    @IBAction func stepperButton(_ sender: UIStepper) {
        let stepperValue = Int(sender.value)
        self.totalPrice = Int(stepperValue) * Int(yemekler!.yemek_fiyat)!
        self.siparisAdetLabel.text = "\(Int(sender.value)) Adet"
        if Int(stepperOutlet.value) == 0 {
            self.siparisAdetLabel.text = "0 Adet"
        }
        self.priceLabel.text = "\(totalPrice) ₺"
        
    }
    
    @IBAction func sepeteEkleButton(_ sender: Any) {
        
        if totalPrice == 0 {
            let alert = UIAlertController(title: "Uyarı!", message: "Lütfen Sepete Ürün ekleyiniz.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "Tamam", style: .default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
        } else {
            if Auth.auth().currentUser != nil {
                if let yemek = yemekler {
                    
                    viewModel.sepeteYemekEkle(yemek_adi: yemek.yemek_adi!, yemek_resim_adi: yemek.yemek_resim_adi!, yemek_fiyat: Int(yemek.yemek_fiyat)!, yemek_siparis_adet: Int(stepperOutlet.value), kullanici_adi: "Omer Unver")
                    let eklendiAlert = UIAlertController(title: "Uyarı!", message: "Sepetinize Ürün Eklendi Lütfen Sepetini kontrol ediniz.", preferredStyle: .alert)
                    let okButton = UIAlertAction(title: "Tamam", style: .default) { action in
                        self.navigationController?.popToRootViewController(animated: true)
                        
                    }
                    eklendiAlert.addAction(okButton)
                    self.present(eklendiAlert, animated: true)
                    
                    
                }
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            
        }
        
        
    }
    
    
}

