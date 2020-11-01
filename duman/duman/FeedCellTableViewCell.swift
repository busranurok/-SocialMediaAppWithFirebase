//
//  FeedCellTableViewCell.swift
//  duman
//
//  Created by Yeni Kullanıcı on 1.11.2020.
//  Copyright © 2020 Busra Nur OK. All rights reserved.
//

import UIKit
import Firebase

class FeedCellTableViewCell: UITableViewCell {
    
    //custom tableview oluşturduk
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            //likes yazan yer firebase de ne yazıyor ise o
            let likeStore = ["likes": likeCount+1] as [String : Any]
            //bir şeyi güncellemek için .setdata merge: birleştir.
            //merge: yani ben bu datayı sana veriyorum. sadece like ı güncelle geri kalanına dokunma demek
            firestoreDatabase.collection("Posts").document(documentIdLabel.text!).setData(likeStore, merge: true)
            
        }
        
    }
    
}
