//
//  TumYemeklerCell.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 4.10.2023.
//

import UIKit
protocol TumYemeklerProtocol {
    func sepeteYemekEkle(indexPath: IndexPath)
}
protocol FavoritesProtocol {
    func addFavorites(indexPath : IndexPath)
    func deleteFavorites(indexPath : IndexPath)
}

class TumYemeklerCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var yemekPriceLabel: UILabel!
    @IBOutlet weak var yemekAdiLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    var selectedButton = false
    var indexPath : IndexPath?
    var tumYemeklerProtocol : TumYemeklerProtocol?
    var favoritesProtocol : FavoritesProtocol?
    
    @IBAction func sepeteEkleButton(_ sender: UIButton) {
        tumYemeklerProtocol?.sepeteYemekEkle(indexPath: indexPath!)
    }
    
    
    @IBAction func addFavoritesButton(_ sender: UIButton) {
        self.selectedButton.toggle()
        if selectedButton {
            favoritesProtocol?.addFavorites(indexPath: indexPath!)
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoritesProtocol?.deleteFavorites(indexPath: indexPath!)
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
    }
    
}
