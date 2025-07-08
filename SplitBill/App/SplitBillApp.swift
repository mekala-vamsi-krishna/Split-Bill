//
//  SplitBillApp.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI
import SwiftData

@main
struct SplitBillApp: App {
    // 1. Define your schema correctly
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Group.self,
            User.self,
            Expense.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // 2. Pass mainContext to ViewModel
    @StateObject private var groupViewModel: GroupViewModel
    @StateObject private var createGroupViewModel: CreateGroupViewModel
    @StateObject private var groupDetailsViewModel = GroupDetailsViewModel()
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        let context = sharedModelContainer.mainContext
        _groupViewModel = StateObject(wrappedValue: GroupViewModel(context: context))
        _createGroupViewModel = StateObject(wrappedValue: CreateGroupViewModel(context: context))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(createGroupViewModel)
                .environmentObject(groupViewModel)
                .environmentObject(groupDetailsViewModel)
                .environment(\.modelContext, sharedModelContainer.mainContext) // ✅ Inject your own context
        }
    }
}

