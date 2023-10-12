//
//  AnasayfaViewModel.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 4.10.2023.
//

import Foundation
import RxSwift
class AnasayfaViewModel {
    
    var yemeklerDaoRepository = YemeklerDaoRepository()
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    init(){
        yemeklerListesi = yemeklerDaoRepository.yemeklerListesi
    }
    
    
    func yemekleriYukle(){
        yemeklerDaoRepository.yemekleriYukle()
    }
    
    
}
