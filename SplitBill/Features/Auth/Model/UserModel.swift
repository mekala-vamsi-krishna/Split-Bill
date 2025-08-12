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
    var name: String
    var phoneNumber: String
    
    init(name: String, phoneNumber: String) {
        self.id = UUID()
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
