//
//  TrialViewModel.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

protocol TrialViewModel {

    var shouldUseWordList: Bool { get set }
    var shouldUseBalanceTest: Bool { get set }
    var showCountdown: Bool? { get set }
    var countDownValue: Int? { get set }
    var shouldUseCalendarTest: Bool { get set }
    var trialInstruction: String? { get set }
    var balanceString: String? { get set }
    var balanceInstruction: String? { get set }
    var trialNumber: Int { get set }
    var nextTrialButtonString: String? { get set }

    func getNextTrial() -> TrialViewModel?
    func getPreviousTrial() -> TrialViewModel?

    func updateAssessment(_ assessment: inout SCAT5Test, wordList: [WordRecall]?, calendarRecall: Bool, balenceScore: Int)

    func balenceErrors(from assessment: SCAT5Test?) -> Int
    func calendarScore(from assessment: SCAT5Test?) -> Int
}

extension TrialViewModel {
    func balenceErrors(from assessment: SCAT5Test?) -> Int {
        return 0
    }

    func calendarScore(from assessment: SCAT5Test?) -> Int {
        return 0
    }
}
