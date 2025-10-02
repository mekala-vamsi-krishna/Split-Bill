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

struct Balance {
    let user: User
    let amount: Double // positive = receive, negative = pay
}

extension Group {
    func calculateBalances() -> [Balance] {
        var balances: [UUID: Double] = [:]

        // Initialize balances
        for member in members {
            balances[member.id] = 0
        }

        // Calculate share for each expense
        for expense in expenses {
            let splitAmount = expense.amount / Double(expense.participants.count)

            // Each participant owes `splitAmount`
            for participant in expense.participants {
                balances[participant.id, default: 0] -= splitAmount
            }

            // Payer gets credited full expense
            balances[expense.paidBy.id, default: 0] += expense.amount
        }

        // Convert dictionary to Balance objects
        return members.map { member in
            Balance(user: member, amount: balances[member.id] ?? 0)
        }
    }
}
