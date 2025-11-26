//
//  BreedingInfo.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

nonisolated
struct BreedingInfo: Hashable, Sendable {

    let eggGroups: [String]
    let hatchSteps: Int
    let hatchCycles: Int
    let genderRatio: GenderRatio
    let isGenderless: Bool
}
