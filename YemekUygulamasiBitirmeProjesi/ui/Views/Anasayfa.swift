//
//  ViewController.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 4.10.2023.
//

import UIKit
import RxSwift
import Kingfisher
import CoreData
import FirebaseAuth

let appDelegate = UIApplication.shared.delegate as! AppDelegate
class Anasayfa: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControlOutlet: UISegmentedControl!
    var anasayfaViewModel = AnasayfaViewModel()
    var yemeklerListesi = [Yemekler]()
    var favoriYemeklerListesi = [Favori]()
    var sepeteEkleViewModel = SepeteEkleViewModel()
    var filteredData : [Yemekler] = []
    let context = appDelegate.persistentContainer.viewContext
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        _ = anasayfaViewModel.yemeklerListesi.subscribe(onNext: {[self] yemeklerListe in
            yemeklerListesi = yemeklerListe
            filteredData = yemeklerListe
            do {
                favoriYemeklerListesi = try context.fetch(Favori.fetchRequest())
                collectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
            collectionView.reloadData()
        })
        anasayfaViewModel.yemekleriYukle()
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 10
        
        let genislik = UIScreen.main.bounds.width
        let itemGenislik = (genislik - 30) / 2
        collectionViewLayout.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.6)
        collectionView.collectionViewLayout = collectionViewLayout
        
    }
    override func viewWillAppear(_ animated: Bool) {
        do {
            favoriYemeklerListesi = try context.fetch(Favori.fetchRequest())
            collectionView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
        collectionView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "yemeklerDetails" {
            if let yemek = sender as? Yemekler {
                let gidilecekVC = segue.destination as! SepeteEkle
                gidilecekVC.yemekler = yemek
            }
        }
    }
    
    
    @IBAction func segmentedControlButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            filteredData = yemeklerListesi
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case 1 :
            filteredData = yemeklerListesi.filter { yemek in
                return ["Izgara Somon", "Izgara Tavuk", "Köfte", "Lazanya","Makarna", "Pizza"].contains(yemek.yemek_adi)
                
            }
        case 2:
            filteredData = yemeklerListesi.filter { tatli in
                return ["Baklava", "Kafayıf", "Sütlaç", "Tiramisu"].contains(tatli.yemek_adi)
            }
        case 3 :
            filteredData = yemeklerListesi.filter{ icecekler in
                return ["Ayran", "Fanta", "Kahve", "Su"].contains(icecekler.yemek_adi)
                
            }
        default:
            print("Secilen Yemk yok")
        }
        collectionView.reloadData()
        
        
        
    }
    
    @IBAction func cikisYap(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            print("Çıkış yapıldı.")
        }catch{
            print("Error")
        }
        
    }
    
}

extension Anasayfa : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TumYemeklerCell", for: indexPath) as! TumYemeklerCell
        let yemekler = filteredData[indexPath.row]
        if let yemekResimUrl = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemekler.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.imageView.kf.setImage(with: yemekResimUrl)
            }
        }
        cell.yemekAdiLabel.text = yemekler.yemek_adi
        cell.yemekPriceLabel.text = "\(yemekler.yemek_fiyat) ₺"
        
        cell.indexPath = indexPath
        cell.tumYemeklerProtocol = self
        cell.favoritesProtocol = self
        cell.layer.borderWidth = 0.3
        cell.layer.cornerRadius = 10
       let favorideOlanYemek = self.favoriYemeklerListesi.first(where: {$0.yemek_id == yemekler.yemek_id})
        if favorideOlanYemek != nil {
            cell.selectedButton = true
            cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.selectedButton = false
            cell.favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let yemek = filteredData[indexPath.row]
        performSegue(withIdentifier: "yemeklerDetails", sender: yemek)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    
}

extension Anasayfa : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = []
        if searchText == ""{
            filteredData = yemeklerListesi
        } else {
            for yemek in yemeklerListesi {
                if let yemekAdi = yemek.yemek_adi, yemekAdi.lowercased().contains(searchText.lowercased()) {
                    filteredData.append(yemek)
                }
            }

        }

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
}

extension Anasayfa : TumYemeklerProtocol {
    
    func sepeteYemekEkle(indexPath: IndexPath) {
        let yemeklerListe = yemeklerListesi[indexPath.row]
        if Auth.auth().currentUser != nil {
                sepeteEkleViewModel.sepeteYemekEkle(yemek_adi: yemeklerListe.yemek_adi!, yemek_resim_adi: yemeklerListe.yemek_resim_adi!, yemek_fiyat: Int(yemeklerListe.yemek_fiyat)!, yemek_siparis_adet: 1, kullanici_adi: "Omer Unver")
                    let eklendiAlert = UIAlertController(title: "Uyarı!", message: "Sepetinize Ürün Eklendi Lütfen Sepetini kontrol ediniz.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Tamam", style: .default)
                    eklendiAlert.addAction(okButton)
                    self.present(eklendiAlert, animated: true)
            
        } else {
            self.performSegue(withIdentifier: "homePageAndLoginPageSegue", sender: nil)
        }
    }
    
    
}

extension Anasayfa : FavoritesProtocol {
    func deleteFavorites(indexPath: IndexPath) {
        do {
            favoriYemeklerListesi = try context.fetch(Favori.fetchRequest())
            collectionView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
        let favoriYemek = filteredData[indexPath.row]
        let silinecekYemek = favoriYemeklerListesi.first(where: {$0.yemek_id == favoriYemek.yemek_id})
        self.context.delete(silinecekYemek!)
        appDelegate.saveContex()
        print("Yemek Silindi")
    }
    
    func addFavorites(indexPath: IndexPath) {
        let yemek = filteredData[indexPath.row]
        let favoriYemekler = Favori(context:context)
        favoriYemekler.yemek_id = yemek.yemek_id
        appDelegate.saveContex()
        print("Veri eklendi")
        
    }
}
