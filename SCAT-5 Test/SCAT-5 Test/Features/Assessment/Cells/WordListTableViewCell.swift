//
//  WordListTableViewCell.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/15/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

protocol WordListTableViewCellDelegate: class {
    func updateWordRecall(_ wordRecall: WordRecall)
}

class WordListTableViewCell: UITableViewCell {

    weak var delegate: WordListTableViewCellDelegate?
    var wordRecall: WordRecall?

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var wordRecallSwitch: UISwitch!

    func configure(with wordRecall: WordRecall) {
        wordLabel.text = wordRecall.word
        wordRecallSwitch.setOn(wordRecall.recalled, animated: false)
        self.wordRecall = wordRecall
    }

    @IBAction func recallValueChanged(_ sender: Any) {
        wordRecall?.recalled = wordRecallSwitch.isOn
        if let recall = wordRecall {
            delegate?.updateWordRecall(recall)
        }
    }

}
