//
//  LoginViewController.swift
//  chat_app_2
//
//  Created by 原ひかる on 2019/12/21.
//  Copyright © 2019 原ひかる. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoom" {
            let roomVC = segue.destination as! RoomViewController
            roomVC.currentUserName = sender as! String
        }
    }
    
    @IBAction func loginButtonOnPressed(_ sender: Any) {
        if mailTextField.text != "" {
            let email = mailTextField.text!
            if passwordTextField.text != "" {
                let password = passwordTextField.text!
                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    if let result = result {
                        print(result)
                    }
                }
                Firestore.firestore().collection("users").document(email).getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dataDescription = document.data() as! [String : String]
                        let userName = dataDescription["userName"]
                        self.performSegue(withIdentifier: "toRoom", sender: userName)
                    } else {
                        print("document does not exist")
                    }
                }
            }
        }
        
    }
    
}
