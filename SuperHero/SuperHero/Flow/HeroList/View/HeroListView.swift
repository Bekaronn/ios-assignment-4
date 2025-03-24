//
//  HeroListView.swift
//  SuperHero
//
//  Created by Bekarys on 26.03.2025.
//

import SwiftUI

struct HeroListView: View {
    @StateObject var viewModel: HeroListViewModel
    @State private var searchText = ""

    var body: some View {
        VStack {
            Text("Hero List")
                .font(.largeTitle)
            
            searchBar()

            Divider()
                .padding(.bottom, 16)

            listOfHeroes()
            Spacer()
        }
        .task {
            await viewModel.fetchHeroes()
        }
    }
}

extension HeroListView {
    @ViewBuilder
    private func searchBar() -> some View {
        TextField("Search hero...", text: $searchText)
            .padding(10)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 16)
    }
    
    private func filteredHeroes() -> [HeroListModel] {
        if searchText.isEmpty {
            return viewModel.heroes
        } else {
            return viewModel.heroes.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                ($0.biography?.fullName?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    @ViewBuilder
    private func listOfHeroes() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(filteredHeroes()) { model in
                    heroCard(model: model)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                }
            }
        }
    }

    @ViewBuilder
    private func heroCard(model: HeroListModel) -> some View {
        HStack {
            AsyncImage(url: model.heroImage) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                default:
                    Color.gray
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(model.title)
                    .font(.title2)
                    .fontWeight(.bold)
       
                Text("Race: " + (model.description.isEmpty ? "Unknown" : model.description))
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                Text("Name: " + (model.biography?.fullName?.isEmpty == false ? model.biography!.fullName! : "Unknown name"))
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                Text("Publisher: " + (model.biography?.publisher?.isEmpty == false ? model.biography!.publisher! : "Unknown publisher"))
                        .font(.footnote)
                        .foregroundColor(.gray)
                
                if let powerstats = model.powerstats {
                    VStack(spacing: 10) {
                        HStack(spacing: 10) {
                            statView(label: "💡", value: powerstats.intelligence)
                            statView(label: "💪", value: powerstats.strength)
                            statView(label: "⚡", value: powerstats.speed)
                        }
                        HStack(spacing: 10) {
                            statView(label: "🛡️", value: powerstats.durability)
                            statView(label: "🔥", value: powerstats.power)
                            statView(label: "⚔️", value: powerstats.combat)
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    ShareLink(
                        item: URL(string: "https://cdn.jsdelivr.net/gh/akabab/superhero-api@0.3.0/api/id/\(model.id).json")!,
                        message: Text("Check out this hero: \(model.title)"),
                        label: {
                            Label("Share", systemImage: "square.and.arrow.up")
                                .font(.caption)
                                .padding(6)
                                .background(Color.blue.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 4)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            print("Tapped \(model.id)")
            viewModel.routeToDetail(by: model.id)
        }
    }
    
    @ViewBuilder
    private func statView(label: String, value: Int?) -> some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.subheadline)
            Text("\(value ?? 0)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.blue)
        }
        .padding(4)
        .background(Color.blue.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
