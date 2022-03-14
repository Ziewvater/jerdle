//
//  LetterRowView.swift
//  jerdle
//
//  Created by Jeremy Lawrence on 3/13/22.
//

import UIKit

class LetterRowView: UIView {
    let letterCount: Int
    var letterViews: [LetterView] = []

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(frame: CGRect,
         letterCount : Int) {
        self.letterCount = letterCount
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false

        backgroundColor = .orange

        var letterViews = [LetterView]()
        for _ in 0..<letterCount {
            let view = LetterView(frame: CGRect.zero)
            self.addSubview(view)

            // Pin view to top and bottom
            view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

            // Pin to trailing edge of preceding view
            // and set equal width
            if let previousView = letterViews.last {
                view.leadingAnchor.constraint(equalTo: previousView.trailingAnchor).isActive = true
                view.widthAnchor.constraint(equalTo: previousView.widthAnchor).isActive = true
            } else {
                // or if first, pin to the leading edge of container
                view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            }
            letterViews.append(view)
        }
        // Attach the final view to trailing end of container
        letterViews.last?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.letterViews = letterViews
    }

    internal func updateRow(with answer: String) {
        let split = Array(answer)
        letterViews.enumerated().forEach { (index, letterView) in
            guard index < split.count else {
                letterView.update(letter: nil, status: .unresolved)
                return
            }
            letterView.update(letter: split[index], status: .unresolved)
        }
    }
}
