//
//  LogIn-CreateUserViewController.swift
//  YemekUygulamasiBitirmeProjesi
//
//  Created by M.Ömer Ünver on 10.10.2023.
//

import UIKit
import FirebaseAuth
class LogIn_CreateUserViewController: UIViewController {
    @IBOutlet weak var loginModeLabel: UILabel!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var logInButtonLabel: UIButton!
    @IBOutlet weak var segmentedConrollerOutlet: UISegmentedControl!
    var isLoginModel = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loginModeLabel.text = "Giriş Yap"
        let klavyeKapat = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        self.view.addGestureRecognizer(klavyeKapat)
        
    }
    @objc func klavyeKapat(){
        view.endEditing(true)
    }
    
    @IBAction func segmentedControllerAction(_ sender: UISegmentedControl) {
        let segmentedIndex = sender.selectedSegmentIndex
        if segmentedIndex == 0 {
            loginModeLabel.text = "Giriş Yap"
            logInButtonLabel.setTitle("Giriş Yap", for: .normal)
            
        } else {
            loginModeLabel.text = "Hesap Oluştur"
            logInButtonLabel.setTitle("Hesap Oluştur", for: .normal)
        }
    }
    
    @IBAction func logInButton(_ sender: Any) {
        if segmentedConrollerOutlet.selectedSegmentIndex == 0 {
            loginModeLabel.text = "Giriş Yap"
            logInButtonLabel.setTitle("Giriş Yap", for: .normal)
            if emailTextField.text != "" && passwordLabel.text != "" {
                Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordLabel.text!) { result, error in
                    if error != nil {
                        self.alertFunc(titleInput: "Hata!", messageInput: "Kullanıcı Adı/Şifre Yanlış Olabilir Lütfen Kontrol Ediniz")
                        
                    } else {
                        self.dismiss(animated: true)
                    }
                    
                }
                
            } else {
                self.alertFunc(titleInput: "Hata!", messageInput: "Kullanıcı Adı/Şifre Bulunamadı")
            }
            
        } else {
            loginModeLabel.text = "Hesap Oluştur"
            logInButtonLabel.setTitle("Hesap Oluştur", for: .normal)
            if emailTextField.text != "" && passwordLabel.text != "" {
                guard let email = emailTextField.text, let password = passwordLabel.text else {
                    print("email veya password kontrolden geçemedi")
                    return
                }
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if error != nil {
                        print(error?.localizedDescription)
                    } else {
                        self.alertFunc(titleInput: "Kullanıcı Oluşturuldu", messageInput: "Kullanıcı Oluşturma İşleminiz Başarılı Bir Şekilde Gerçekleşmiştir Lütfen Giriş Yapınız.")
                    }
                    
                    
                }
                
            } else {
                alertFunc(titleInput: "Hata!", messageInput: "Kullanıcı Adı/Şifre Bulunamadı ")
            }
            
        }
    }
    func alertFunc(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func closePageButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}
