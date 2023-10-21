//
//  FavoritesViewController.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 9.10.2023.
//

import UIKit
import CoreData
import Kingfisher

class FavoritesViewController: UIViewController {
    let context = appDelegate.persistentContainer.viewContext
    @IBOutlet weak var favoriYemeklerLabel: UILabel!
    var favoriYemeklerListesi = [Favori]()
    var yemeklerListesi = [Yemekler]()
    var filteredData : [Yemekler] = []
    var anasayfaViewModel = AnasayfaViewModel()
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = anasayfaViewModel.yemeklerListesi.subscribe(onNext: { [self] yemeklerListe in
            self.yemeklerListesi = yemeklerListe
            self.collectionView.reloadData()
            do { // Core data içersinde bulunan verilerimi favoriYemeklerListesinde bulunan ve değeri Favori Core data modelim olan boş dizime çektim
                favoriYemeklerListesi = try context.fetch(Favori.fetchRequest())
                collectionView.reloadData()
            } catch {
                print(error.localizedDescription)
            }
            self.filteredData.removeAll() // burada diziyi silme sebebim RxSwiftin subscribe metodunun çalıştığında for döngüsü ile sürekli olarak diziye aynı yemeklerin art arta eklenmesini önlemek için
            
            for favoriYemek in favoriYemeklerListesi { // Core data modelimin içerisinde bulunan yemek_id ile API den gelen ve modelim de bulunun yemekler verisi ile eşitledim daha sonra core data modelim ile yemekler verisi modelin içerisinde id eşitlemesi yaparak yeni oluşturduğum boş yemekler dizisine aktardım
                self.filteredData += self.yemeklerListesi.filter({$0.yemek_id == favoriYemek.yemek_id})
            }
        })
        anasayfaViewModel.yemekleriYukle() // Anasayfaya gelen tüm yemekler verilerini favoriler sayfamda yükledim sebebi ise filteredData adında ki dizime gelen verileri kayıt etmek için
        collectionView.dataSource = self
        collectionView.delegate = self
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
        anasayfaViewModel.yemekleriYukle()
        
    }
    
}

extension FavoritesViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        let favoriYemekler = filteredData[indexPath.row]
        cell.yemekAdLabel.text = favoriYemekler.yemek_adi
        cell.yemekFiyatLabel.text = "\(favoriYemekler.yemek_fiyat) ₺"
        
        
        if let yemekResim = favoriYemekler.yemek_resim_adi {
            if let yemekResimUrl = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemekResim)") {
                DispatchQueue.main.async {
                    cell.imageView.kf.setImage(with: yemekResimUrl)
                }
            }
        }
        
        cell.favoriteDeleteProtocol = self
        cell.indexPath = indexPath
        cell.layer.borderWidth = 0.3
        cell.layer.cornerRadius = 10
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredData.count
    }
    
}

extension FavoritesViewController : FavoriteDeleteProtocol {
    func favoriteDelete(indexPath: IndexPath) {
        let favoriYemek = filteredData[indexPath.row]
        let silinecekYemek = favoriYemeklerListesi.first(where: {$0.yemek_id == favoriYemek.yemek_id}) // Core data dan silmek için Favori türünde bir değer vermem gerektiği için bu işlemi yaptım
        self.context.delete(silinecekYemek!)
        appDelegate.saveContex()
        
        filteredData.remove(at: indexPath.row) // Core datan veri silindikten filteredData içerisinde de sildim o veriyi
        self.collectionView.reloadData()
        print("Yemek Silindi")
    }
}
