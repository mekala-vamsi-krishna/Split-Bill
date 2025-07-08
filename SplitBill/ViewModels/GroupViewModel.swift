//
//  GroupViewModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import Foundation
import SwiftData

class GroupViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var selectedGroup: Group?
    
    private var context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        fetchGroups()
    }
    
    func createGroup(name: String) {
        let newGroup = Group(name: name, members: [], expenses: [])
        groups.append(newGroup)
    }
    
    func fetchGroups() {
        do {
            groups = try context.fetch(FetchDescriptor<Group>())
        } catch {
            print("Failed to fetch:", error)
        }
    }
    
    func addMember(to group: Group, member: User) {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index].members.append(member)
        }
    }
    
    func addMember(to group: Group, name: String, phoneNumber: String) {
        let newUser = User(name: name, phoneNumber: phoneNumber)
        group.members.append(newUser)
        context.insert(newUser)
        try? context.save()
    }
    
    func deleteGroup(_ group: Group) {
        context.delete(group)
        do {
            try context.save()
            fetchGroups()
        } catch {
            print("Failed to delete group:", error)
        }
    }
    
    
}
