//
//  HeroRouter.swift
//  SuperHero
//
//  Created by Bekarys on 26.03.2025.
//

import SwiftUI
import UIKit

final class HeroRouter {
    var rootViewController: UINavigationController?

    func showDetails(for id: Int) {
        let service = HeroServiceImpl()
        let detailVC = UIHostingController(rootView: HeroDetailView(id: id, service: service))
        rootViewController?.pushViewController(detailVC, animated: true)
    }
}
