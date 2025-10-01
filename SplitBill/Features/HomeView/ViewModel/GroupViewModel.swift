//
//  GroupViewModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//
import Foundation
import SwiftData

@MainActor
class GroupViewModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var selectedGroup: Group?
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
        fetchGroups()
    }
    
    // MARK: - Group Management
    
    func createGroup(name: String, members: [User] = []) {
        let newGroup = Group(name: name, members: members, expenses: [])
        context.insert(newGroup)
        saveContext()
    }
    
    func deleteGroup(_ group: Group) {
        context.delete(group)
        saveContext()
    }
    
    func addMember(to group: Group, member: User) {
        context.insert(member)
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index].members.append(member)
        }
        saveContext()
    }
    
    func addMember(to group: Group, name: String, phoneNumber: String) {
        let newUser = User(name: name, phoneNumber: phoneNumber)
        addMember(to: group, member: newUser)
    }

    func removeMember(from group: Group, at offsets: IndexSet) {
        if let index = groups.firstIndex(where: { $0.id == group.id }) {
            groups[index].members.remove(atOffsets: offsets)
            saveContext()
        }
    }
    
    // MARK: - Fetching
    
    func fetchGroups() {
        do {
            groups = try context.fetch(FetchDescriptor<Group>())
        } catch {
            print("Failed to fetch groups:", error)
        }
    }
    
    // MARK: - Private
    
    private func saveContext() {
        do {
            try context.save()
            fetchGroups() // Refresh the published array to update UI
        } catch {
            print("Failed to save context:", error)
        }
    }
}
