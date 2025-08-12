//
//  GroupRowView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI

struct GroupRowView: View {
    let group: Group

    var body: some View {
        HStack(spacing: 16) {
            // Group icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 50, height: 50)

                Text(String(group.name.prefix(1)).uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack(spacing: 12) {
                    Label("\(group.members.count)", systemImage: "person.2.fill")
                    Label("\(group.expenses.count)", systemImage: "creditcard.fill")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 12)
//                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
//        )
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}





#Preview {
    GroupRowView(group: Group(name: "Roommates", members: [User(name: "user 1", phoneNumber: "1234567890"), User(name: "user 2", phoneNumber: "1234567890")], expenses: [Expense(title: "Groceries", amount: 200, date: Date(), paidBy: User(name: "user 1", phoneNumber: "1234567890"), participants: [User(name: "user1", phoneNumber: "1234567890"), User(name: "user2", phoneNumber: "1234567890"), User(name: "user3", phoneNumber: "1234567890")])]))
}

//struct GroupRowView: View {
//    let group: Group
//
//    var body: some View {
//        HStack(alignment: .center, spacing: 16) {
//            // Group Icon
//            ZStack {
//                Circle()
//                    .fill(Color.blue.opacity(0.1))
//                    .frame(width: 50, height: 50)
//
//                Text(String(group.name.prefix(1)).uppercased())
//                    .font(.title2)
//                    .fontWeight(.bold)
//                    .foregroundColor(.blue)
//            }
//
//            // Group Info
//            VStack(alignment: .leading, spacing: 4) {
//                Text(group.name)
//                    .font(.headline)
//                    .foregroundColor(.primary)
//
//                HStack(spacing: 12) {
//                    Label("\(group.members.count)", systemImage: "person.2.fill")
//                    Label("\(group.expenses.count)", systemImage: "creditcard.fill")
//                }
//                .font(.caption)
//                .foregroundColor(.secondary)
//            }
//
//            Spacer()
//
//            // Chevron Arrow inside row
//            Image(systemName: "chevron.right")
//                .foregroundColor(.gray)
//                .font(.system(size: 14, weight: .semibold))
//        }
//        .padding()
//        .background(Color(.systemGray6))
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
//    }
//}
