//
//  TopViewController.swift
//  chat_app_2
//
//  Created by 原ひかる on 2019/12/21.
//  Copyright © 2019 原ひかる. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonOnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSignUp", sender: nil)
    }
    @IBAction func logInButtonOnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toLogin", sender: nil)
    }
    
}
