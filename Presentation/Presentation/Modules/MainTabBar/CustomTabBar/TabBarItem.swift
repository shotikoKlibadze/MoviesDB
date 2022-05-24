//
//  TabBarItem.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 07.04.22.
//


import UIKit

enum TabBarItem: String, CaseIterable {
    case movies
    case tvSeries
}
 
extension TabBarItem {
    
    var icon: UIImage? {
        switch self {
        case .tvSeries:
            return UIImage(systemName: "film.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        case .movies:
            return UIImage(systemName: "tv.circle")?.withTintColor(.white.withAlphaComponent(0.4), renderingMode: .alwaysOriginal)
        }
    }
    
    var selectedIcon: UIImage? {
        switch self {
        case .tvSeries:
            return UIImage(systemName: "film.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        case .movies:
            return UIImage(systemName: "tv.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        }
    }
    
    var name: String {
        return self.rawValue.capitalized
    }
}
