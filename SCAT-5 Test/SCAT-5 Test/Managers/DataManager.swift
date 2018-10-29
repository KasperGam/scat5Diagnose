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
import FirebaseStorage

class DataManager {

    let MAX_SIZE: Int64 = 4 * 1024 * 1024

    var currentUser: SCAT5User?

    var currentTest: SCAT5Test?

    var testWords: [String] = []

    private let root = Database.database().reference()

    private var db = Firestore.firestore()

    private let cloudStoreRoot = Storage.storage(url: "gs://scat5diagnose.appspot.com").reference()

    private let decoder = FirebaseDecoder()
    private let encoder = FirebaseEncoder()

    private let firestoreDecoder = FirestoreDecoder()
    private let firestoreEncoder = FirestoreEncoder()

    init() {
        encoder.dateEncodingStrategy = .formatted(Date.formatterForMMddYYYYHHmma)
        db.settings.areTimestampsInSnapshotsEnabled = true
    }

}


// MARK: - Save User Functions
extension DataManager {

    func loginUser(user: User, completion: @escaping (Bool) -> Void) {

        let ref = self.root.child("Trainer").child(user.uid)

        ref.observe(.value) { [weak self] (snapshot) in
            guard let value = snapshot.value else { completion(false); return }
            guard let decodedUser = try? self?.decoder.decode(SCAT5UserFlyweight.self, from: value) else { completion(false); return }
            decodedUser?.firebaseUser = user
            self?.currentUser = decodedUser
            completion(true)
        }
    }

    func registerUser(user: SCAT5User) -> Bool {
        var userFlyweight = SCAT5UserFlyweight()
        userFlyweight.update(with: user)

        guard let firebaseUser = user.firebaseUser else { return false }
        let ref = self.root.child("Trainer").child(firebaseUser.uid)

        guard let encodedUser = try? encoder.encode(userFlyweight) else { return false }

        ref.setValue(encodedUser)
        self.currentUser = user
        return true
    }

    func updateCurrentUser(with user: SCAT5User?) -> Bool {
        guard let user = user else { return false }

        var userFlyweight = SCAT5UserFlyweight()
        userFlyweight.update(with: user)

        guard let firebaseUser = user.firebaseUser else { return false }
        let ref = self.root.child("Trainer").child(firebaseUser.uid)

        guard let encodedUser = try? encoder.encode(userFlyweight) else { return false }

        ref.setValue(encodedUser)
        self.currentUser = user

        return true
    }

}

// MARK: - Athletes Functions

extension DataManager {
    func getAthletes(completion: @escaping ([SCAT5Athlete]) -> Void) {
        let ref = db.collection("Athlete")
        ref.getDocuments{ [weak self] (snapshot, error) in
            guard
                error == nil,
                let snapshot = snapshot,
                !snapshot.isEmpty,
                let strongSelf = self
            else {
                completion([])
                return
            }
            var athletes: [SCAT5AthleteFlyweight] = []
            for document in snapshot.documents {
                if let athlete = try? strongSelf.firestoreDecoder.decode(SCAT5AthleteFlyweight.self, from: document.data()) {
                    athlete.id = document.documentID
                    self?.getAthletePicture(athlete)
                    athletes.append(athlete)
                }
            }
            athletes = athletes.sorted { (lhs, rhs) in
                guard
                    let name1 = lhs.name,
                    let name2 = rhs.name
                else {
                    return true
                }
                return name1.compare(name2) == ComparisonResult.orderedAscending
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

    func getAthletePicture(_ athlete: SCAT5AthleteFlyweight, completion: @escaping (UIImage?) -> Void = {(_) in}) {
        let reference = cloudStoreRoot.child("georgiatech").child(athlete.imageName())
        reference.getData(maxSize: MAX_SIZE) { (data, error) in
            guard
                let data = data,
                error == nil
            else {
                completion(nil)
                return
            }
            athlete.profileImage = UIImage(data: data)
            completion(UIImage(data: data))
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

// MARK: - Word Lists
extension DataManager {
    func refreshWordLists() {
        let ref = db.collection("TestWords")
        ref.getDocuments { [weak self] (snapshot, error) in
            var words: [String] = []
            guard
                let documents = snapshot?.documents,
                error == nil
            else {
                return
            }
            for document in documents {
                if let word = document.data()["word"] as? String {
                    words.append(word)
                }
            }
            self?.testWords = words
        }
    }
}
