//
//  HeroDetailView.swift
//  SuperHero
//
//  Created by Bekarys on 26.03.2025.
//

import SwiftUI

struct HeroDetailView: View {
    let id: Int
    @StateObject private var viewModel: HeroDetailViewModel
    
    init(id: Int, service: HeroService) {
        self.id = id
        _viewModel = StateObject(wrappedValue: HeroDetailViewModel(service: service))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let hero = viewModel.hero {
                    heroImage(hero.heroImage)
                    
                    heroTitle(hero.title)
                    
                    if let biography = hero.biography {
                        biographyView(biography)
                    }
                    
                    if let powerstats = hero.powerstats {
                        powerStatsView(powerstats)
                    }
                    
                    if let appearance = hero.appearance {
                        appearanceView(appearance)
                    }
                    
                    if let work = hero.work {
                        workView(work)
                    }
                    
                    if let connections = hero.connections {
                        connectionsView(connections)
                    }
                } else {
                    ProgressView()
                }
            }
            .padding()
        }
        .task {
            await viewModel.fetchHeroDetail(id: id)
        }
    }
}

extension HeroDetailView {
    
    @ViewBuilder
    private func heroImage(_ url: URL?) -> some View {
        HStack {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                default:
                    Color.gray
                        .frame(height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func heroTitle(_ title: String) -> some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private func biographyView(_ biography: HeroDetailModel.Biography) -> some View {
        SectionView(title: "Biography") {
            InfoRow(label: "Full Name", value: biography.fullName)
            InfoRow(label: "Alter Egos", value: biography.alterEgos)
            InfoRow(label: "Aliases", value: biography.aliases?.joined(separator: ", "))
            InfoRow(label: "Place of Birth", value: biography.placeOfBirth)
            InfoRow(label: "First Appearance", value: biography.firstAppearance)
            InfoRow(label: "Publisher", value: biography.publisher)
            InfoRow(label: "Alignment", value: biography.alignment)
        }
    }
    
    @ViewBuilder
    private func powerStatsView(_ powerstats: HeroDetailModel.PowerStats) -> some View {
        SectionView(title: "Power Stats") {
            statRow(label: "💡 Intelligence", value: powerstats.intelligence)
            statRow(label: "💪 Strength", value: powerstats.strength)
            statRow(label: "⚡ Speed", value: powerstats.speed)
            statRow(label: "🛡️ Durability", value: powerstats.durability)
            statRow(label: "🔥 Power", value: powerstats.power)
            statRow(label: "⚔️ Combat", value: powerstats.combat)
        }
    }
    
    @ViewBuilder
    private func appearanceView(_ appearance: HeroDetailModel.Appearance) -> some View {
        SectionView(title: "Appearance") {
            InfoRow(label: "Gender", value: appearance.gender)
            InfoRow(label: "Race", value: appearance.race)
            InfoRow(label: "Height", value: appearance.height?.joined(separator: ", "))
            InfoRow(label: "Weight", value: appearance.weight?.joined(separator: ", "))
            InfoRow(label: "Eye Color", value: appearance.eyeColor)
            InfoRow(label: "Hair Color", value: appearance.hairColor)
        }
    }
    
    @ViewBuilder
    private func workView(_ work: HeroDetailModel.Work) -> some View {
        SectionView(title: "Work") {
            InfoRow(label: "Occupation", value: work.occupation)
            InfoRow(label: "Base", value: work.base)
        }
    }
    
    @ViewBuilder
    private func connectionsView(_ connections: HeroDetailModel.Connections) -> some View {
        SectionView(title: "Connections") {
            InfoRow(label: "Group Affiliation", value: connections.groupAffiliation)
            InfoRow(label: "Relatives", value: connections.relatives)
        }
    }
    
    @ViewBuilder
    private func statRow(label: String, value: Int?) -> some View {
        HStack {
            Text(label)
            Spacer()
            Text("\(value ?? 0)")
                .fontWeight(.bold)
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    @ViewBuilder
    private func InfoRow(label: String, value: String?) -> some View {
        if let value = value, !value.isEmpty {
            HStack {
                Text(label)
                    .fontWeight(.semibold)
                Spacer()
                Text(value)
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
        }
    }
}

struct SectionView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    init(title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 4)
            
            VStack(alignment: .leading, spacing: 6) {
                content()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding(.horizontal)
    }
}
