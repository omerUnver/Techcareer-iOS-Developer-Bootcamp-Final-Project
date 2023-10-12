//
//  FavoritesCell.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 9.10.2023.
//

import UIKit
protocol FavoriteDeleteProtocol {
    func favoriteDelete(indexPath : IndexPath)
}

class FavoritesCell: UICollectionViewCell {
    
    @IBOutlet weak var yemekAdLabel: UILabel!
    @IBOutlet weak var yemekFiyatLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    var indexPath : IndexPath?
    var favoriteDeleteProtocol : FavoriteDeleteProtocol?
    
    @IBAction func deleteFavoriteButton(_ sender: Any) {
        favoriteDeleteProtocol?.favoriteDelete(indexPath: indexPath!)
    }
    
}
