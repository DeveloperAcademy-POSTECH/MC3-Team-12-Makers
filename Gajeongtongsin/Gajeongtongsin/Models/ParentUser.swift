//
//  ParentUser.swift
//  Gajeongtongsin
//
//  Created by uiskim on 2022/07/19.
//

import Foundation

struct ParentUser {
    let id = UUID().uuidString
    let sendingMessages: [Message]
    let childName: [String]
    let schedules: [Schedule]
}
