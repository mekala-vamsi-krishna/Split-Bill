//
//  ExpenseDetailsView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/7/25.
//

import SwiftUI

struct ExpenseDetailsView: View {
    let expense: Expense
    
    var body: some View {
        VStack(spacing: 20) {
            Text(expense.title)
                .font(.title)
            Text("₹\(expense.amount, specifier: "%.2f")")
                .font(.title2)
            Text("Paid on \(expense.date.formatted(date: .abbreviated, time: .omitted))")
        }
        .padding()
    }
}

#Preview {
    ExpenseDetailsView(expense: Expense(title: "Grocery", amount: 200, date: Date(), paidBy: User(name: "User 1", phoneNumber: "9876543210"), participants: [User(name: "user 2", phoneNumber: "9876543210"), User(name: "user 3", phoneNumber: "9876543210")]))
}
