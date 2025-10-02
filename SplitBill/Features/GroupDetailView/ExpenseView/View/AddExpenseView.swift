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
    
    @State private var selectedParticipants: [User] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                // MARK: - Expense Title
                VStack(alignment: .leading, spacing: 8) {
                    Text("Expense Title")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("e.g. Dinner, Travel, Movie", text: $expenseTitle)
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
                
                // MARK: - Participants Picker
                if !group.members.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Paid for?")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 16) {
                            ForEach(group.members) { member in
                                VStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(selectedParticipants.contains(where: { $0.id == member.id }) ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                            .frame(height: 70)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(selectedParticipants.contains(where: { $0.id == member.id }) ? Color.blue : Color.clear, lineWidth: 2)
                                            )
                                        
                                        VStack {
                                            Text(initials(from: member.name))
                                                .font(.title3).bold()
                                                .foregroundColor(selectedParticipants.contains(where: { $0.id == member.id }) ? .blue : .secondary)
                                            Text(member.name)
                                                .font(.caption)
                                                .lineLimit(1)
                                        }
                                    }
                                }
                                .onTapGesture {
                                    if let index = selectedParticipants.firstIndex(where: { $0.id == member.id }) {
                                        selectedParticipants.remove(at: index)
                                    } else {
                                        selectedParticipants.append(member)
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
            Button("Save") {
                if let payer = selectedPayer,
                   let amount = Double(expenseAmount),
                   !selectedParticipants.isEmpty {
                    addExpenseViewModel.addExpense(
                        to: group,
                        title: expenseTitle,
                        amount: amount,
                        paidBy: payer,
                        participants: selectedParticipants
                    )
                    dismiss()
                }
            }
            .disabled(expenseTitle.trimmingCharacters(in: .whitespaces).isEmpty ||
                      expenseAmount.trimmingCharacters(in: .whitespaces).isEmpty ||
                      selectedPayer == nil ||
                      selectedParticipants.isEmpty)
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
