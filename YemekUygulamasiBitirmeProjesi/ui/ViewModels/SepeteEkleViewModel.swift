//
//  SepeteEkleViewModel.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 4.10.2023.
//

import Foundation
import RxSwift
class SepeteEkleViewModel {
    var yemeklerDaoRepo = YemeklerDaoRepository()
    var sepetListe = [Sepet]()
    var sepetViewModel = SepetViewModel()
    init(){
        
        _ = sepetViewModel.sepetListe.subscribe(onNext: { sepetListe in
            self.sepetListe = sepetListe
        })
        self.sepetViewModel.sepetYemekler(kullanici_adi: "Omer Unver")

    }
    
    func sepeteYemekEkle(yemek_adi: String, yemek_resim_adi : String, yemek_fiyat : Int, yemek_siparis_adet : Int, kullanici_adi : String){
     
        let varolanYemek = sepetListe.filter({ $0.yemek_adi == yemek_adi})
        if varolanYemek.isEmpty {
            yemeklerDaoRepo.yemekKaydet(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi)
        } else {
            yemeklerDaoRepo.yemekSil(sepet_yemek_id: Int(varolanYemek[0].sepet_yemek_id!)!, kullanici_adi: "Omer Unver")
            yemeklerDaoRepo.yemekKaydet(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet + Int(varolanYemek[0].yemek_siparis_adet!)!, kullanici_adi: kullanici_adi)
        }
        sepetViewModel.sepetYemekler(kullanici_adi: "Omer Unver")

    }

    
}
