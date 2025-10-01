//
//  GroupDetailViewModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/7/25.
//

import Foundation
import SwiftData

class GroupDetailsViewModel: ObservableObject {
    private var context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func addMember(to group: Group, name: String, phoneNumber: String) {
        let newUser = User(name: name, phoneNumber: phoneNumber)
        group.members.append(newUser)
        context.insert(newUser)
        try? context.save()
    }

    func addExpense(to group: Group, title: String, amount: Double, paidBy: User, participants: [User]) {
        let expense = Expense(title: title, amount: amount, date: Date(), paidBy: paidBy, participants: participants)
        group.expenses.append(expense)
        context.insert(expense)
        try? context.save()
    }

    func deleteExpense(from group: Group, at offsets: IndexSet) {
        for index in offsets {
            let expenseToDelete = group.expenses[index]
            group.expenses.remove(at: index)
            context.delete(expenseToDelete)
        }
        try? context.save()
    }
}
