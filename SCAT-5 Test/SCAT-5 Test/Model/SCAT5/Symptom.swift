//
//  Symptom.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

struct Symptom: Codable {
    var name: String
    var severity: Int
}

enum Symptoms: String, CaseIterable {
    case headache = "Headache"
    case pressureInHead = "Pressure In Head"
    case neckPain = "Neck Pain"
    case nauseaOrVomiting = "Nausea Or Vomiting"
    case dizziness = "Dizziness"
    case blurredVision = "Blurred Vision"
    case balanceProblems = "Balance Problems"
    case sensitivityToLight = "Sensitivity To light"
    case sensitivityToNoise = "Sensitivity To noise"
    case feelingSlowedDown = "Feeling slowed down"
    case feelingLikeInAFog = "Feeling like in a Fog"
    case dontFeelRight = "Don't feel right"
    case difficultyConcentrating = "Difficulty Concentrating"
    case difficultyRemembering = "Difficulty Remembering"
    case fatigue = "Fatigue or low energy"
    case confusion = "Confusion"
    case drowsiness = "Drowsiness"
    case moreEmotional = "More emotional"
    case irritability = "Irritability"
    case sadness = "Sadness"
    case nervous = "Nervous or Anxious"
    case troubleFallingAsleep = "Trouble falling asleep"

    static func getNewSymptomList() -> [Symptom] {
        var retVal: [Symptom] = []
        for symptom in Symptoms.allCases {
            retVal.append(Symptom(name: symptom.rawValue, severity: 0))
        }
        return retVal
    }
}

class SCAT5SymptomResult: Codable {
    var headache = 0
    var pressureInHead = 0
    var neckPain = 0
    var nauseaOrVomiting = 0
    var dizziness = 0
    var blurredVision = 0
    var balanceProblems = 0
    var sensitivityToLight = 0
    var sensitivityToNoise = 0
    var feelingSlowedDown = 0
    var feelingLikeInAFog = 0
    var dontFeelRight = 0
    var difficultyConcentrating = 0
    var difficultyRemembering = 0
    var fatigue = 0
    var confusion = 0
    var drowsiness = 0
    var moreEmotional = 0
    var irritability = 0
    var sadness = 0
    var nervous = 0
    var troubleFallingAsleep = 0

    var playerID: String
    var testDate: Date?
    var testID: String?
    var trainerID: String

    enum CodingKeys: String, CodingKey {
        case headache
        case pressureInHead
        case neckPain
        case nauseaOrVomiting
        case dizziness
        case blurredVision
        case balanceProblems
        case sensitivityToLight
        case sensitivityToNoise
        case feelingSlowedDown
        case feelingLikeInAFog
        case dontFeelRight
        case difficultyConcentrating
        case difficultyRemembering
        case fatigue
        case confusion
        case drowsiness
        case moreEmotional
        case irritability
        case sadness
        case nervous
        case troubleFallingAsleep
        case playerID
        case testDate
        case testID
        case trainerID
    }
    required init(from aDecoder: Decoder) throws {
        let container = try aDecoder.container(keyedBy: CodingKeys.self)
        headache = try container.decode(Int.self, forKey: .headache)
        pressureInHead = try container.decode(Int.self, forKey: .pressureInHead)
        neckPain = try container.decode(Int.self, forKey: .neckPain)
        nauseaOrVomiting = try container.decode(Int.self, forKey: .nauseaOrVomiting)
        dizziness = try container.decode(Int.self, forKey: .dizziness)
        blurredVision = try container.decode(Int.self, forKey: .blurredVision)
        balanceProblems = try container.decode(Int.self, forKey: .balanceProblems)
        sensitivityToLight = try container.decode(Int.self, forKey: .sensitivityToLight)
        sensitivityToNoise = try container.decode(Int.self, forKey: .sensitivityToNoise)
        feelingSlowedDown = try container.decode(Int.self, forKey: .feelingSlowedDown)
        feelingLikeInAFog = try container.decode(Int.self, forKey: .feelingLikeInAFog)
        dontFeelRight = try container.decode(Int.self, forKey: .dontFeelRight)
        difficultyConcentrating = try container.decode(Int.self, forKey: .difficultyConcentrating)
        difficultyRemembering = try container.decode(Int.self, forKey: .difficultyRemembering)
        fatigue = try container.decode(Int.self, forKey: .fatigue)
        confusion = try container.decode(Int.self, forKey: .confusion)
        drowsiness = try container.decode(Int.self, forKey: .drowsiness)
        moreEmotional = try container.decode(Int.self, forKey: .moreEmotional)
        irritability = try container.decode(Int.self, forKey: .irritability)
        sadness = try container.decode(Int.self, forKey: .sadness)
        nervous = try container.decode(Int.self, forKey: .nervous)
        troubleFallingAsleep = try container.decode(Int.self, forKey: .troubleFallingAsleep)
        playerID = try container.decode(String.self, forKey: .playerID)
        testID = try container.decodeIfPresent(String.self, forKey: .testID)
        trainerID = try container.decode(String.self, forKey: .trainerID)
        let dateStr = try container.decode(String.self, forKey: .testDate)
        testDate = Date.formatterForMMddYYYYHHmma.date(from: dateStr)
    }

