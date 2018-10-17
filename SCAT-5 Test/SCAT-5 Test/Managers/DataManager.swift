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
        encoder.dateEncodingStrategy = .formatted(Date.formatterForMMddYYYYHHmma)
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

    func registerUser(user: SCAT5User) {
        var userFlyweight = SCAT5UserFlyweight()
        userFlyweight.update(with: user)

        guard let firebaseUser = user.firebaseUser else { return }
        let ref = self.root.child("Trainer").child(firebaseUser.uid)

        guard let encodedUser = try? encoder.encode(userFlyweight) else { return }

        ref.setValue(encodedUser)
        self.currentUser = user
    }

    func updateCurrentUser(with user: SCAT5User?) {
        guard let user = user else { return }

        var userFlyweight = SCAT5UserFlyweight()
        userFlyweight.update(with: user)

        guard let firebaseUser = user.firebaseUser else { return }
        let ref = self.root.child("Trainer").child(firebaseUser.uid)

        guard let encodedUser = try? encoder.encode(userFlyweight) else { return }

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

    func addAthlete(athlete: SCAT5Athlete) {
        var athleteFlyweight = SCAT5AthleteFlyweight()
        athleteFlyweight.update(with: athlete)
        let ref = db.collection("Athlete")

        if let value = try? firestoreEncoder.encode(athleteFlyweight) {
            ref.addDocument(data: value)
        }
    }
}

// MARK: - Save Assessment Functions

extension DataManager {

    func saveCurrentAssessment() {
        guard var test = currentTest else { return }
        // TODO - Save Test to Firebase

        guard var id = test.playerID?.sha256() else { return }
        guard let trainerID = test.trainerID else { return }
        id = id.uppercased()
        test.playerID = id

        var ref = root.child("SymptomResult").child(id)
        let now = Date.currentTimeInCurrentTimeZone()

        let symptomResultID = ref.childByAutoId().key!
        let symptomResult = SCAT5SymptomResult(from: test.symptoms, playerID: id, trainerID: trainerID, testID: symptomResultID, testDate: now)

        if let value = try? encoder.encode(symptomResult) {
            ref.child(symptomResultID).setValue(value)
        }

        ref = root.child("TestResult").child(id)
        let testResultID = symptomResultID

        test.testDate = now
        test.testID = testResultID

        if let test = test as? SCAT5Flyweight,
            let value = try? encoder.encode(test) {

            ref.child(testResultID).setValue(value)
        }
        currentTest = nil
    }
}
