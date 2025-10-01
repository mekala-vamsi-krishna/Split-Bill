//
//  AddMemberView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct AddMemberView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var authViewModel: AuthViewModel // <- for current user
    let group: Group
    
    @State private var searchText = ""
    @State private var searchResults: [User] = []
    @State private var isSearching = false
    
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Search Box
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
            
            // MARK: - Search Results
            if isSearching {
                ProgressView("Searching...")
                    .padding()
            } else if searchResults.isEmpty && !searchText.isEmpty {
                Text("No users found")
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(searchResults) { user in
                    Button {
                        groupViewModel.addMember(to: group, member: user)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.blue.opacity(0.7))
                            VStack(alignment: .leading) {
                                Text(user.name)
                                    .font(.headline)
                                Text(user.email ?? "")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                    // Disable if this is the current logged-in user
                    .disabled(user.uid == authViewModel.currentUser?.uid)
                    .foregroundColor(user.uid == authViewModel.currentUser?.uid ? .gray : .primary)
                }
                .listStyle(PlainListStyle())
            }
            
            Spacer()
        }
        .padding(.top)
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .navigationTitle("Add Member")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Firebase Email Search
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
                
                searchResults = snapshot.documents.compactMap { doc in
                    let data = doc.data()
                    guard let name = data["name"] as? String,
                          let uid = data["uid"] as? String else { return nil }
                    let email = data["email"] as? String
                    let phone = data["phone"] as? String
                    return User(name: name, phoneNumber: phone ?? "", uid: uid, email: email)
                }
            } catch {
                print("Error searching users:", error.localizedDescription)
                isSearching = false
                searchResults = []
            }
        }
    }
}


//#Preview {
//    let container = try! ModelContainer(for: Group.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
//    let context = container.mainContext
//    let mockGroupViewModel = GroupViewModel(context: context)
//    
//    NavigationStack {
//        AddMemberView(group: Group(name: "Roommates"))
//            .environmentObject(mockGroupViewModel)
//    }
//}
