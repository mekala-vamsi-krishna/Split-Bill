//
//  CreateGroupView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//
import SwiftUI
import FirebaseFirestore
import PhotosUI

struct CreateGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var groupName = ""
    @State private var selectedMembers: [User] = []
    @State private var searchText = ""
    @State private var searchResults: [User] = []
    @State private var isSearching = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // MARK: - Group Name
                    TextField("Enter group name", text: $groupName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // MARK: - Member Search
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add Members by Email")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        TextField("Search by email", text: $searchText)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .onChange(of: searchText) { newValue in
                                searchUsers(by: newValue)
                            }
                        
                        if isSearching {
                            ProgressView("Searching...")
                                .padding(.horizontal)
                        } else if searchResults.isEmpty && !searchText.isEmpty {
                            Text("No matches found")
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                        
                        ForEach(searchResults) { user in
                            Button {
                                toggleUser(user)
                            } label: {
                                HStack {
                                    Image(systemName: selectedMembers.contains(where: { $0.id == user.id }) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.blue)
                                    VStack(alignment: .leading) {
                                        Text(user.name)
                                        Text(user.email ?? "")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Create Group")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        var membersToCreate = selectedMembers
                        if let me = authViewModel.currentUser, !membersToCreate.contains(where: { $0.id == me.id }) {
                            membersToCreate.append(me)
                        }
                        groupViewModel.createGroup(name: groupName, members: membersToCreate)
                        dismiss()
                    }
                    .disabled(groupName.trimmingCharacters(in: .whitespaces).isEmpty || selectedMembers.isEmpty)
                }
            }
        }
    }
    
    private func toggleUser(_ user: User) {
        if let index = selectedMembers.firstIndex(where: { $0.id == user.id }) {
            selectedMembers.remove(at: index)
        } else {
            selectedMembers.append(user)
        }
    }
    
    // MARK: - Firebase search
    private func searchUsers(by email: String) {
        guard !email.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        let db = Firestore.firestore()
        
        Task {
            do {
                let snapshot = try await db.collection("users")
                    .whereField("email", isEqualTo: email.lowercased())
                    .getDocuments()
                
                isSearching = false
                
                if snapshot.documents.isEmpty {
                    searchResults = []
                } else {
                    searchResults = snapshot.documents.compactMap { doc in
                        let data = doc.data()
                        guard let name = data["name"] as? String,
                              let phone = data["phone"] as? String else { return nil }
                        let uid = data["uid"] as? String
                        let email = data["email"] as? String
                        return User(name: name, phoneNumber: phone, uid: uid, email: email)
                    }
                }
            } catch {
                print("Error searching users:", error.localizedDescription)
                isSearching = false
                searchResults = []
            }
        }
    }
}

#Preview {
    CreateGroupView()
}
