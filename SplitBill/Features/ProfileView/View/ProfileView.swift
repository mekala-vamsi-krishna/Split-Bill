//
//  ProfileView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 8/18/25.
//

import SwiftUI

struct ProfileRow: View {
    var icon: String
    var title: String
    var detailsLabel: String?
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color.blue.opacity(0.15))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(.blue)
                )
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .padding(.leading, 6)
            
            Spacer()
            
            Text(detailsLabel ?? "")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .frame(height: 30) // Cell Height
        .padding(.vertical, 4)
    }
}

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var groupdetailsViewModel: GroupDetailsViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            ZStack(alignment: .topLeading) {
                Color.blue
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 200)
                
                VStack {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.title2)
                                .padding()
                        }
                        Spacer()
                    }
                    
                    VStack(spacing: 12) {
                        // Profile Circle with edit
                        ZStack {
                            // Outer dotted stroke
                            Circle()
                                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
                                .foregroundColor(.white)
                                .frame(width: 90, height: 90)
                            
                            // Inner filled circle with initials (always centered)
                            Circle()
                                .fill(Color.white)
                                .frame(width: 80, height: 80)
                                .overlay(
                                    Text("MVK")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.blue)
                                )
                            
                            // Camera button aligned bottom-right
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Circle()
                                        .stroke(Color.white, lineWidth: 1.5)
                                        .fill(Color.blue)
                                        .frame(width: 25, height: 25)
                                        .overlay(
                                            Image(systemName: "camera")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(.white)
                                                .padding(5)
                                        )
                                }
                            }
                            .frame(width: 90, height: 90) // match outer stroke size
                            .offset(x: -6, y: -6) // slight offset so it hugs border
                        }
                        .frame(width: 90, height: 90)

                        
                        Text("Mekala Vamsi Krishna")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                }
            }
            
            // Menu items
            List {
                Section {
                    ProfileRow(icon: "person.crop.circle", title: "Profile Info")
                    ProfileRow(icon: "phone", title: "Contact Support")
                    ProfileRow(icon: "lock", title: "Privacy Policy")
                    ProfileRow(icon: "info.circle", title: "About", detailsLabel: "v 3.0.13.15572")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .scrollContentBackground(.hidden) // cleaner background
            .background(Color(.systemGroupedBackground))
            
            Spacer()
            
            // Logout button
            Button(action: {
                authViewModel.isAuthenticated = false
                authViewModel.isOTPSent = false
                authViewModel.phoneNumber = ""
                authViewModel.otp = ""
            }) {
                Text("Log Out")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.red)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.red, lineWidth: 2)
                    )
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    ProfileView()
}

