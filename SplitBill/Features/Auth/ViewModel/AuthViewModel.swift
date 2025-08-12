//
//  AuthViewModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var otp: String = ""
    @Published var isOTPSent: Bool = false
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    @Published var currentUser: User?
    
    func sendOTP() {
        // Simulate OTP sending
        isOTPSent = true
        // In real app, integrate with SMS service
        print("OTP sent to \(phoneNumber)")
    }
    
    func verifyOTP() {
        // Simulate OTP verification
        if otp == "123456" { // Mock verification
            currentUser = User(name: "User", phoneNumber: phoneNumber)
            isAuthenticated = true
        }
    }
}
