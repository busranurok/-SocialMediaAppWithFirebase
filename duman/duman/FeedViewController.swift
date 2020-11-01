//
//  FeedViewController.swift
//  duman
//
//  Created by Yeni Kullanıcı on 31.10.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    var gestureRecognizer : UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
        
        
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        

    }
    
    //hide keywordß
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //verileri çekmek için
    func getDataFromFirestore(){
        
        //firestorenin instancesini oluşturduk
        let fireStoreDatabase = Firestore.firestore()
        //ayarları değiştirmek için kullanılır
        //tarih ayarını düzeltmek için
        /*let settings = fireStoreDatabase.settings
        settings.areTimestampsInSnapshotsEnabled = true*/
        
        //order dersek eğer tarihi azalan sıra ile göstermemizi sağlayacak
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            
            if error != nil{
                
                print(error?.localizedDescription)
            } else{
                
                if snapshot?.isEmpty != true && snapshot != nil{
                    
                    //verileri temizlemesi için
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.documentIdArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        
                        let documentID = document.documentID
                        //print(documentID)
                        self.documentIdArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String{
                            
                            self.userEmailArray.append(postedBy)
                            
                        }
                        
                        if let postComment = document.get("postComment") as? String{
                            
                            self.userCommentArray.append(postComment)
                            
                        }
                        
                        if let likes = document.get("likes") as? Int{
                            
                            self.likeArray.append(likes)
                            
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String{
                            
                            self.userImageArray.append(imageUrl)
                        }
                    }
                    
                    //güncelle
                    self.tableView.reloadData()
                    
                }
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userEmailArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCellTableViewCell
        /*cell.userEmailLabel.text = "user@gmail.com"
        cell.likeLabel.text = "0"
        cell.commentLabel.text = "comment"
        cell.userImageView.image = UIImage(named: "select.png")*/
        
        cell.userEmailLabel.text = userEmailArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.commentLabel.text = userCommentArray[indexPath.row]
        //cell.userImageView.image = UIImage(named: "select.png")
        cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        cell.documentIdLabel.text = documentIdArray[indexPath.row]
        return cell
    }

}
