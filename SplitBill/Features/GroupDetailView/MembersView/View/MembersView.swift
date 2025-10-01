//
//  MembersView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/7/25.
//

import SwiftUI
import SwiftData

struct MembersView: View {
    @EnvironmentObject var groupViewModel: GroupViewModel
    var group: Group
    @State private var showingAddMember = false

    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Members List
            if group.members.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.gray.opacity(0.5))

                    Text("No Members Yet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 60)
            } else {
                List {
                    ForEach(group.members) { member in
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.2))
                                    .frame(width: 40, height: 40)
                                Text(initials(from: member.name))
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(member.name)
                                    .font(.headline)
                                Text(member.email ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 6)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                if let index = group.members.firstIndex(where: { $0.id == member.id }) {
                                    groupViewModel.removeMember(from: group, at: IndexSet(integer: index))
                                }
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())

            }

            Spacer()
        }
        .navigationTitle("Members")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddMember = true
                } label: {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingAddMember) {
            AddMemberView(group: group)
                .environmentObject(groupViewModel)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    // MARK: - Initials Helper
    private func initials(from name: String) -> String {
        let components = name.split(separator: " ")
        let first = components.first?.first.map { String($0) } ?? ""
        let last = components.dropFirst().first?.first.map { String($0) } ?? ""
        return (first + last).uppercased()
    }
}

#Preview {
    let container = try! ModelContainer(for: Group.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    let sampleGroup = Group(name: "Trip Buddies")
    sampleGroup.members = [
        User(name: "John Doe", phoneNumber: "1234567890", uid: "1", email: "john@example.com"),
        User(name: "Alice Smith", phoneNumber: "0987654321", uid: "2", email: "alice@example.com")
    ]
    let mockGroupViewModel = GroupViewModel(context: context)

    return NavigationStack {
        MembersView(group: sampleGroup)
            .environmentObject(mockGroupViewModel)
    }
}
