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
    fileprivate var answers: [[VerificationResult]] = []
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
        answers.append(verificationResults)
        verifyGameState()
    }

    /// Checks current game state to determine which actions are available to the player
    /// Ends the game if the player has either exhausted all guesses or has guessed correctly
    fileprivate func verifyGameState() {
        let allCorrect = answers.last?.reduce(true, { partialResult, letterResult in
            if letterResult.status != .correct {
                return false
            } else {
                return partialResult
            }
        })
        if let allCorrect = allCorrect,
           allCorrect {
            textField.resignFirstResponder()
            textField.isEnabled = false
            showSuccessState()
        } else if answers.count == guessCount {
            textField.resignFirstResponder()
            textField.isEnabled = false
            showFailureState()
        }
    }

    fileprivate func showFailureState() {
        let alert = UIAlertController(title: "Nice Try!", message: "Sorry, seems like you're out of guesses. Better luck next time!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    fileprivate func showSuccessState() {
        let alert = UIAlertController(title: "Great Job!", message: "Yahoo!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "I Did A Great Job", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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
