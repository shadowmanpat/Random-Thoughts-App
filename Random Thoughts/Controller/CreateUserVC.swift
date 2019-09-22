//
//  CreateUserVC.swift
//  Random Thoughts
//
//  Created by Nikolaos Agas on 21/09/2019.
//  Copyright © 2019 Nikolaos Agas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CreateUserVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    @IBAction func createBtnTapped(_ sender: Any) {
        guard let email = emailTxt.text,
            let password = passwordTxt.text,
            let username = usernameTxt.text else {return}
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let err = error {
                debugPrint("Error creating use \(err.localizedDescription)")
            }
            
            let changeRequest = user?.user.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            })
            guard let userId = user?.user.uid else {return}
            Firestore.firestore().collection(USER_REF).document(userId).setData([
                USERNAME : username,
                DATE_CREATED : FieldValue.serverTimestamp()
                ], completion: { (error) in
                    if let err = error {
                        debugPrint(err.localizedDescription)
                    }else {
                        self.dismiss(animated: true, completion: nil)
                    }
            })
        }
    }
    
    @IBAction func cancelBrnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
