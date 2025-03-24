//
//  HeroListViewModel.swift
//  SuperHero
//
//  Created by Bekarys on 26.03.2025.
//

import SwiftUI

final class HeroListViewModel: ObservableObject {
    @Published private(set) var heroes: [HeroListModel] = []

    private let service: HeroService
    private let router: HeroRouter

    init(service: HeroService, router: HeroRouter) {
        self.service = service
        self.router = router
    }

    func fetchHeroes() async {
        do {
            let heroesResponse = try await service.fetchHeroes()

            await MainActor.run {
                heroes = heroesResponse.map {
                    HeroListModel(
                        id: $0.id,
                        title: $0.name,
                        description: $0.appearance?.race ?? "No Race",
                        heroImage: $0.heroImageUrl,
                        powerstats: $0.powerstats.map {
                            HeroListModel.PowerStats(
                                intelligence: $0.intelligence,
                                strength: $0.strength,
                                speed: $0.speed,
                                durability: $0.durability,
                                power: $0.power,
                                combat: $0.combat
                            )
                        },
                        biography: $0.biography.map {
                            HeroListModel.Biography(
                                publisher: $0.publisher,
                                fullName: $0.fullName
                            )
                        }
                    )
                }
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    func routeToDetail(by id: Int) {
        router.showDetails(for: id)
    }
}
