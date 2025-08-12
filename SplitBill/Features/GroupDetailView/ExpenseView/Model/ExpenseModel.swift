//
//  ExpenseModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import Foundation
import SwiftData

@Model
class Expense: Identifiable {
    var id: UUID
    var title: String
    var amount: Double
    var date: Date
    @Relationship var paidBy: User
    @Relationship var participants: [User]

    init(title: String, amount: Double, date: Date, paidBy: User, participants: [User]) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.date = date
        self.paidBy = paidBy
        self.participants = participants
    }
}

func iconForExpense(_ expense: Expense) -> String {
    switch expense.title.lowercased() {
    case let t where t.contains("food"): return "fork.knife"
    case let t where t.contains("travel"): return "car"
    case let t where t.contains("rent"): return "house"
    case let t where t.contains("groceries"): return "cart"
    default: return "creditcard"
    }
}
