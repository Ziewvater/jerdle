//
//  jerdleEngineTests.swift
//  jerdleEngineTests
//
//  Created by Jeremy Lawrence on 3/13/22.
//

import XCTest
@testable import jerdleEngine

class jerdleEngineTests: XCTestCase {

    func testDecomposedSolutionCreation() {
        let solution = "ABCDE"
        let expected = DecomposedSolution(results: [
            "A" as Character: [0],
            "B" as Character: [1],
            "C" as Character: [2],
            "D" as Character: [3],
            "E" as Character: [4]
        ])
        let result = DecomposedSolution.decompose(solution)
        XCTAssertEqual(result, expected)
    }

    func testCorrectAnswerVerified() {
        let solution = "ABCDE"
        let expected = [
            VerificationResult(answer: "A" as Character, status: .correct),
            VerificationResult(answer: "B" as Character, status: .correct),
            VerificationResult(answer: "C" as Character, status: .correct),
            VerificationResult(answer: "D" as Character, status: .correct),
            VerificationResult(answer: "E" as Character, status: .correct),
        ]
        let verification = Verification(withSolution: solution)
        XCTAssertEqual(verification.check(answer: solution), expected)
    }

    func testMisplacedCharactersIdentified() {
        let solution = "ABCDE"
        let answer = "BCDEA"
        let expected = [
            VerificationResult(answer: "B" as Character, status: .misplaced),
            VerificationResult(answer: "C" as Character, status: .misplaced),
            VerificationResult(answer: "D" as Character, status: .misplaced),
            VerificationResult(answer: "E" as Character, status: .misplaced),
            VerificationResult(answer: "A" as Character, status: .misplaced),
        ]
        let verification = Verification(withSolution: solution)
        XCTAssertEqual(verification.check(answer: answer), expected)
    }

    func testIncorrectCharactersIdentified() {
        let solution = "ABCDE"
        let answer = "FGHIJ"
        let expected = [
            VerificationResult(answer: "F" as Character, status: .incorrect),
            VerificationResult(answer: "G" as Character, status: .incorrect),
            VerificationResult(answer: "H" as Character, status: .incorrect),
            VerificationResult(answer: "I" as Character, status: .incorrect),
            VerificationResult(answer: "J" as Character, status: .incorrect),
        ]
        let verification = Verification(withSolution: solution)
        XCTAssertEqual(verification.check(answer: answer), expected)
    }

    func testDoubleMisplacedCharacterIdentified() {
        let solution = "ABCDE"
        let answer = "ABDCE"
        let expected = [
            VerificationResult(answer: "A" as Character, status: .correct),
            VerificationResult(answer: "B" as Character, status: .correct),
            VerificationResult(answer: "D" as Character, status: .misplaced),
            VerificationResult(answer: "C" as Character, status: .misplaced),
            VerificationResult(answer: "E" as Character, status: .correct),
        ]
        let verification = Verification(withSolution: solution)
        XCTAssertEqual(verification.check(answer: answer), expected)
    }

    func testMixedIncorrectAndMisplacedCharactersIdentified() {
        let solution = "ABCDE"
        let answer = "AXDCE"
        let expected = [
            VerificationResult(answer: "A" as Character, status: .correct),
            VerificationResult(answer: "X" as Character, status: .incorrect),
            VerificationResult(answer: "D" as Character, status: .misplaced),
            VerificationResult(answer: "C" as Character, status: .misplaced),
            VerificationResult(answer: "E" as Character, status: .correct),
        ]
        let verification = Verification(withSolution: solution)
        XCTAssertEqual(verification.check(answer: answer), expected)
    }
}
