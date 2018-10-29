//
//  BalanceTestingView.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class BalanceTestingView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var balanceTestLabel: UILabel!
    @IBOutlet weak var numberOfErrorsLabel: UILabel!

    var errorCount: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        // Nib Setup
        Bundle.main.loadNibNamed("BalanceTestingView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

    @IBAction func plusButtonPressed(_ sender: Any) {
        errorCount += 1
        numberOfErrorsLabel.text = String(errorCount)
    }

    @IBAction func minusButtonPressed(_ sender: Any) {
        guard errorCount > 0 else { return }
        errorCount -= 1
        numberOfErrorsLabel.text = String(errorCount)
    }

}
