//
//  Trial1ViewModel.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import Foundation

class Trial1ViewModel: TrialViewModel {

    var shouldUseWordList: Bool = false
    
    var shouldUseBalanceTest: Bool = true
    
    var shouldUseCalendarTest: Bool = false
    
    var trialInstruction: String? = "User is being presented with 5 words. Monitor their balance!"
    
    var balanceString: String? = "Double Leg Stance"
    
    var trialNumber: Int = 1
    
    var nextTrialButtonString: String? = "NEXT"
    
    func getNextTrial() -> TrialViewModel? {
        return Trial2ViewModel()
    }
    
    func updateAssessment(_ assessment: inout SCAT5Test, wordList: [WordRecall]?, calendarRecall: Bool, balenceScore: Int) {
        assessment.trial1DoubleLegErrors = balenceScore
    }

}
