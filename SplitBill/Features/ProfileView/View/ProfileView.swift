//
//  ProfileView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 8/18/25.
//
//
//  ProfileView.swift
//  SplitBill
//

//
//  ProfileView.swift
//  SplitBill
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    
    private var currentUser: User? { authViewModel.currentUser }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 20) {
                
                // MARK: - Profile Header
                VStack(spacing: 12) {
                    profileImageView
                    
                    Text(currentUser?.name ?? "User Name")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if let email = currentUser?.email {
                        Text(email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    if let phone = currentUser?.phoneNumber, !phone.isEmpty {
                        Text(phone)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 40)
                .padding(.horizontal)
                
                Divider()
                    .padding(.vertical, 8)
                
                // MARK: - Account & Settings Rows
                VStack(spacing: 1) {
                    profileRow(title: "Full Name", value: currentUser?.name ?? "")
                    profileRow(title: "Email", value: currentUser?.email ?? "")
                    profileRow(title: "Phone Number", value: currentUser?.phoneNumber ?? "")
                    profileRow(title: "Change Password") {
                        // Change password action
                    }
                    profileRow(title: "App Version", value: "v 3.0.13") // Example
                }
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
                
                // MARK: - Logout
                Button(action: { authViewModel.signOut() }) {
                    HStack {
                        Image(systemName: "arrow.backward.square")
                        Text("Log Out")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.bottom, 30)
                
            }
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.blue)
                    .padding()
            }
        }
    }
    
    // MARK: - Profile Image
    private var profileImageView: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.15))
                .frame(width: 100, height: 100)
            
            Text(initials(from: currentUser?.name ?? ""))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - Profile Row
    private func profileRow(title: String, value: String? = nil, icon: String? = nil, action: (() -> Void)? = nil) -> some View {
        Button(action: { action?() }) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                        .frame(width: 24)
                }
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                if let value = value {
                    Text(value)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
                if action != nil {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Initials
    private func initials(from name: String) -> String {
        let components = name.split(separator: " ")
        let first = components.first?.first.map { String($0) } ?? ""
        let last = components.dropFirst().first?.first.map { String($0) } ?? ""
        return (first + last).uppercased()
    }
}

#Preview {
    ProfileView()
}

