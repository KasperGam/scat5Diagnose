//
//  SCAT5Test.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

public typealias WordList = [String]

protocol SCAT5Test {
    var playerID: String? { get set }
    var testDate: Date? { get set }
    var testID: String? { get set }
    var trainerID: String? { get set }
    var trial1DoubleLegErrors: Int? { get set }
    var trial2MemoryScore: Int? { get set }
    var trial2SingleLegErrors: Int? { get set }
    var trial3MemoryScore: Int? { get set }
    var trial3TandemLegErrors: Int? { get set }
    var trial4MemoryScore: Int? { get set }
    var memoryListUsed: WordList? { get set }
    var symptoms: [Symptom] { get set }
    var trialWordRecall: [Int: [WordRecall]] { get set }
}

// MARK: - Wordlists

public let wordList1: WordList = ["Elbow", "Apple", "Carpet", "Saddle", "Bubble"]
public let wordList2: WordList = ["Candle", "Paper", "Sugar", "Sandwich", "Wagon"]
public let wordList3: WordList = ["Baby", "Monkey", "Perfume", "Sunset", "Iron"]
public let wordList4: WordList = ["Finger", "Penny", "Blanket", "Lemon", "Insect"]

struct WordRecall: Codable {
    var word: String
    var recalled: Bool

    static func getNewRecallList(from wordList: WordList) -> [WordRecall] {
        var retVal: [WordRecall] = []
        for word in wordList {
            retVal.append(WordRecall(word: word, recalled: false))
        }
        return retVal
    }
}

extension Array where Element == WordRecall {
    var memoryScore: Int {
        return self.filter{ return $0.recalled }.count
    }
}

class SCAT5Flyweight: SCAT5Test, Codable {

    var playerID: String?
    var testDate: Date?
    var testID: String?
    var trainerID: String?
    var trial1DoubleLegErrors: Int?
    var trial2MemoryScore: Int?
    var trial2SingleLegErrors: Int?
    var trial3MemoryScore: Int?
    var trial3TandemLegErrors: Int?
    var trial4MemoryScore: Int?
    var memoryListUsed: WordList?
    var symptoms: [Symptom] = []
    var trialWordRecall: [Int : [WordRecall]] = [:]

    init() {}

}
