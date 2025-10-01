//
//  AddExpenseView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var addExpenseViewModel: AddExpenseViewModel
    let group: Group
    
    @State private var expenseTitle = ""
    @State private var expenseAmount = ""
    @State private var selectedPayer: User?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                // MARK: - Expense Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Expense Title")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("e.g. Dinner, Uber, Movie", text: $expenseTitle)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                
                // MARK: - Amount Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amount")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("₹0.00", text: $expenseAmount)
                        .keyboardType(.decimalPad)
                        .font(.title2.bold())
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                }
                
                // MARK: - Payer Picker
                if !group.members.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Who paid?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(group.members) { member in
                                    VStack {
                                        ZStack {
                                            Circle()
                                                .fill(selectedPayer?.id == member.id ? Color.blue : Color.gray.opacity(0.2))
                                                .frame(width: 50, height: 50)
                                            
                                            Text(initials(from: member.name))
                                                .fontWeight(.bold)
                                                .foregroundColor(selectedPayer?.id == member.id ? .white : .blue)
                                        }
                                        
                                        Text(member.name)
                                            .font(.caption)
                                            .lineLimit(1)
                                    }
                                    .onTapGesture {
                                        selectedPayer = member
                                    }
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if let payer = selectedPayer,
                           let amount = Double(expenseAmount) {
                            addExpenseViewModel.addExpense(
                                to: group,
                                title: expenseTitle,
                                amount: amount,
                                paidBy: payer,
                                participants: group.members
                            )
                            dismiss()
                        }
                    }
                    .disabled(expenseTitle.trimmingCharacters(in: .whitespaces).isEmpty ||
                              expenseAmount.trimmingCharacters(in: .whitespaces).isEmpty ||
                              selectedPayer == nil)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    // MARK: - Initials Helper
    private func initials(from name: String) -> String {
        let parts = name.split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.dropFirst().first?.prefix(1) ?? ""
        return (first + last).uppercased()
    }
}

#Preview {
    let user1 = User(name: "User 1", phoneNumber: "1234567890")
    let user2 = User(name: "User 2", phoneNumber: "0987654321")
    let group = Group(name: "Roommates", members: [user1, user2], expenses: [])
    AddExpenseView(group: group)
        .environmentObject(AddExpenseViewModel())
}


#Preview {
    let user1 = User(name: "User 1", phoneNumber: "1234567890")
    let user2 = User(name: "User 2", phoneNumber: "0987654321")
    let group = Group(name: "Roommates", members: [user1, user2], expenses: [])

    let mockViewModel = AddExpenseViewModel()

    AddExpenseView(group: group)
        .environmentObject(AddExpenseViewModel())
}
