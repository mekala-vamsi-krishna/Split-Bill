//
//  AddExpenseView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI
import SwiftData

struct AddExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var addExpenseViewModel: AddExpenseViewModel
    let group: Group
    @State private var expenseTitle = ""
    @State private var expenseAmount = ""
    @State private var selectedPayer: User?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Expense Title", text: $expenseTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Amount", text: $expenseAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                
                if !group.members.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Paid by:")
                            .font(.headline)
                        
                        Picker("Paid by", selection: $selectedPayer) {
                            ForEach(group.members) { member in
                                Text(member.name).tag(member as User?)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Expense")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    if let payer = selectedPayer,
                       let amount = Double(expenseAmount) {
                        addExpenseViewModel.addExpense(
                            to: group,
                            title: expenseTitle,
                            amount: amount,
                            paidBy: payer,
                            participants: group.members
                        )
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .disabled(expenseTitle.trimmingCharacters(in: .whitespaces).isEmpty ||
                         expenseAmount.trimmingCharacters(in: .whitespaces).isEmpty ||
                         selectedPayer == nil)
            )
        }
    }
}

#Preview {
    let user1 = User(name: "User 1", phoneNumber: "1234567890")
    let user2 = User(name: "User 2", phoneNumber: "0987654321")
    let group = Group(name: "Roommates", members: [user1, user2], expenses: [])

    let mockViewModel = AddExpenseViewModel()

    AddExpenseView(group: group)
        .environmentObject(AddExpenseViewModel())
}
