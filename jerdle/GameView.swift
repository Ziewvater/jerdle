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

    fileprivate var answers: [String] = []

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
        textField.autocapitalizationType = .allCharacters
        textField.isHidden = true
        textField.delegate = self

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapGameView(gesture:))))
    }

    fileprivate func updateGameUI(with answer: String) {
        let currentRow = answers.count
        guard currentRow < rowViews.count else {
            return
        }
        let row = rowViews[currentRow]
        row.updateRow(with: answer)
    }
}


// MARK: Tap Handling
extension GameView {
    @objc func didTapGameView(gesture: UIGestureRecognizer) {
        textField.becomeFirstResponder()
    }
}

extension GameView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let capitalizedString = string.capitalized
        let replacementCharacterSet = CharacterSet(charactersIn: capitalizedString)
        guard CharacterSet.uppercaseLetters.isSuperset(of: replacementCharacterSet) else {
            // Only allow capitalized characters to be added
            return false
        }

        if let existingText = textField.text,
           let stringRange = Range(range, in: existingText) {
            let result = existingText.replacingCharacters(in: stringRange, with: capitalizedString)
            guard result.count <= letterCount else {
                return false
            }

            updateGameUI(with: result)
        }
        return true
    }

}
