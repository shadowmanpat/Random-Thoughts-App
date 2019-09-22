//
//  LoginVC.swift
//  Random Thoughts
//
//  Created by Nikolaos Agas on 21/09/2019.
//  Copyright © 2019 Nikolaos Agas. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginVC: UIViewController {

    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var createUserBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserBtn.layer.cornerRadius = 10
        loginBtn.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = emailTxt.text,
        let password = passwordTxt.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("error signin \(error.localizedDescription)")
            }else {
                self.dismiss(animated: true, completion: nil)
            }
            
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
