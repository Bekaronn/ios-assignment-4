//
//  HeroListModel.swift
//  SuperHero
//
//  Created by Bekarys on 25.03.2025.
//

import Foundation

struct HeroListModel: Identifiable {
    let id: Int
    let title: String
    let description: String
    let heroImage: URL?
    
    let powerstats: PowerStats?
    let biography: Biography?
    
    struct PowerStats {
        let intelligence: Int?
        let strength: Int?
        let speed: Int?
        let durability: Int?
        let power: Int?
        let combat: Int?
    }
    
    struct Biography {
        let publisher: String?
        let fullName: String?
    }
}
