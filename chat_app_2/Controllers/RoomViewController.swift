//
//  RoomViewController.swift
//  chat_app_2
//
//  Created by 原ひかる on 2019/12/21.
//  Copyright © 2019 原ひかる. All rights reserved.
//

import UIKit
import FirebaseFirestore

class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var rooms = [String]()
    var passedInfo = [String: String]()
    var currentUserName = ""
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        
    }
    
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
            print(self.rooms)
            self.tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = rooms[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let label = tableView.cellForRow(at: indexPath)?.viewWithTag(2) as? UILabel {
            let title = label.text
            passedInfo = ["title" : title!, "userName" : currentUserName]
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "toChat", sender: passedInfo)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChat" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.roomInfo = sender as! [String : String]
        }
    }
    
    @IBAction func addButtonOnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toAddModal", sender: nil)
    }
    
}
