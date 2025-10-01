//
//  ContentView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

// RootView.swift
import SwiftUI

struct RootView: View {
    @EnvironmentObject var auth: AuthViewModel

    var body: some View {
        ZStack {
            if auth.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
        .animation(.easeInOut, value: auth.isAuthenticated)
    }
}

#Preview {
    RootView()
}
