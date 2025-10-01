//
//  AuthViewModel.swift
//  SplitBill
//
//  Created by Mekala Vamsi Krishna on 7/6/25.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SwiftData

@MainActor
class AuthViewModel: ObservableObject {
    // input fields (views bind here)
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var name: String = ""
    @Published var phoneNumber: String = ""

    // app-state
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    @Published var currentUser: User? = nil

    private let context: ModelContext
    private let db = Firestore.firestore()
    private var handle: AuthStateDidChangeListenerHandle?

    init(context: ModelContext) {
        self.context = context
        // observe auth changes
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, firebaseUser in
            Task { await self?.authStateChanged(firebaseUser) }
        }
    }

    deinit {
        if let h = handle {
            Auth.auth().removeStateDidChangeListener(h)
        }
    }

    // MARK: - Auth actions

    func register() async throws {
        // create Firebase Auth user
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        let uid = result.user.uid

        // create user doc in Firestore
        let payload: [String: Any] = [
            "uid": uid,
            "name": name,
            "email": email,
            "phone": phoneNumber,
            "createdAt": FieldValue.serverTimestamp()
        ]
        try await db.collection("users").document(uid).setData(payload, merge: true)

        // fetch local profile
        await fetchOrCreateLocalUser(uid: uid)
    }

    func login() async throws {
        _ = try await Auth.auth().signIn(withEmail: email, password: password)
        // auth state listener will call fetchOrCreateLocalUser
    }

    func resetPassword() async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUser = nil
        } catch {
            print("Sign out failed:", error)
        }
    }

    // MARK: - helper to sync Firestore user -> local SwiftData user

    private func authStateChanged(_ firebaseUser: FirebaseAuth.User?) async {
        if let fUser = firebaseUser {
            isAuthenticated = true
            await fetchOrCreateLocalUser(uid: fUser.uid)
        } else {
            isAuthenticated = false
            currentUser = nil
        }
    }

    private func fetchOrCreateLocalUser(uid: String) async {
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            guard let data = snapshot.data() else {
                print("No user doc for uid \(uid)")
                return
            }
            let name = data["name"] as? String ?? "User"
            let email = data["email"] as? String
            let phone = data["phone"] as? String ?? ""

            // See if local SwiftData User exists with this uid
            let fetch = try context.fetch(FetchDescriptor<User>())
            if let local = fetch.first(where: { $0.uid == uid }) {
                // update fields if needed
                local.name = name
                local.email = email
                local.phoneNumber = phone
                currentUser = local
            } else {
                // create local user and save
                let user = User(name: name, phoneNumber: phone, uid: uid, email: email)
                context.insert(user)
                try? context.save()
                currentUser = user
            }
        } catch {
            print("fetchOrCreateLocalUser error:", error)
        }
    }
    
    func searchUser(byEmail email: String) async throws -> [User] {
        let snapshot = try await db.collection("users")
            .whereField("email", isEqualTo: email.lowercased())
            .getDocuments()
        
        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            return User(
                name: data["name"] as? String ?? "",
                phoneNumber: data["phone"] as? String ?? "",
                uid: data["uid"] as? String,
                email: data["email"] as? String
            )
        }
    }

}
