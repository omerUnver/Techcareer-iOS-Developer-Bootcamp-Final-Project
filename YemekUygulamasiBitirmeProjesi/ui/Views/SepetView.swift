//
//  SepetView.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 4.10.2023.
//

import UIKit
import RxSwift
import Kingfisher
import FirebaseAuth
class SepetView: UIViewController {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var sepetViewModel = SepetViewModel()
    var sepetListe = [Sepet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = 150
        
        _ = sepetViewModel.sepetListe.subscribe(onNext: { sepetListe in
            self.sepetListe = sepetListe
            var sepetToplamFiyat = 0
            for sepetYemek in sepetListe {
                let siparisAdet = Int(sepetYemek.yemek_siparis_adet!)
                let yemekFiyat =  Int(sepetYemek.yemek_fiyat!)
                sepetToplamFiyat += siparisAdet! * yemekFiyat!
            }
            self.totalPriceLabel.text = "\(sepetToplamFiyat) ₺"
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
            
        })
        self.navigationController?.navigationBar.tintColor = UIColor.systemRed
        
        
        self.sepetViewModel.sepetYemekler(kullanici_adi: "Omer Unver")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.sepetViewModel.sepetYemekler(kullanici_adi: "Omer Unver")
    }
    
    @IBAction func kullaniciCikisYapButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            if let userEmail = Auth.auth().currentUser?.email {
                let alert = UIAlertController(title: "Kullanıcı Çıkış Yapmak İstiyor", message: "\(userEmail) Çıkış Yapıyor", preferredStyle: .alert)
                    let cikisYapButton = UIAlertAction(title: "Çıkış Yap", style: .destructive) { action in
                        do {
                            try Auth.auth().signOut()
                        } catch {
                            print(error.localizedDescription)
                        }
                        
                    }
                    let iptalButton = UIAlertAction(title: "İptal", style: .cancel)
                    alert.addAction(iptalButton)
                    alert.addAction(cikisYapButton)
                    self.present(alert, animated: true)
            }

        } else {
            let alert = UIAlertController(title: "Oturum Açılmamış", message: "Kullanıcı Oturumu Bulunamadı", preferredStyle: .alert)
            let tamamButton = UIAlertAction(title: "Tamam", style: .default)
            alert.addAction(tamamButton)
            self.present(alert, animated: true)
        }
        
        
        
    }
    
    @IBAction func odemeButton(_ sender: Any) {
        if !sepetListe.isEmpty {
            let alert = UIAlertController(title: "Siparişiniz Alındı", message: "Siparişiniz Alındı, Ödemeniz Onaylandı", preferredStyle: .alert)
            let tamamButton = UIAlertAction(title: "Tamam", style: .default)
            alert.addAction(tamamButton)
            self.present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Sepetiniz Boş", message: "Lütfen Yemek Ekleyin", preferredStyle: .alert)
            let tamamButton = UIAlertAction(title: "Tamam", style: .default)
            alert.addAction(tamamButton)
            self.present(alert, animated: true)
        }
    }
    
}

extension SepetView : UITableViewDelegate, UITableViewDataSource, SepetimProtocol {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sepetimCell") as! SepetimCell
        let sepet = sepetListe[indexPath.row]
        var yemekToplamFiyat = 0
        let siparisAdet = Int(sepet.yemek_siparis_adet!)
        let yemekFiyat =  Int(sepet.yemek_fiyat!)
        yemekToplamFiyat = siparisAdet! * yemekFiyat!
        cell.adetLabel.text = "Adet : \(sepet.yemek_siparis_adet!)"
        cell.fiyatLabel.text = "Fiyat : \(sepet.yemek_fiyat!) ₺"
        cell.siparisName.text = sepet.yemek_adi!
        cell.totalFiyatLabel.text = "Toplam : \(yemekToplamFiyat) ₺"
        if let sepetResimUrl = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(sepet.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.cellImageView.kf.setImage(with: sepetResimUrl)
            }
        }
        cell.indexPath = indexPath
        cell.sepetimProtocol = self
        cell.layer.borderWidth = 5
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetListe.count
    }
    
    
    
    func sepettenSil(indexPath: IndexPath) {
        let sepet = sepetListe[indexPath.row]
        self.sepetViewModel.yemekSil(sepet_yemek_id: Int(sepet.sepet_yemek_id!)!, kullanici_adi: "Omer Unver")
        self.tableView.reloadData()
        
    }
    
}
