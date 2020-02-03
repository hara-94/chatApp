//
//  AddModalViewController.swift
//  chat_app_2
//
//  Created by 原ひかる on 2019/12/22.
//  Copyright © 2019 原ひかる. All rights reserved.
//

import UIKit
import FirebaseFirestore

class AddModalViewController: UIViewController {
    
    @IBOutlet weak var roomTextField: UITextField!
    var rooms = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Firestore.firestore().collection("rooms").order(by: "date").addSnapshotListener { (snapshot, error) in
            guard let value = snapshot else {
                print(error!)
                return
            }
        
            value.documentChanges.forEach { diff in
                if diff.type == .added {
                    let roomsData = diff.document.data()
                    let documentName = roomsData["name"] as! String
                    self.rooms.insert(documentName, at: 0)
                }
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag != 3 {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    
    @IBAction func addButtonOnPressed(_ sender: Any) {
        guard let roomName = roomTextField.text else {
            return
        }
        if roomName != "" {
            let date = Date()
            let timeStampDate = Timestamp(date: date)
            print(rooms)
            if rooms.contains(roomName) == false {
                Firestore.firestore().collection("rooms").document(roomName).setData(["name" : roomName, "date" : timeStampDate])
                dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "このルーム名は既に使われています", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
}
