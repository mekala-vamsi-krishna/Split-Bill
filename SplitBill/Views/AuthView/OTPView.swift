//
//  OTPView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI

struct OTPView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            // Header
            VStack(spacing: 10) {
                Image(systemName: "message.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                
                Text("Verify OTP")
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack(spacing: 2) {
                    Text("Enter the 6-digit code sent to")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("+91 \(authViewModel.phoneNumber)")
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal)

            // OTP Input Field
            VStack(alignment: .leading, spacing: 6) {
                Text("OTP")
                    .font(.headline)
                    .foregroundColor(.primary)

                TextField("123456", text: $authViewModel.otp)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(authViewModel.otp.count == 4 ? Color.green : Color.blue.opacity(0.6), lineWidth: 1)
                    )
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal)

            // Verify Button
            Button(action: {
                authViewModel.verifyOTP()
            }) {
                Text("Verify")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(authViewModel.otp.count == 6 ? Color.blue : Color.gray.opacity(0.4))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: authViewModel.otp.count == 6 ? Color.blue.opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
            }
            .padding(.horizontal)
            .disabled(authViewModel.otp.count != 6)

            // Resend OTP
            Button(action: {
                authViewModel.sendOTP()
            }) {
                Text("Resend OTP")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .background(.blue)
                    .cornerRadius(20)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 4)
            }
            .padding(.top, 8)

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
    }
}


#Preview {
    OTPView()
        .environmentObject(AuthViewModel())
}
