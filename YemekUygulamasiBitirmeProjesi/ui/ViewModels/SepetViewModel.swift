//
//  SepetViewModel.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 4.10.2023.
//

import Foundation
import RxSwift
class SepetViewModel {
    var yemeklerDaoRepository = YemeklerDaoRepository()
    var sepetListe = BehaviorSubject<[Sepet]>(value: [Sepet]())
    
    init(){
        sepetListe = yemeklerDaoRepository.sepetListesi
       
    }
    
    func yemekSil(sepet_yemek_id : Int, kullanici_adi : String){
        yemeklerDaoRepository.yemekSil(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
        sepetYemekler(kullanici_adi: "Omer Unver")
    }
    
    func sepetYemekler(kullanici_adi : String){
        yemeklerDaoRepository.sepettekiYemekler(kullanici_adi: kullanici_adi)
        
    }
    
    
    
}

