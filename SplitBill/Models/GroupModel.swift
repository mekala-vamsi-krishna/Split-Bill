//
//  GroupModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import Foundation
import SwiftData

@Model
class Group {
    @Attribute(.unique) var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var members: [User]
    @Relationship(deleteRule: .cascade) var expenses: [Expense]

    init(name: String, members: [User] = [], expenses: [Expense] = []) {
        self.id = UUID()
        self.name = name
        self.members = members
        self.expenses = expenses
    }
}
