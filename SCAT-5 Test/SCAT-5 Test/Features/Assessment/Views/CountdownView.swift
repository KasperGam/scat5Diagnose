//
//  CountdownView.swift
//  SCAT-5 Test
//
//  Created by Kasper Gammeltoft on 10/28/18.
//  Copyright © 2018 CS4261. All rights reserved.
//

import UIKit

class CountdownView: UIView {

    @IBInspectable var readyColor: UIColor = .red
    @IBInspectable var setColor: UIColor = .yellow
    @IBInspectable var goColor: UIColor = .green
    @IBInspectable var secondsInReady: Int = 2
    @IBInspectable var secondsInSet: Int = 2
    @IBInspectable var secondsInGo: Int = 2

    enum State: Equatable {
        case start
        case ready(Int)
        case set(Int)
        case go(Int)
        case running
        case stopped
        case finished
    }

    var state: State = .start {
        didSet {
            configureForState()
        }
    }

    var timer: Timer?
    var label: UILabel
    var startButton: UIButton

    var countDown: Int = 0
    var countDownStart: Int = 0 {
        didSet {
            countDown = countDownStart
        }
    }

    override init(frame: CGRect) {
        label = UILabel(frame: frame)
        startButton = UIButton(frame: frame)
        super.init(frame: frame)
        commonInit(frame)
    }

    required init?(coder aDecoder: NSCoder) {
        label = UILabel(frame: .zero)
        startButton = UIButton(frame: .zero)
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit(_ frame: CGRect = .zero) {
        label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center

        addSubview(label)
        label.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        label.text = "Ready..."

        startButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.setTitle("Start", for: UIControl.State())
        startButton.titleLabel?.baselineAdjustment = .alignCenters
        startButton.titleLabel?.textAlignment = .center
        startButton.setTitleColor(UIColor.blue, for: UIControl.State())

        startButton.addTarget(self, action: #selector(start), for: .touchUpInside)

        addSubview(startButton)
        startButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        startButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        startButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        startButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        state = .start
        configureForState()
    }

    @objc
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer?.fire()
    }

    func reset() {
        timer?.invalidate()
        countDown = countDownStart
        state = .start
        configureForState()
    }

    /// Used to pause the countdown. Use `restartCountdown()` to start at the same position
    func stopCountdown() {
        timer?.invalidate()
        state = .stopped
    }

    /// Used to restart the countdown if it was paused. If it was still in the ready, set, go
    /// phase, then it will restart completely.
    func restartCountdown() {
        if countDown == countDownStart {
            state = .ready(0)
        } else {
            state = .running
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer?.fire()
    }

    @objc
    private func update() {
        switch state {
        case .start:
            state = .ready(0)
        case .ready(let seconds):
            if seconds < secondsInReady {
                state = .ready(seconds + 1)
            } else {
                state = .set(0)
            }
        case .set(let seconds):
            if seconds < secondsInSet {
                state = .set(seconds + 1)
            } else {
                state = .go(0)
            }
        case .go(let seconds):
            if seconds < secondsInGo {
                state = .go(seconds + 1)
            } else {
                state = .running
            }
        case .running:
            countDown -= 1
            if countDown <= 0 {
                state = .finished
            }
            configureForState()
        case .finished:
            timer?.invalidate()
            countDown = 0
        case .stopped:
            timer?.invalidate()
        }
    }

    private func configureForState() {
        switch state {
        case .start:
            backgroundColor = .clear
            label.text = ""
            startButton.isEnabled = true
            startButton.isHidden = false
        case .ready:
            backgroundColor = readyColor
            label.text = "Ready..."
        case .set:
            backgroundColor = setColor
            label.text = "Set..."
        case .go:
            backgroundColor = goColor
            label.text = "Go!"
        case .running:
            backgroundColor = .clear
            label.text = countDown.valueAsTime()
        case .finished:
            backgroundColor = .clear
            label.text = "Time is up"
        case .stopped:
            return
        }
        if state != State.start {
            startButton.isHidden = true
            startButton.isEnabled = false
        }
    }
}
