//
//  Pokemon.swift
//  PokedexUIKit
//
//  Created by Maciej on 11/10/2023.
//

import UIKit

struct Pokemon: Identifiable, Codable {
    /// General
    let id: Int
    let name: String
    let type: String
    let description: String
    var image: UIImage?
    let imageUrl: String
    
    /// Stats
    let attack: Int
    let defense: Int
    let height: Int
    let weight: Int
    
    // MARK: - CodingKeys
    /// CodingKeys were added in order to add `image: UIImage?` to the model
    /// Otherwise it throws an error. UIImage is not codable
    enum CodingKeys: CodingKey {
        case id
        case imageUrl
        case name
        case type
        case description
        case attack
        case defense
        case height
        case weight
    }
}
