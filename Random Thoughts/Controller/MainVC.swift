//
//  ViewController.swift
//  Random Thoughts
//
//  Created by Nikolaos Agas on 21/09/2019.
//  Copyright © 2019 Nikolaos Agas. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

enum ThoughtCategory: String {
    case serious = "serious"
    case funny = "funny"
    case crazy = "crazy"
    case popular = "popular"
}


class MainVC: UIViewController , UITableViewDelegate, UITableViewDataSource, ThoughtDelegate{
    func thoughtOptionsTapped(thought: Thought) {
        print("thought \(String(describing: thought.username))")
        let alert = UIAlertController(title: "Delete Thought?", message: "You can delete or edit", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            self.thoughtsCollctionRef?.document(thought.documentId).delete(completion: { (error) in
                if let error = error {
                    debugPrint("delete error \(error.localizedDescription)")
                }else {
                    alert.dismiss(animated: true, completion: nil)
                }
            })
        }
        let editEction = UIAlertAction(title: "Edit", style: .default) { (action) in
            self.performSegue(withIdentifier: "toEditThought", sender: thought)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        alert.addAction(deleteAction)
        alert.addAction(editEction)
        alert.addAction(cancelAction)
        present(alert, animated: true,completion: nil)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? AddThoughtVC {
//            if let thouhht = sender as? (thought: Thought){
//                destination.thought = thought
//            }
//        }
//    }
    
  
    private var thoughts = [Thought]()
    private var thoughtsCollctionRef : CollectionReference?
    private var thoughtsListener : ListenerRegistration?
    private var selectedCategoty  = ThoughtCategory.funny.rawValue
    
    @IBOutlet weak var tableView: UITableView!
    
   
    
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        thoughtsCollctionRef = Firestore.firestore().collection(THOUGHTS_REF)
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main",bundle: nil)
                let loginvc = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginvc, animated: true, completion: nil)
            }else {
                self.setListener()
            }
        })
      
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signoutError as NSError {
            debugPrint("signout error \(signoutError)")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if(thoughtsListener != nil){
             thoughtsListener?.remove()
        }
       
    }
    
    @IBAction func categoryPick(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            selectedCategoty = ThoughtCategory.funny.rawValue
        case 1:
            selectedCategoty = ThoughtCategory.serious.rawValue
        case 2:
            selectedCategoty = ThoughtCategory.crazy.rawValue
        case 3:
            selectedCategoty = ThoughtCategory.popular.rawValue
        default:
            selectedCategoty = ThoughtCategory.funny.rawValue
        }
        setListener()
    }
  
    
    func setListener(){
        thoughtsListener?.remove()
        
        if(selectedCategoty == ThoughtCategory.popular.rawValue){
            thoughtsListener = thoughtsCollctionRef?
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener({ (snapshot, error) in
                    if let err = error {
                        debugPrint("error fetching \(err)")
                    }else {
                        self.thoughts.removeAll()
                     
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        self.tableView.reloadData()
                        
                    }
                })
        }else {
            thoughtsListener = thoughtsCollctionRef?
                .whereField(CATEGORY, isEqualTo: selectedCategoty)
                .order(by: TIMESTAMP, descending: true)
                .addSnapshotListener({ (snapshot, error) in
                    if let err = error {
                        debugPrint("error fetching \(err)")
                    }else {
                        self.thoughts.removeAll()
                        self.thoughts = Thought.parseData(snapshot: snapshot)
                        self.tableView.reloadData()
                    }
                })
        }
      
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "thoughtCell", for: indexPath) as? ThoughCell{
            cell.configureCell(thought: thoughts[indexPath.row], delegate : self)
            return cell
        }
        
        return UITableViewCell()
    }

}

