//
//  LayOutManager.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 26.03.22.
//

import Foundation
import UIKit

struct LaoOutManager {
    
    enum DecorationKind {
        static let backgroundDecoration = "SectionBackGroundDecoration"
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnviorement in
            guard let sectionKinde = MoviesViewController.Sections(rawValue: sectionIndex) else {
                fatalError("Undefiend section for value: \(sectionIndex)")
            }
            switch sectionKinde {
            case .nowPlayingMovies:
                return constructSectionForNowPlayingMovies()
            case .upcomingMovies:
                return constructSectionForUpcomingMovies()
            case .topRatedMovies:
                return constructSectionForTopRatedMovies()
            }
        }
        layout.register(SectionBackGroundDecoration.self, forDecorationViewOfKind: DecorationKind.backgroundDecoration)
        
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration
        return layout
    }
    
    func constructSectionForNowPlayingMovies() -> NSCollectionLayoutSection {
        
       
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
       
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [createSectionHeaderItem()]
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: DecorationKind.backgroundDecoration)
        ]
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment ) in
            items.filter { $0.representedElementCategory == .cell }.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.7
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return section
    }
    
    func constructSectionForUpcomingMovies() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [createSectionHeaderItem()]
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: DecorationKind.backgroundDecoration)
        ]
        
        return section
    }
    
    func constructSectionForTopRatedMovies() -> NSCollectionLayoutSection {
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.boundarySupplementaryItems = [createSectionHeaderItem()]
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: DecorationKind.backgroundDecoration)
        ]
        return section
    }
    
    func createSectionHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: MoviesViewController.SupplementaryElementKind.sectionHeader, alignment: .top)
        return headerSupplementary
        
    }
}
