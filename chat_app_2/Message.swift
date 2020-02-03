//
//  Message.swift
//  chat_app_2
//
//  Created by 原ひかる on 2019/12/23.
//  Copyright © 2019 原ひかる. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
