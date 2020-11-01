//
//  SettingsViewController.swift
//  duman
//
//  Created by Yeni Kullanıcı on 31.10.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func logoutClicked(_ sender: Any) {
        //performSegue(withIdentifier: "toVC", sender: nil)
        //firebaseden çıkış yapmak için:
        //internet kopar vs
        do {
            try Auth.auth().signOut()
            //bundan sonra ya performsegue diyip vc gidebiliriz ya da appdelegete de tanımladığımız currentuser ı onun içerisinde ayrıca bir fonksiyon olarak tanımlayıp orada bir sıkıntı var mı yok mu onu anlayabiliriz
            performSegue(withIdentifier: "toVC", sender: nil)
        } catch{
            print("error")
        }
    }
}
