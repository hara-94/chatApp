//
//  SignUpViewController.swift
//  chat_app_2
//
//  Created by 原ひかる on 2019/12/21.
//  Copyright © 2019 原ひかる. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRoom" {
            let roomVC = segue.destination as! RoomViewController
            roomVC.currentUserName = sender as! String
        }
    }
    

    @IBAction func signUpButtonOnPressed(_ sender: Any) {
        if mailTextField.text != "" {
            let email = mailTextField.text
            if passwordTextField.text != "" {
                let password = passwordTextField.text
                if userNameTextField.text != "" {
                    let userName = userNameTextField.text
                    Auth.auth().createUser(withEmail: email!, password: password!) { (result, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        if let result = result {
                            print(result)
                            Firestore.firestore().collection("users").document(email!).setData(["email" : email!, "userName" : userName!])
                            self.performSegue(withIdentifier: "toRoom", sender: userName)
                        }
                    }
                }
            }
        }
        
    }
}
