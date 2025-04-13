//
//  Collection+safe.swift
//  Dexperience
//
//  Created by Byron on 4/16/25.
//

extension Collection {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
