//
//  LetterView.swift
//  jerdle
//
//  Created by Jeremy Lawrence on 3/13/22.
//

import UIKit

enum LetterStatus {
    /// Letter hasn't been validated yet
    case unresolved
    /// Letter is correctly placed
    case correct
    /// Letter is incorrectly placed
    case misplaced
    /// Letter does not appear in solution
    case incorrect
}

class LetterView: UIView {
    let label = UILabel()
    var status: LetterStatus = .unresolved

    override init(frame: CGRect) {
        label.translatesAutoresizingMaskIntoConstraints = false
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(label)
        label.adjustsFontSizeToFitWidth = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        update(letter: nil, status: .unresolved)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(letter: Character?, status: LetterStatus) {
        if let letter = letter {
            label.text = String(letter)
        } else {
            label.text = nil
        }
        label.textColor = textColor(for: status)
        backgroundColor = backgroundColor(for: status)
        switch status {
        case .unresolved:
            layer.borderColor = UIColor.gray.cgColor
            layer.borderWidth = 2.0

        case .correct: fallthrough
        case .misplaced: fallthrough
        case .incorrect:
            layer.borderColor = nil
            layer.borderWidth = 0
        }
    }

    private func backgroundColor(for status: LetterStatus) -> UIColor {
        switch status {
        case .unresolved: return .white
        case .correct: return .green
        case .misplaced: return .yellow
        case .incorrect: return .gray
        }
    }

    private func textColor(for status: LetterStatus) -> UIColor {
        switch status {
        case .unresolved:
            return .black
        case .correct: fallthrough
        case .misplaced: fallthrough
        case .incorrect:
            return .white
        }
    }
}
