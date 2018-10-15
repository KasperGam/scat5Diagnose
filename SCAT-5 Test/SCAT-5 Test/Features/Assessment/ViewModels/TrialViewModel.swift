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
    var shouldUseCalendarTest: Bool { get set }
    var trialInstruction: String? { get set }
    var balanceString: String? { get set }
    var trialNumber: Int { get set }
    var nextTrialButtonString: String? { get set }

    func getNextTrial() -> TrialViewModel?

    func updateAssessment(_ assessment: inout SCAT5Test, wordList: [WordRecall]?, calendarRecall: Bool, balenceScore: Int)

}
