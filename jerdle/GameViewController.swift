//
//  ViewController.swift
//  jerdle
//
//  Created by Jeremy Lawrence on 3/13/22.
//

import UIKit

class GameViewController: UIViewController {

    let gameView: GameView

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        self.gameView = GameView(frame: CGRect.zero, letterCount: 5, guessCount: 6)
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.systemBackground
        view.addSubview(gameView)

        gameView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        gameView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        gameView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
}

