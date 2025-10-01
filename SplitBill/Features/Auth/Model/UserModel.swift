//
//  UserModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import Foundation
import SwiftData

@Model
class User: Identifiable {
    var id: UUID
    var uid: String?        // Firebase UID
    var name: String
    var phoneNumber: String
    var email: String?

    init(name: String, phoneNumber: String, uid: String? = nil, email: String? = nil) {
        self.id = UUID()
        self.uid = uid
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
    }
}
