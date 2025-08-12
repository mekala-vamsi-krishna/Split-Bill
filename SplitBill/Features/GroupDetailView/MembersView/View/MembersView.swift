//
//  MembersView.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/7/25.
//

import SwiftUI

import SwiftUI
import SwiftData

struct MembersView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var groupViewModel: GroupViewModel
    @State private var newName: String = ""
    @State private var newPhone: String = ""
    @State private var showForm: Bool = false

    var group: Group

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if group.members.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.gray.opacity(0.6))

                        Text("No Members Yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 80)
                } else {
                    List {
                        ForEach(group.members) { member in
                            HStack {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.blue.opacity(0.8))

                                VStack(alignment: .leading) {
                                    Text(member.name)
                                        .font(.headline)
                                    Text(member.phoneNumber)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(.plain)
                }

                if showForm {
                    VStack(spacing: 12) {
                        TextField("Name", text: $newName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        TextField("Phone Number", text: $newPhone)
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button(action: {
                            if !newName.trimmingCharacters(in: .whitespaces).isEmpty &&
                                !newPhone.trimmingCharacters(in: .whitespaces).isEmpty {
                                groupViewModel.addMember(to: group, name: newName, phoneNumber: newPhone)
                                newName = ""
                                newPhone = ""
                                showForm = false
                            }
                        }) {
                            Text("Add Member")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 44)
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        .disabled(newName.isEmpty || newPhone.isEmpty)
                    }
                    .padding(.horizontal)
                }

                Button(action: {
                    withAnimation {
                        showForm.toggle()
                    }
                }) {
                    Label(showForm ? "Cancel" : "Add Member", systemImage: showForm ? "xmark.circle" : "plus.circle")
                        .font(.headline)
                        .foregroundColor(showForm ? .red : .blue)
                        .padding(.top)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Group Members")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


#Preview {
    // Setup a mock in-memory SwiftData container
    let container = try! ModelContainer(for: Group.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext
    let sampleGroup = Group(name: "Trip Buddies")
    let mockGroupViewModel = GroupViewModel(context: context)

    return MembersView(group: sampleGroup)
        .environmentObject(mockGroupViewModel)
}
