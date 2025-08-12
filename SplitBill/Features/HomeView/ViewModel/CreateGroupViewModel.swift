//
//  CreateGroupViewModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/7/25.
//

import Foundation
import SwiftData

class CreateGroupViewModel: ObservableObject {
    @Published var groups: [Group] = []
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func createGroup(name: String, members: [User] = []) {
        let newGroup = Group(name: name, members: members)
        context.insert(newGroup)
        do {
            try context.save()
            fetchGroups()
        } catch {
            print("Failed to save group:", error)
        }
    }
    
    func fetchGroups() {
        do {
            groups = try context.fetch(FetchDescriptor<Group>())
        } catch {
            print("Failed to fetch:", error)
        }
    }
}
