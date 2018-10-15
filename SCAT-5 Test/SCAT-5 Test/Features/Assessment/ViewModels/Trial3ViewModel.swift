//
//  Trial3ViewModel.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

class Trial3ViewModel: TrialViewModel {
    var shouldUseWordList: Bool = false

    var shouldUseBalanceTest: Bool = true

    var shouldUseCalendarTest: Bool = true

    var trialInstruction: String? = "Do they remember the months in reverse?"

    var balanceString: String? = "Tandem Leg Stance"

    var trialNumber: Int = 3

    var nextTrialButtonString: String? = "NEXT"

    func getNextTrial() -> TrialViewModel? {
        return Trial4ViewModel()
    }

    func updateAssessment(_ assessment: inout SCAT5Test, wordList: [WordRecall]?, calendarRecall: Bool, balenceScore: Int) {
        assessment.trial3TandemLegErrors = balenceScore
        assessment.trial3MemoryScore = calendarRecall ? 1 : 0
    }
}
