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
    var duration: Int? { get set }
}

extension SCAT5Test {
    mutating func update(with model: SCAT5Test) {
        playerID = model.playerID ?? playerID
        testDate = model.testDate ?? testDate
        testID = model.testID ?? testID
        trainerID = model.trainerID ?? trainerID
        trial1DoubleLegErrors = model.trial1DoubleLegErrors ?? trial1DoubleLegErrors
        trial2MemoryScore = model.trial2MemoryScore ?? trial2MemoryScore
        trial2SingleLegErrors = model.trial2SingleLegErrors ?? trial2SingleLegErrors
        trial3TandemLegErrors = model.trial3TandemLegErrors ?? trial3TandemLegErrors
        trial3MemoryScore = model.trial3MemoryScore ?? trial3MemoryScore
        trial4MemoryScore = model.trial4MemoryScore ?? trial4MemoryScore
        memoryListUsed = model.memoryListUsed ?? memoryListUsed
        symptoms = model.symptoms.isEmpty ? model.symptoms : symptoms
        trialWordRecall = model.trialWordRecall.isEmpty ? model.trialWordRecall : trialWordRecall
        duration = model.duration ?? duration
    }
}

// MARK: - Wordlists
struct WordLists {
    static func getRandomList() -> WordList {
        var newList: WordList = []
        guard let manager = try? Container.resolve(DataManager.self) else {
            return []
        }

        var words = manager.testWords
        var count = 0
        while count < 5 && words.count > 0 {
            if let newWord = words.randomElement() {
                newList.append(newWord)
                count += 1
                words.remove(at: words.firstIndex(of: newWord)!)
            } else {
                break
            }
        }
        return newList
    }

    static func listString(for wordList: WordList) -> String {
        var retStr = ""
        for i in 0..<wordList.count {
            retStr += wordList[i]
            if i != wordList.count - 1 {
                retStr += ", "
            }
        }
        return retStr
    }
}

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
    var duration: Int?
    var memoryListUsed: WordList?
    var symptoms: [Symptom] = []
    var trialWordRecall: [Int : [WordRecall]] = [:]

    enum CodingKeys: String, CodingKey {
        case playerID
        case testDate
        case testID
        case trainerID
        case trial1DoubleLegErrors
        case trial2MemoryScore
        case trial2SingleLegErrors
        case trial3MemoryScore
        case trial3TandemLegErrors
        case trial4MemoryScore
        case duration = "secondsToTest"
    }

    init() {}

    required init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        playerID = try container.decodeIfPresent(String.self, forKey: .playerID)
        if let dateStr = try container.decodeIfPresent(String.self, forKey: .testDate) {
            testDate = Date(fromMMddYYYYHHmma: dateStr)
        }
        testID = try container.decodeIfPresent(String.self, forKey: .testID)
        trainerID = try container.decodeIfPresent(String.self, forKey: .trainerID)
        trial1DoubleLegErrors = try container.decodeIfPresent(Int.self, forKey: .trial1DoubleLegErrors)
        trial2MemoryScore = try container.decodeIfPresent(Int.self, forKey: .trial2MemoryScore)
        trial2SingleLegErrors = try container.decodeIfPresent(Int.self, forKey: .trial2SingleLegErrors)
        trial3MemoryScore = try container.decodeIfPresent(Int.self, forKey: .trial3MemoryScore)
        trial3TandemLegErrors = try container.decodeIfPresent(Int.self, forKey: .trial3TandemLegErrors)
        trial4MemoryScore = try container.decodeIfPresent(Int.self, forKey: .trial4MemoryScore)
        duration = try container.decodeIfPresent(Int.self, forKey: .duration)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(playerID, forKey: .playerID)
        try container.encodeIfPresent(testID, forKey: .testID)
        try container.encodeIfPresent(trainerID, forKey: .trainerID)
        try container.encodeIfPresent(trial1DoubleLegErrors, forKey: .trial1DoubleLegErrors)
        try container.encodeIfPresent(trial2MemoryScore, forKey: .trial2MemoryScore)
        try container.encodeIfPresent(trial2SingleLegErrors, forKey: .trial2SingleLegErrors)
        try container.encodeIfPresent(trial3MemoryScore, forKey: .trial3MemoryScore)
        try container.encodeIfPresent(trial3TandemLegErrors, forKey: .trial3TandemLegErrors)
        try container.encodeIfPresent(trial4MemoryScore, forKey: .trial4MemoryScore)
        try container.encodeIfPresent(testDate?.getMMddYYYYHHmma(), forKey: .testDate)
        try container.encodeIfPresent(duration, forKey: .duration)
    }

}
