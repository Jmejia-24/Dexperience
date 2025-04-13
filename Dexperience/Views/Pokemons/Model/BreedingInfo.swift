//
//  BreedingInfo.swift
//  Dexperience
//
//  Created by Byron on 4/17/25.
//

struct BreedingInfo: Hashable {

    let eggGroups: [String]
    let hatchSteps: Int
    let hatchCycles: Int
    let genderRatio: GenderRatio
    let isGenderless: Bool
}
