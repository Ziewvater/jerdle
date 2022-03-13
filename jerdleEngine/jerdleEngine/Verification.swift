//
//  Verification.swift
//  jerdleEngine
//
//  Created by Jeremy Lawrence on 3/13/22.
//

import Foundation

enum VerificationStatus {
    /// The letter is correctly placed
    case correct
    /// The letter appears in the answer, but is in the wrong place
    case misplaced
    /// The letter does not appear in the answer
    case incorrect
}

struct VerificationResult {
    let answer: Character
    let status: VerificationStatus
}

extension VerificationResult: Equatable {
    static func == (lhs: VerificationResult, rhs: VerificationResult) -> Bool {
        return lhs.answer == rhs.answer && lhs.status == rhs.status
    }
}

struct DecomposedSolution {
    let results: [Character: [Int]]

    static func decompose(_ solution: String) -> DecomposedSolution {
        let parsed = solution.enumerated().reduce(into: [Character:[Int]]()) { partialResult, item in
            let (index, character) = item
            if var existingResult = partialResult[character] {
                existingResult.append(index)
                partialResult[character] = existingResult
            } else {
                partialResult[character] = [index]
            }
        }
        return DecomposedSolution(results: parsed)
    }

    func result(for character: Character) -> [Int]? {
        return results[character]
    }
}

extension DecomposedSolution: Equatable {
    static func == (lhs: DecomposedSolution, rhs: DecomposedSolution) -> Bool {
        return lhs.results == rhs.results
    }
}

class Verification {

    let solution: String
    let decomposedSolution: DecomposedSolution

    init(withSolution solution: String) {
        self.solution = solution
        self.decomposedSolution = DecomposedSolution.decompose(solution)
    }

    func check(answer: String) -> [VerificationResult] {
        var verifiedResult: [VerificationResult] = []
        for (index, character) in answer.enumerated() {
            if let solutionResult = decomposedSolution.result(for: character) {
                if solutionResult.contains(index) {
                    verifiedResult.append(VerificationResult(answer: character, status: .correct))
                } else {
                    verifiedResult.append(VerificationResult(answer: character, status: .misplaced))
                }
            } else {
                verifiedResult.append(VerificationResult(answer: character, status: .incorrect))
            }
        }
        return verifiedResult
    }
}
