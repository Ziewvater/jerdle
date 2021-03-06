//
//  GameView.swift
//  jerdle
//
//  Created by Jeremy Lawrence on 3/13/22.
//

import UIKit
import jerdleEngine

protocol GameViewDelegate {
    func gameViewWasTapped(gameView: GameView)
}

class GameView: UIView {

    var rowViews: [LetterRowView] = []

    fileprivate var answers: [String] = []

    let letterCount: Int
    let guessCount: Int

    var delegate: GameViewDelegate?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect,
         letterCount: Int,
         guessCount: Int) {
        self.letterCount = letterCount
        self.guessCount = guessCount

        super.init(frame: frame)
        self.layoutMargins = UIEdgeInsets.zero
        translatesAutoresizingMaskIntoConstraints = false

        var rowViews: [LetterRowView] = []
        for _ in 0..<guessCount {
            let view = LetterRowView(frame: CGRect.zero, letterCount: letterCount)
            addSubview(view)
            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor)
            ])

            // If previous view is present, pin to its trailing edge and set equal widths
            if let previousView = rowViews.last {
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: kVerticalInterLetterSpacing),
                    view.widthAnchor.constraint(equalTo: previousView.widthAnchor),
                    view.heightAnchor.constraint(equalTo: previousView.heightAnchor),
                ])
            } else {
                // If first view, pin to top of the game view
                NSLayoutConstraint.activate([
                    view.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
                    view.heightAnchor.constraint(equalTo: self.layoutMarginsGuide.widthAnchor, multiplier: CGFloat(1.0/CGFloat(letterCount))),
                    heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: CGFloat(guessCount)),
                ])
            }
            rowViews.append(view)
        }
        // Pin final view to trailing edge
        if let finalView = rowViews.last {
            finalView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
        }


        self.rowViews = rowViews

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGameView(gesture:))))
    }

    internal func updateGameUI(with answer: String, forRow rowIndex: Int) {
        guard rowIndex < rowViews.count else {
            return
        }
        let row = rowViews[rowIndex]
        row.updateRow(with: answer)
    }

    internal func updateGameUI(with verificationResults: [VerificationResult], forRow rowIndex: Int) {
        guard rowIndex < rowViews.count else {
            return
        }
        let row = rowViews[rowIndex]
        row.updateRow(with: verificationResults)
    }
}


// MARK: Tap Handling
extension GameView {
    @objc func didTapGameView(gesture: UIGestureRecognizer) {
        delegate?.gameViewWasTapped(gameView: self)
    }
}
