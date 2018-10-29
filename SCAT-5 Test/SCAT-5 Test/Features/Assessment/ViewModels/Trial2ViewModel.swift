//
//  Trial2ViewModel.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

class Trial2ViewModel: TrialViewModel {
    var showCountdown: Bool?

    var countDownValue: Int?

    var shouldUseWordList: Bool = true

    var shouldUseBalanceTest: Bool = true

    var shouldUseCalendarTest: Bool = false

    var trialInstruction: String? = "What words do they remember?"

    var balanceString: String? = "Single Leg Stance"

    var trialNumber: Int = 2

    var nextTrialButtonString: String? = "NEXT"

    func getNextTrial() -> TrialViewModel? {
        return Trial3ViewModel()
    }

    func getPreviousTrial() -> TrialViewModel? {
        return Trial1ViewModel()
    }

    func updateAssessment(_ assessment: inout SCAT5Test, wordList: [WordRecall]?, calendarRecall: Bool, balenceScore: Int) {
        if let list = wordList {
            assessment.trial2MemoryScore = list.memoryScore
            assessment.trialWordRecall[trialNumber] = wordList
        }
        assessment.trial2SingleLegErrors = balenceScore
    }

    func balenceErrors(from assessment: SCAT5Test?) -> Int {
        return assessment?.trial2SingleLegErrors ?? 0
    }



}
