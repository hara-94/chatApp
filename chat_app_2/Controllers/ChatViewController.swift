//
//  ChatViewController.swift
//  chat_app_2
//
//  Created by 原ひかる on 2019/12/22.
//  Copyright © 2019 原ひかる. All rights reserved.
//

import UIKit
import FirebaseFirestore
import MessageKit


class ChatViewController: MessagesViewController {
    
    
    var messages = [Message]()
    var roomInfo = [String : String]()
    var roomName: String?
    //login/signup画面から引き継ぐ
    var id: String = "ID"
    var otherId: String = "otherID"
    //login/signup画面から引き継ぐ
    var userName: String = "USERNAME"
    var otherUserName: String = "otherUSERNAME"
    
    func createMessage(sender: SenderType, date: Date, text: String) -> Message {
        return Message(sender: sender, messageId: id, sentDate: date, kind: .text(text))
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        roomName = roomInfo["title"]
        id = roomInfo["userName"]!
        userName = roomInfo["userName"]!
        
        Firestore.firestore().collection("rooms").document(roomName!).collection("\(roomName!)Messages").order(by: "date").addSnapshotListener { (snapshot, error) in
            guard let value = snapshot else {
                print(error!)
                return
            }
            value.documentChanges.forEach { diff in
                if diff.type == .added {
                    let messageData = diff.document.data()
                    //データからtextフィールドの値を取得
                    guard let text = messageData["text"] as? String else {
                        return
                    }
                    //データからsenderフィールドの値を取得
                    guard let sender = messageData["sender"] as? String else {
                        return
                    }
                    //データからnameフィールドの値を取得
                    guard let name = messageData["name"] as? String else {
                        return
                    }
                    //データからdateフィールドの値を取得
                    guard let timeStampDate = messageData["date"] as? Timestamp else {
                        return
                    }
                    //dateフィールドの値をDate型に変換
                    let date: Date = timeStampDate.dateValue()
                    //
                    if sender == self.id {
                        print("this is my message")
                        let myStoredMessage = self.createMessage(sender: self.currentSender(), date: date, text: text)
                        self.messages.append(myStoredMessage)
                    } else {
                        print("this is other's message")
                        let otherStoredMessage = self.createMessage(sender: self.otherSender(id: sender, name: name), date: date, text: text)
                        self.messages.append(otherStoredMessage)
                    }
                    self.messagesCollectionView.reloadData()
                }
            }
        }
    }
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: id, displayName: userName)
    }
    
    func otherSender(id: String, name: String) -> SenderType {
        return Sender(id: id, displayName: name)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        print(name + "これは名前です")
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
}

extension ChatViewController: MessageInputBarDelegate {
    func inputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        if text != "" {
            let newMessage: Message = createMessage(sender: currentSender(), date: Date(), text: text)
            let date = newMessage.sentDate
            let sender = newMessage.messageId
            let inputText = text
            let name = newMessage.sender.displayName
            Firestore.firestore().collection("rooms").document(roomName!).collection("\(roomName!)Messages").document().setData(["date" : date, "sender" : sender, "text" : inputText, "name" : name])
        }
    }
}


extension ChatViewController: MessagesLayoutDelegate {
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

extension ChatViewController: MessageCellDelegate {
    
}

