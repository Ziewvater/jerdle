//
//  ViewController.swift
//  jerdle
//
//  Created by Jeremy Lawrence on 3/13/22.
//

import UIKit
import jerdleEngine

class GameViewController: UIViewController {

    let gameView: GameView
    let textField = UITextField()

    let answerVerifier: Verification
    fileprivate var answers: [String] = []
    let letterCount: Int = 5
    let guessCount: Int = 6

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(withSolution solution: String) {
        self.gameView = GameView(frame: CGRect.zero, letterCount: letterCount, guessCount: guessCount)
        self.answerVerifier = Verification(withSolution: solution)
        super.init(nibName: nil, bundle: nil)
        gameView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground
        view.addSubview(gameView)

        gameView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        gameView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        gameView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true

        view.addSubview(textField)
        textField.autocorrectionType = .no
        textField.spellCheckingType = .no
        textField.autocapitalizationType = .allCharacters
        textField.isHidden = true
        textField.delegate = self
    }

    fileprivate func submit(guess answer: String) {
        let verificationResults = answerVerifier.check(answer: answer)
        gameView.updateGameUI(with: verificationResults, forRow: answers.count)
        answers.append(answer)
    }
}

extension GameViewController: UITextFieldDelegate {
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

            gameView.updateGameUI(with: result, forRow: answers.count)
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text,
                text.count == letterCount else {
            return false
        }

        submit(guess: text)
        textField.text = nil
        return false
    }
}

extension GameViewController: GameViewDelegate {

    func gameViewWasTapped(gameView: GameView) {
        textField.becomeFirstResponder()
    }
}
