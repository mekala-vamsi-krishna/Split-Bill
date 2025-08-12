//
//  AddExpenseViewModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/7/25.
//

import Foundation
import SwiftData

class AddExpenseViewModel: ObservableObject {
    private var context: ModelContext?
    func addExpense(to group: Group, title: String, amount: Double, paidBy: User, participants: [User]) {
        let expense = Expense(
            title: title,
            amount: amount,
            date: Date(),
            paidBy: paidBy,
            participants: participants
        )
        
        group.expenses.append(expense)
        context?.insert(expense) // Technically this might not be needed if group already owns it
        try? context?.save()
    }
}
