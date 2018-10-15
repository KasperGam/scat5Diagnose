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


