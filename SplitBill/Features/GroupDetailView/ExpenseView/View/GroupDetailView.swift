//
//  GroupDetailView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI
import SwiftData

struct GroupDetailView: View {
    let group: Group
    @EnvironmentObject var createGroupViewModel: GroupDetailsViewModel
    @StateObject var addExpenseViewModel = AddExpenseViewModel()

    @State private var navigateToMembers = false
    @State private var navigateToAddExpense = false

    private var totalExpenses: Double {
        group.expenses.reduce(0) { $0 + $1.amount }
    }

    var body: some View {
        VStack {
            // Quick Stats
            HStack {
                VStack {
                    Text("\(group.members.count)")
                        .font(.title2)
                        .fontWeight(.heavy)
                    Text("Members")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("\(group.expenses.count)")
                        .font(.title2)
                        .fontWeight(.heavy)
                    Text("Expenses")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("₹\(totalExpenses, specifier: "%.2f")")
                        .font(.title2)
                        .fontWeight(.heavy)
                    Text("Total")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding()
            
            // Action Buttons
            HStack(spacing: 15) {
                NavigationLink(destination: MembersView(group: group)
                                .environmentObject(createGroupViewModel),
                               isActive: $navigateToMembers) {
                    Button(action: { navigateToMembers = true }) {
                        Label("Members", systemImage: "person.2")
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.indigo)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
                
                NavigationLink(destination: AddExpenseView(group: group)
                                .environmentObject(addExpenseViewModel),
                               isActive: $navigateToAddExpense) {
                    Button(action: { navigateToAddExpense = true }) {
                        Label("Add Expense", systemImage: "plus.circle")
                            .frame(maxWidth: .infinity)
                            .frame(height: 44)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            
            // Content Tabs
            if group.expenses.isEmpty && group.members.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("No expenses or members yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("Add members and start tracking expenses")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 50)
            } else {
                List {
                    if !group.expenses.isEmpty {
                        Section("Expenses") {
                            ForEach(group.expenses) { expense in
                                NavigationLink(destination: ExpenseDetailsView(expense: expense)) {
                                    ExpenseRowView(expense: expense)
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        if let index = group.expenses.firstIndex(where: { $0.id == expense.id }) {
                                            deleteExpense(at: IndexSet(integer: index))
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
        }
        .navigationTitle(group.name)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteExpense(at offsets: IndexSet) {
        createGroupViewModel.deleteExpense(from: group, at: offsets)
    }
}


#Preview {
    let container = try! ModelContainer(for: Group.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    
    GroupDetailView(group: Group(
        name: "Roommates",
        members: [
            User(name: "user 1", phoneNumber: "1234567890"),
            User(name: "user 2", phoneNumber: "1234567890")
        ],
        expenses: [
            Expense(
                title: "Groceries",
                amount: 200,
                date: Date(), paidBy: User(name: "user 1", phoneNumber: "1234567890"),
                participants: [
                    User(name: "user1", phoneNumber: "1234567890"),
                    User(name: "user2", phoneNumber: "1234567890"),
                    User(name: "user3", phoneNumber: "1234567890")
                ]
            )
        ]
    ))
    .environmentObject(GroupDetailsViewModel(context: context))
}

