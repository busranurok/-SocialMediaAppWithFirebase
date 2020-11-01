//
//  ViewController.swift
//  duman
//
//  Created by Yeni Kullanıcı on 31.10.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        /*let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            
            performSegue(withIdentifier: "toFeedVC", sender: nil)
            
        }*/
    }

    @IBAction func sigInClicked(_ sender: Any) {
        //performSegue(withIdentifier: "toFeedVC", sender: nil)
        
        if emailText.text != "" && passwordText.text != "" {
            
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                } else{
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                    
                }
            }
            
        } else {
            
            makeAlert(titleInput: "Error", messageInput: "Username/Password")
            
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
            
            //Auth den auth nesnesi oluşturmak gibi
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { (authData, error) in
                
                if error != nil {
                    
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                    
                } else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
            
        } else {
            
            makeAlert(titleInput: "Error", messageInput: "Username/Password")
        }
    }
        
        func makeAlert(titleInput:String, messageInput:String){
            
            let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }

