//
//  AddMemberView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI
import SwiftData

struct AddMemberView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var groupViewModel: GroupViewModel
    let group: Group
    @State private var memberName = ""
    @State private var memberPhone = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Member Name", text: $memberName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Phone Number", text: $memberPhone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Add Member")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    let newMember = User(name: memberName, phoneNumber: memberPhone)
                    groupViewModel.addMember(to: group, member: newMember)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(memberName.trimmingCharacters(in: .whitespaces).isEmpty || memberPhone.trimmingCharacters(in: .whitespaces).isEmpty)
            )
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Group.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    AddMemberView(group: Group(name: "Roommates", members: [User(name: "user 1", phoneNumber: "1234567890"), User(name: "user 2", phoneNumber: "1234567890")], expenses: [Expense(title: "Groceries", amount: 200, date: Date(), paidBy: User(name: "user 1", phoneNumber: "1234567890"), participants: [User(name: "user1", phoneNumber: "1234567890"), User(name: "user2", phoneNumber: "1234567890"), User(name: "user3", phoneNumber: "1234567890")])]))
        .environmentObject(GroupViewModel(context: context))
}
