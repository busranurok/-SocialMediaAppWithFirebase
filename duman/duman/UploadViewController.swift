//
//  UploadViewController.swift
//  duman
//
//  Created by Yeni Kullanıcı on 31.10.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //resme tıklanabilir hale getirmek için
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        
        //hide keyword
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)

    }
    
    @objc func chooseImage(){
    
    //kullanıcının kütüphanesine erişebilmek için pickercontroller kullanılır
    let pickerController = UIImagePickerController()
        //gerekli metodları burada çağırabilmek için delegate self yapılır
        //bunun için uıimagepickercontrollerdelegate ve uınavigationcontrollerdelegateyi ekleriz
        pickerController.delegate = self
        //bu fotografları nereden alacağını belirliyoruz
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    
    
    }
    
    //kullanıcı bunu seçince ne olacak onu söylemeliyiz
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //UIImage ye cast ediyoruz
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        //bu referanslar sayesinde hangi klasör ile çalıacağımızı nereye kayıt yapabileceğimizi belirtiyoruz.
        let storageReference = storage.reference()
        
        //klasörün referansı
        let mediaFolder = storageReference.child("media")
        
        //veriye çevirip firebase yazacağız
        //compressionQuality : ben bunu ne kadar sıkıştırayım
        if let data = imageView?.image?.jpegData(compressionQuality: 0.5){
            
            //BİR UUİD VERİYOR VE BUNU STRİNG E ÇEVİRİYOR
            //BÖYLECE HER KULLANDIĞIMIZDA bir öncekinden farklı unique bir değer almasını sağlar.ß
            let uuid = UUID().uuidString
            
            //yukarıdaki datayı alıp buraya kaydederiz
            //oluşturacağım görselin referansı
            //aşağıdaki kod şeklinde yazdığımızda her defasında yeni resmi ekleyecek önceki resmin üzerine yazıyopr ve hep tewk resim olmuş oluyorß
            //let imageReferance = mediaFolder.child("image.jpg")
            //uuid şeklinde aldığımızda jpg değil de dms şeklinde indirir o yüzden :
            //let imageReferance = mediaFolder.child(uuid)
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data, metadata: nil) { (metaData, error) in
                
                if error != nil{
                    //firebaseden hata mesajı gelmez ise Error yazdır
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    
                    //kullanıcının kaydettiği şeyin hangi url ye hangi web adresine kaydediğini alırız
                    //bunu datayı koyduktan sonra yapmamız gerekiyor
                    imageReferance.downloadURL(completion: { (url, error) in
                        
                        if error == nil {
                            
                            //url mi alt string e çevir
                            //optional olarak (?)
                            let imageUrl = url?.absoluteString
                            //print(imageUrl)
                            
                            
                            //DATABASE
                            //Kullanıcının yadığı yorumu, görselin url sini, hangi kullanıcı bu postu yapıyoer ise onun adını, tarih gibi önemli bilgileri veritabanına kayıt edeceğiz
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReferance : DocumentReference? = nil
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment": self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes": 0 ] as [String : Any]
                            firestoreReferance = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                
                                if error != nil{
                                    
                                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                                    
                                } else {
                                    
                                    //resim seçip yorum yazdıktan sonra imageview ve comment text ti boşaltıyoruz.
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    //tabbarcontrollerdaki feed upload ya da setting den hangisi seçili olarak gelsin. biz feed i otomaik gelmesini istiyoruz.
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            })
                            
                            
                        }
                    })
                    
                }
            }
            
        }
        
    }
    
    func makeAlert(titleInput:String, messageInput:String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