    init(from symptoms: [Symptom], playerID: String, trainerID: String, testID: String? = nil, testDate: Date? = nil) {
        self.playerID = playerID
        self.trainerID = trainerID
        self.testID = testID
        self.testDate = testDate

        for symptom in symptoms {
            if let symptomVal = Symptoms(rawValue: symptom.name) {
                switch symptomVal {
                case .headache:
                    headache = symptom.severity
                case .pressureInHead:
                    pressureInHead = symptom.severity
                case .neckPain:
                    neckPain = symptom.severity
                case .nauseaOrVomiting:
                    nauseaOrVomiting = symptom.severity
                case .dizziness:
                    dizziness = symptom.severity
                case .blurredVision:
                    blurredVision = symptom.severity
                case .balanceProblems:
                    balanceProblems = symptom.severity
                case .sensitivityToLight:
                    sensitivityToLight = symptom.severity
                case .sensitivityToNoise:
                    sensitivityToNoise = symptom.severity
                case .feelingSlowedDown:
                    feelingSlowedDown = symptom.severity
                case .feelingLikeInAFog:
                    feelingLikeInAFog = symptom.severity
                case .dontFeelRight:
                    dontFeelRight = symptom.severity
                case .difficultyConcentrating:
                    difficultyConcentrating = symptom.severity
                case .difficultyRemembering:
                    difficultyConcentrating = symptom.severity
                case .fatigue:
                    fatigue = symptom.severity
                case .confusion:
                    confusion = symptom.severity
                case .drowsiness:
                    drowsiness = symptom.severity
                case .moreEmotional:
                    moreEmotional = symptom.severity
                case .irritability:
                    irritability = symptom.severity
                case .sadness:
                    sadness = symptom.severity
                case .nervous:
                    nervous = symptom.severity
                case .troubleFallingAsleep:
                    troubleFallingAsleep = symptom.severity
                }
            }
        }
    }
}

extension SCAT5SymptomResult {
    func getSymptoms() -> [Symptom] {
        var symptoms: [Symptom] = []
        symptoms.append(Symptom(name: Symptoms.headache.rawValue, severity: headache))
        symptoms.append(Symptom(name: Symptoms.pressureInHead.rawValue, severity: pressureInHead))
        symptoms.append(Symptom(name: Symptoms.neckPain.rawValue, severity: neckPain))
        symptoms.append(Symptom(name: Symptoms.nauseaOrVomiting.rawValue, severity: nauseaOrVomiting))
        symptoms.append(Symptom(name: Symptoms.dizziness.rawValue, severity: dizziness))
        symptoms.append(Symptom(name: Symptoms.blurredVision.rawValue, severity: blurredVision))
        symptoms.append(Symptom(name: Symptoms.balanceProblems.rawValue, severity: balanceProblems))
        symptoms.append(Symptom(name: Symptoms.sensitivityToLight.rawValue, severity: sensitivityToLight))
        symptoms.append(Symptom(name: Symptoms.sensitivityToNoise.rawValue, severity: sensitivityToNoise))
        symptoms.append(Symptom(name: Symptoms.feelingSlowedDown.rawValue, severity: feelingSlowedDown))
        symptoms.append(Symptom(name: Symptoms.feelingLikeInAFog.rawValue, severity: feelingLikeInAFog))
        symptoms.append(Symptom(name: Symptoms.dontFeelRight.rawValue, severity: dontFeelRight))
        symptoms.append(Symptom(name: Symptoms.difficultyConcentrating.rawValue, severity: difficultyConcentrating))
        symptoms.append(Symptom(name: Symptoms.difficultyRemembering.rawValue, severity: difficultyRemembering))
        symptoms.append(Symptom(name: Symptoms.fatigue.rawValue, severity: fatigue))
        symptoms.append(Symptom(name: Symptoms.confusion.rawValue, severity: confusion))
        symptoms.append(Symptom(name: Symptoms.drowsiness.rawValue, severity: drowsiness))
        symptoms.append(Symptom(name: Symptoms.moreEmotional.rawValue, severity: moreEmotional))
        symptoms.append(Symptom(name: Symptoms.irritability.rawValue, severity: irritability))
        symptoms.append(Symptom(name: Symptoms.sadness.rawValue, severity: sadness))
        symptoms.append(Symptom(name: Symptoms.nervous.rawValue, severity: nervous))
        symptoms.append(Symptom(name: Symptoms.troubleFallingAsleep.rawValue, severity: troubleFallingAsleep))
        return symptoms
    }
}
