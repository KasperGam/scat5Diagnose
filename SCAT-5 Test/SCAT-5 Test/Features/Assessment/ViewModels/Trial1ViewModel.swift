//
//  Trial1ViewModel.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

class Trial1ViewModel: TrialViewModel {

    var showCountdown: Bool? = true

    var countDownValue: Int? = 60

    var shouldUseWordList: Bool = false
    
    var shouldUseBalanceTest: Bool = true
    
    var shouldUseCalendarTest: Bool = false
    
    var trialInstruction: String? = "User is being presented with 5 words. Monitor their balance! They have 1 minute to memorize the following: {current_word_list}."
    
    var balanceString: String? = "Double Leg Stance"
    
    var trialNumber: Int = 1
    
    var nextTrialButtonString: String? = "NEXT"
    
    func getNextTrial() -> TrialViewModel? {
        return Trial2ViewModel()
    }

    func getPreviousTrial() -> TrialViewModel? {
        return nil
    }
    
    func updateAssessment(_ assessment: inout SCAT5Test, wordList: [WordRecall]?, calendarRecall: Bool, balenceScore: Int) {
        assessment.trial1DoubleLegErrors = balenceScore
    }

    func balenceErrors(from assessment: SCAT5Test?) -> Int {
        return assessment?.trial1DoubleLegErrors ?? 0
    }

}
