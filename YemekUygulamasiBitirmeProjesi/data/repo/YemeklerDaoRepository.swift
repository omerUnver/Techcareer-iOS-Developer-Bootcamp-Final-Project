//
//  YemeklerDaoRepository.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 4.10.2023.
//

import Foundation
import Alamofire
import RxSwift

class YemeklerDaoRepository {
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var sepetListesi = BehaviorSubject<[Sepet]>(value: [Sepet]())
    
    func yemekKaydet(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat : Int, yemek_siparis_adet: Int, kullanici_adi: String ){
        let params : Parameters = ["yemek_adi": yemek_adi, "yemek_resim_adi": yemek_resim_adi, "yemek_fiyat" : yemek_fiyat, "yemek_siparis_adet" : yemek_siparis_adet, "kullanici_adi" : kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php",
                   method: .post,
                   parameters: params)
                  .response { result in
            if let data = result.data {
                do {
                    let AFResult = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("-----------Yemek Eklendi------------")
                    print("success : \(AFResult.success!)")
                    print("message : \(AFResult.message!)")
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    
    
    func yemekSil(sepet_yemek_id: Int, kullanici_adi: String){
        let params : Parameters = ["sepet_yemek_id": sepet_yemek_id, "kullanici_adi" : kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php"
                   , method: .post,
                   parameters: params).response { result in
            if let data = result.data {
                do {
                    let AFResult = try JSONDecoder().decode(CRUDCevap.self, from: data)
                    print("-----------Yemek Silindi------------")
                    print("success : \(AFResult.success!)")
                    print("message : \(AFResult.message!)")
                } catch {
                    print("Yemek Silinemedi")
                    print(error.localizedDescription)
                }
            }
            
        }
        
        
    }
    
    func yemekleriYukle(){
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php",
                   method: .get)
                  .response { result in
                      
            if let data = result.data {
                do {
                    let AFResult = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                    if let yemeklerListe = AFResult.yemekler {
                        self.yemeklerListesi.onNext(yemeklerListe)
                        
                    }
//                    let rawResponse = try JSONSerialization.jsonObject(with: data)
//                    print(rawResponse)
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
    func sepettekiYemekler(kullanici_adi : String){
        let params : Parameters = ["kullanici_adi" : kullanici_adi]
                   AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php",
                   method: .post,
                   parameters: params).response { result in
                       if let data = result.data {
                           do {
                               let AFResult = try JSONDecoder().decode(SepetYemekler.self, from: data)
                               if let sepetListe = AFResult.sepet_yemekler {
                                   self.sepetListesi.onNext(sepetListe)
                               }
                                let rawResponse = try JSONSerialization.jsonObject(with: data)
                                print(rawResponse)
                               
                               
                           } catch {
                               print(error.localizedDescription)
                               self.sepetListesi.onNext([])
                           }
                       }
            
        }
    }
        
    
}
