//
//  HeroDetailViewModel.swift
//  SuperHero
//
//  Created by Bekarys on 26.03.2025.
//

import SwiftUI

final class HeroDetailViewModel: ObservableObject {
    @Published private(set) var hero: HeroDetailModel? = nil
    
    private let service: HeroService
    
    init(service: HeroService) {
        self.service = service
    }
    
    func fetchHeroDetail(id: Int) async {
        do {
            let heroResponse = try await service.fetchHeroById(id: id)

            let powerstats = HeroDetailModel.PowerStats(
                intelligence: heroResponse.powerstats?.intelligence ?? 0,
                strength: heroResponse.powerstats?.strength ?? 0,
                speed: heroResponse.powerstats?.speed ?? 0,
                durability: heroResponse.powerstats?.durability ?? 0,
                power: heroResponse.powerstats?.power ?? 0,
                combat: heroResponse.powerstats?.combat ?? 0
            )
            
            let appearance = HeroDetailModel.Appearance(
                gender: heroResponse.appearance?.gender ?? "Unknown",
                race: heroResponse.appearance?.race ?? "Unknown",
                height: heroResponse.appearance?.height ?? ["Unknown"],
                weight: heroResponse.appearance?.weight ?? ["Unknown"],
                eyeColor: heroResponse.appearance?.eyeColor ?? "Unknown",
                hairColor: heroResponse.appearance?.hairColor ?? "Unknown"
            )

            let biography = HeroDetailModel.Biography(
                fullName: heroResponse.biography?.fullName ?? "No Name",
                alterEgos: heroResponse.biography?.alterEgos ?? "None",
                aliases: heroResponse.biography?.aliases ?? [],
                placeOfBirth: heroResponse.biography?.placeOfBirth ?? "Unknown",
                firstAppearance: heroResponse.biography?.firstAppearance ?? "Unknown",
                publisher: heroResponse.biography?.publisher ?? "Unknown",
                alignment: heroResponse.biography?.alignment ?? "Unknown"
            )

            let work = HeroDetailModel.Work(
                occupation: heroResponse.work?.occupation ?? "Unknown",
                base: heroResponse.work?.base ?? "Unknown"
            )
            
            let connections = HeroDetailModel.Connections(
                groupAffiliation: heroResponse.connections?.groupAffiliation ?? "None",
                relatives: heroResponse.connections?.relatives ?? "None"
            )

            let heroModel = HeroDetailModel(
                id: heroResponse.id,
                title: heroResponse.name,
                slug: heroResponse.slug ?? "no-slug",
                heroImage: heroResponse.heroImageUrl,
                powerstats: powerstats,
                appearance: appearance,
                biography: biography,
                work: work,
                connections: connections
            )

            await MainActor.run {
                self.hero = heroModel
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
