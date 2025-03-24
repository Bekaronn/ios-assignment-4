//
//  HeroDetailModel.swift
//  SuperHero
//
//  Created by Bekarys on 26.03.2025.
//

import Foundation

struct HeroDetailModel: Identifiable {
    let id: Int
    let title: String
    let slug: String?
    let heroImage: URL?
    let powerstats: PowerStats?
    let appearance: Appearance?
    let biography: Biography?
    let work: Work?
    let connections: Connections?

    struct PowerStats {
        let intelligence: Int?
        let strength: Int?
        let speed: Int?
        let durability: Int?
        let power: Int?
        let combat: Int?
    }
    
    struct Appearance {
        let gender: String?
        let race: String?
        let height: [String]?
        let weight: [String]?
        let eyeColor: String?
        let hairColor: String?
    }

    struct Biography {
        let fullName: String?
        let alterEgos: String?
        let aliases: [String]?
        let placeOfBirth: String?
        let firstAppearance: String?
        let publisher: String?
        let alignment: String?
    }

    struct Work {
        let occupation: String?
        let base: String?
    }

    struct Connections {
        let groupAffiliation: String?
        let relatives: String?
    }
}
