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
