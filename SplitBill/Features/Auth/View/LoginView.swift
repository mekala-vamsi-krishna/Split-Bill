//
//  LoginView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI

struct CustomTextField: View {
    var systemImage: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboard: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.gray)
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(keyboard)
            } else {
                TextField(placeholder, text: $text)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(keyboard)
            }
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
}


struct LoginView: View {
    @EnvironmentObject var auth: AuthViewModel
    @State private var isRegistering = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image(systemName: "dollarsign.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)

            Text(isRegistering ? "Create account" : "Welcome Back!")
                .font(.title)
                .fontWeight(.bold)

            if isRegistering {
                CustomTextField(
                    systemImage: "person.fill",
                    placeholder: "Full Name",
                    text: $auth.name
                )
            }

            CustomTextField(
                systemImage: "envelope.fill",
                placeholder: "Email",
                text: $auth.email,
                keyboard: .emailAddress
            )

            CustomTextField(
                systemImage: "lock.fill",
                placeholder: "Password",
                text: $auth.password,
                isSecure: true
            )
            
            if !isRegistering {
                HStack {
                    Spacer()
                    
                    Button("Forgot password?") {
                        Task {
                            do {
                                try await auth.resetPassword()
                                errorMessage = "Password reset email sent (if account exists)."
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .font(.caption)
                    .padding(.top, 6)
                }
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button(action: {
                Task {
                    do {
                        if isRegistering {
                            try await auth.register()
                        } else {
                            try await auth.login()
                        }
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text(isRegistering ? "Sign up" : "Sign in")
                    .font(.headline)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(.horizontal, 30)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
                    .background((isRegistering ? !auth.email.isEmpty && !auth.password.isEmpty && !auth.name.isEmpty
                                              : !auth.email.isEmpty && !auth.password.isEmpty) ? Color.blue : Color.gray)
                    .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 4)
                    .cornerRadius(20)
            }
            .disabled(isRegistering ? (auth.email.isEmpty || auth.password.isEmpty || auth.name.isEmpty) : (auth.email.isEmpty || auth.password.isEmpty))

            HStack {
                Text(isRegistering ? "Already have an account?" : "Don't have an account?")
                    .foregroundColor(.secondary)

                Button(action: {
                    withAnimation { isRegistering.toggle() }
                }) {
                    Text(isRegistering ? "Sign in" : "Sign up")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .font(.footnote)
            .padding(.top, 8)

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}


//#Preview {
//    LoginView()
//        .environmentObject(AuthViewModel())
//}
