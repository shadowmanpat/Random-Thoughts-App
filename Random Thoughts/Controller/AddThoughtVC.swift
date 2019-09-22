//
//  AddThoughtVC.swift
//  Random Thoughts
//
//  Created by Nikolaos Agas on 21/09/2019.
//  Copyright © 2019 Nikolaos Agas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AddThoughtVC: UIViewController, UITextViewDelegate {
//outlets
    
    @IBOutlet weak var thoughtTxt: UITextView!
   
    @IBOutlet weak var categorySegment: UISegmentedControl!
    @IBOutlet weak var postBtn: UIButton!
    
    //variables
    private var selectedCategory: String = ThoughtCategory.funny.rawValue
    var thought : Thought?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postBtn.layer.cornerRadius = 4
        thoughtTxt.layer.cornerRadius = 4
        thoughtTxt.text = "My random thought..."
        thoughtTxt.textColor = UIColor.lightGray
        thoughtTxt.delegate = self
        
        if let thought = self.thought {
            thoughtTxt.text = thought.thoughtTxt
            selectedCategory = thought.category
           // kh
//            categorySegment.selectedSegmentIndex =
        }
        // Do any additional setup after loading the view.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.darkGray
    }
    
    @IBAction func postBtnTapped(_ sender: Any) {
       
        Firestore.firestore().collection(THOUGHTS_REF).addDocument(data: [
            CATEGORY : selectedCategory,
            NUM_LIKES: 0,
            NUM_COMMENTS : 0,
            THOUGHT_TXT : thoughtTxt.text!,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : Auth.auth().currentUser?.displayName ?? "",
            USER_ID: Auth.auth().currentUser?.uid ?? ""
        
        ]) { (err) in
            if let err = err {
                debugPrint("error adding document: \(err)")
            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func categoryChanged(_ sender: Any) {
        switch categorySegment.selectedSegmentIndex {
        case 0:
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.funny.rawValue
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
