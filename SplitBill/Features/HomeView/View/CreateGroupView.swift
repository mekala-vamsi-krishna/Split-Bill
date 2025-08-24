//
//  CreateGroupView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//
import SwiftUI
import PhotosUI

struct CreateGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var groupViewModel: GroupViewModel
    
    @State private var groupName = ""
    @State private var selectedMembers: [User] = []
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var groupImage: UIImage? = nil
    
    // Dummy users (simulate existing accounts)
    let allUsers: [User] = [
        User(name: "Alice", phoneNumber: "1234567890"),
        User(name: "Bob", phoneNumber: "9876543210"),
        User(name: "Charlie", phoneNumber: "5556667777"),
        User(name: "David", phoneNumber: "9998887777")
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // MARK: - Group Image
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let image = groupImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.gray.opacity(0.5), lineWidth: 1))
                                .shadow(radius: 4)
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color.gray.opacity(0.1))
                                    .frame(width: 100, height: 100)
                                Image(systemName: "photo.on.rectangle.angled")
                                    .font(.system(size: 30))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onChange(of: selectedPhoto) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                groupImage = uiImage
                            }
                        }
                    }
                    
                    // MARK: - Group Name
                    TextField("Enter group name", text: $groupName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .padding(.horizontal)
                    
                    // MARK: - Member Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Select Members")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(allUsers) { user in
                            Button {
                                toggleUser(user)
                            } label: {
                                HStack {
                                    Image(systemName: selectedMembers.contains(where: { $0.id == user.id }) ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.blue)
                                    VStack(alignment: .leading) {
                                        Text(user.name)
                                        Text(user.phoneNumber)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                            .buttonStyle(.plain)
                            .padding(.horizontal)
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
                        groupViewModel.createGroup(name: groupName, members: selectedMembers)
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
}

#Preview {
    CreateGroupView()
}
