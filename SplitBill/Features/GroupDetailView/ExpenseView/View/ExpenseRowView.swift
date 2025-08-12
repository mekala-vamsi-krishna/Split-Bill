//
//  ExpenseRowView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI

struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconForExpense(expense))
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundColor(.blue)

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)

                Text(expense.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text("₹\(expense.amount, specifier: "%.2f")")
                .font(.headline)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    ExpenseRowView(expense: Expense(title: "", amount: 20, date: Date(), paidBy: User(name: "User 1", phoneNumber: "9876543210"), participants: [User(name: "user 2", phoneNumber: "9876543210")]))
}
