//
//  Trial4ViewModel.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

class Trial4ViewModel: TrialViewModel {
    var shouldUseWordList: Bool = true

    var shouldUseBalanceTest: Bool = false

    var shouldUseCalendarTest: Bool = false

    var trialInstruction: String? = "Which words do they still remember?"

    var balanceString: String?

    var trialNumber: Int = 4

    var nextTrialButtonString: String? = "FINISH ASSESSMENT"

    func getNextTrial() -> TrialViewModel? {
        return nil
    }

    func getPreviousTrial() -> TrialViewModel? {
        return Trial3ViewModel()
    }

    func updateAssessment(_ assessment: inout SCAT5Test, wordList: [WordRecall]?, calendarRecall: Bool, balenceScore: Int) {
        if let list = wordList {
            assessment.trial4MemoryScore = list.memoryScore
            assessment.trialWordRecall[trialNumber] = wordList
        }
    }
}
