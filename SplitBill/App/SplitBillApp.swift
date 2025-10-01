//
//  SplitBillApp.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct SplitBillApp: App {
    let container: ModelContainer

    init() {
        // Configure Firebase
        FirebaseApp.configure()

        // Create ModelContainer for SwiftData models
        self.container = try! ModelContainer(
            for: User.self, Group.self, Expense.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: false)
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(\.modelContext, container.mainContext)
                .environmentObject(AuthViewModel(context: container.mainContext))
                .environmentObject(GroupViewModel(context: container.mainContext))
                .environmentObject(GroupDetailsViewModel(context: container.mainContext))
                // Add other view models if needed
        }
    }
}
