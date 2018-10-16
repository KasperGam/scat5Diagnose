//
//  DataManager.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore
import CodableFirebase

class DataManager {

    var currentUser: SCAT5User?

    var currentTest: SCAT5Test?

    let root = Database.database().reference()

    var db = Firestore.firestore()

    let decoder = FirebaseDecoder()
    let encoder = FirebaseEncoder()

    let firestoreDecoder = FirestoreDecoder()
    let firestoreEncoder = FirestoreEncoder()

    init() {
        encoder.dateEncodingStrategy = .iso8601
    }

}


// MARK: - Save User Functions
extension DataManager {

    func loginUser(user: User) {

        let ref = self.root.child("Trainer").child(user.uid)

        ref.observe(.value) { [weak self] (snapshot) in
            guard let value = snapshot.value else { return }
            guard let decodedUser = try? self?.decoder.decode(SCAT5UserFlyweight.self, from: value) else { return }
            decodedUser?.firebaseUser = user
            self?.currentUser = decodedUser
        }
    }

    func registerUser(user: SCAT5UserFlyweight) {

        guard let firebaseUser = user.firebaseUser else { return }
        let ref = self.root.child("Trainer").child(firebaseUser.uid)

        guard let encodedUser = try? encoder.encode(user) else { return }

        ref.setValue(encodedUser)
        self.currentUser = user
    }

    func updateCurrentUser(with user: SCAT5User?) {
        // TODO- Remove cast and just update new freewheel with user values
        guard let user = user as? SCAT5UserFlyweight else { return }

        guard let firebaseUser = user.firebaseUser else { return }
        let ref = self.root.child("Trainer").child(firebaseUser.uid)

        guard let encodedUser = try? encoder.encode(user) else { return }

        ref.setValue(encodedUser)
        self.currentUser = user
    }

}

// MARK: - Athletes Functions

extension DataManager {
    func getAthletes(completion: @escaping ([SCAT5Athlete]) -> Void) {
        let ref = db.collection("Athlete")
        ref.getDocuments{ (snapshot, error) in
            guard
                error == nil,
                let snapshot = snapshot,
                !snapshot.isEmpty
            else {
                completion([])
                return
            }
            var athletes: [SCAT5AthleteFlyweight] = []
            for document in snapshot.documents {
                if let athlete = try? FirestoreDecoder().decode(SCAT5AthleteFlyweight.self, from: document.data()) {
                    athlete.id = document.documentID
                    athletes.append(athlete)
                }
            }
            completion(athletes)
        }
    }
}

// MARK: - Save Assessment Functions

extension DataManager {

    func saveCurrentAssessment() {
        guard let test = currentTest else { return }
        // TODO - Save Test to Firebase

        currentTest = nil
    }

}
