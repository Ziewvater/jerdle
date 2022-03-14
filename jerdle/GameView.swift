//
//  GameView.swift
//  jerdle
//
//  Created by Jeremy Lawrence on 3/13/22.
//

import UIKit

class GameView: UIView {

    let textField = UITextField()

    var rowViews: [LetterRowView] = []

    let letterCount: Int
    let guessCount: Int

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

        self.backgroundColor = .red
        var rowViews: [LetterRowView] = []
        for _ in 0..<guessCount {
            let view = LetterRowView(frame: CGRect.zero, letterCount: letterCount)
            addSubview(view)
            view.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true

            // If previous view is present, pin to its trailing edge and set equal widths
            if let previousView = rowViews.last {
                view.topAnchor.constraint(equalTo: previousView.bottomAnchor).isActive = true
                view.widthAnchor.constraint(equalTo: previousView.widthAnchor).isActive = true
                view.heightAnchor.constraint(equalTo: previousView.heightAnchor).isActive = true
            } else {
                // If first view, pin to top of the game view
                view.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
                view.heightAnchor.constraint(equalTo: self.layoutMarginsGuide.widthAnchor, multiplier: CGFloat(1.0/CGFloat(letterCount))).isActive = true
                heightAnchor.constraint(greaterThanOrEqualTo: view.heightAnchor, multiplier: CGFloat(guessCount)).isActive = true
            }
            rowViews.append(view)
        }
        // Pin final view to trailing edge
        if let finalView = rowViews.last {
            finalView.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
        }


        self.rowViews = rowViews

        addSubview(textField)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.isHidden = true

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGameView(gesture:))))
    }

}


// MARK: Tap Handling
extension GameView {
    @objc func didTapGameView(gesture: UIGestureRecognizer) {
        textField.becomeFirstResponder()
    }
}
