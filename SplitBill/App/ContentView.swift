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
    
    let container: ModelContainer
    
    @Environment(\.modelContext) private var context
    
    @State private var groupViewModel: GroupViewModel?
    
    @StateObject private var authViewModel = AuthViewModel()
    
    @StateObject private var createGroupViewModel: CreateGroupViewModel

    init() {
        let container = try! ModelContainer(for: Group.self, User.self)
        _createGroupViewModel = StateObject(
            wrappedValue: CreateGroupViewModel(context: container.mainContext)
        )
        self.container = container
    }


    var body: some View {
        NavigationView {
            if let groupViewModel = groupViewModel {
                if authViewModel.isAuthenticated {
                    HomeView()
                        .environmentObject(authViewModel)
                        .environmentObject(createGroupViewModel)
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
}
