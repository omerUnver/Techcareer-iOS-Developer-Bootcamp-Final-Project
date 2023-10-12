//
//  SepetimCell.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 5.10.2023.
//

import UIKit

protocol SepetimProtocol {
    func sepettenSil(indexPath : IndexPath)
}

class SepetimCell: UITableViewCell {

    @IBOutlet weak var siparisName: UILabel!
    
    @IBOutlet weak var totalFiyatLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    var indexPath : IndexPath?
    var sepetimProtocol : SepetimProtocol?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func silButton(_ sender: Any) {
        sepetimProtocol?.sepettenSil(indexPath: indexPath!)
    }
    
}
