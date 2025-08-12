//
//  LoginView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Logo & Title
            VStack(spacing: 12) {
                Image(systemName: "dollarsign.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                
                Text("Welcome to Split Bill")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Split expenses with friends easily")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)

            // Phone Number Input
            VStack(alignment: .leading, spacing: 6) {
                Text("Mobile Number")
                    .font(.headline)
                    .foregroundColor(.primary)

                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.gray)

                    TextField("Enter mobile number", text: $authViewModel.phoneNumber)
                        .keyboardType(.phonePad)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal)

            // Generate OTP Button
            Button(action: {
                authViewModel.sendOTP()
            }) {
                Text("Generate OTP")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(authViewModel.phoneNumber.count == 10 ? Color.blue : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: authViewModel.phoneNumber.count == 10 ? Color.blue.opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
            }
            .padding(.horizontal)
            .disabled(authViewModel.phoneNumber.count != 10)

            Spacer()
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
}


#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
