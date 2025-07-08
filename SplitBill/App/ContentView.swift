//
//  ContentView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI
import SwiftData

// MARK: - Views
struct ContentView: View {
    @Environment(\.modelContext) private var context
    
    @State private var groupViewModel: GroupViewModel?
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        NavigationView {
            if let groupViewModel = groupViewModel {
                if authViewModel.isAuthenticated {
                    HomeView()
                        .environmentObject(authViewModel)
                } else if authViewModel.isOTPSent {
                    OTPView()
                        .environmentObject(authViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            if groupViewModel == nil {
                groupViewModel = GroupViewModel(context: context)
            }
        }
    }
}



#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
