//
//  HomeView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import SwiftUI
import SwiftData

struct ProfileIconView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue)
                .frame(maxWidth: 40, maxHeight: 40)
                .frame(width: 40, height: 40)
                .overlay(
                    Text("MR")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )
        }
    }
}

struct HomeView: View {
    @Environment(\.modelContext) var modelContext
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var groupViewModel: GroupViewModel
    @EnvironmentObject var groupdetailsViewModel: GroupDetailsViewModel
    
    @State private var showingCreateGroup = false
    @State private var showDeleteAlert = false
    @State private var showingProfile = false

    @State private var groupToDelete: Group?

    private func confirmDeleteGroup(at offsets: IndexSet) {
        if let index = offsets.first {
            groupToDelete = groupViewModel.groups[index]
            showDeleteAlert = true
        }
    }
    
    @State private var selectedGroup: Group? = nil
    @State private var isNavigating = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if groupViewModel.groups.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .foregroundColor(.gray.opacity(0.6))
                        
                        Text("No Groups Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Create your first group to start\nsplitting expenses")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    .padding(.top, 80)
                    
                    Spacer()
                } else {
                    // Groups List
                    List {
                        ForEach(groupViewModel.groups) { group in
                            NavigationLink(destination: GroupDetailView(group: group)) {
                                GroupRowView(group: group)
                                    .padding()
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    groupToDelete = group
                                    showDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 16))
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: confirmDeleteGroup)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Split Bill")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingProfile = true
                    } label: {
                        ProfileIconView()
                    }

                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingCreateGroup = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingCreateGroup) {
                CreateGroupView()
                    .environmentObject(groupViewModel)
            }
            .navigationDestination(item: $selectedGroup) { group in
                GroupDetailView(group: group)
                    .environmentObject(groupdetailsViewModel)
            }
            .fullScreenCover(isPresented: $showingProfile, content: {
                ProfileView()
            })
            .alert("Delete Group?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    if let group = groupToDelete {
                        groupViewModel.deleteGroup(group)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will delete the group and all its expenses permanently.")
            }

        }

    }
}


#Preview {
    let container = try! ModelContainer(for: Group.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    HomeView()
        .environment(\.modelContext, context)
        .environmentObject(GroupViewModel(context: context))
        .environmentObject(GroupDetailsViewModel(context: context))
        .environmentObject(AuthViewModel(context: context))
}
