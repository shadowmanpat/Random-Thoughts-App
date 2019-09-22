//
//  ThoughCell.swift
//  Random Thoughts
//
//  Created by Nikolaos Agas on 21/09/2019.
//  Copyright © 2019 Nikolaos Agas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

protocol  ThoughtDelegate {
    func thoughtOptionsTapped(thought: Thought)
}

class ThoughCell: UITableViewCell {

    @IBOutlet weak var usenameTxt: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var thoughLbl: UILabel!
    @IBOutlet weak var likesNumberLbl: UILabel!
    @IBOutlet weak var likesImg: UIImageView!
    @IBOutlet weak var optionsMenu: UIImageView!
    
    
    private var tought : Thought?
    private var delegate : ThoughtDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likesImg.addGestureRecognizer(tap)
        likesImg.isUserInteractionEnabled = true
        // Configure the view for the selected state
    }
   
    @objc func likeTapped (){
//        likesImg.a
        //method 1
        Firestore.firestore().collection(THOUGHTS_REF).document(tought!.documentId)
            .setData([NUM_LIKES: (tought!.numlikes+1)], merge: true)
        
    }
    func configureCell(thought: Thought, delegate: ThoughtDelegate){
        self.tought = thought
        self.delegate = delegate
        usenameTxt.text = thought.username
//        timestampLbl.text = String(thought.timestamp)
        thoughLbl.text = thought.thoughtTxt
        likesNumberLbl.text = String(thought.numlikes)
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM yyyy, hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        timestampLbl.text = timestamp
        
        if thought.userId == Auth.auth().currentUser?.uid {
            optionsMenu.isHidden = false
            optionsMenu.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtOprionsTapped))
            optionsMenu.addGestureRecognizer(tap)
        }else {
            optionsMenu.isHidden = true
            optionsMenu.isUserInteractionEnabled = false
        }
    }
    
    @objc func thoughtOprionsTapped(){
        guard let thought = tought else {return}
        delegate?.thoughtOptionsTapped(thought: thought)
    }

}
