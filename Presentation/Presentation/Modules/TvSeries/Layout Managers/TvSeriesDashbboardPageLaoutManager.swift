//
//  TvSeriesDashbboardPageLaoutManager.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 02.06.22.
//

import Foundation
import UIKit

struct TvSeriesDashbboardPageLaoutManager {
    
    enum DecorationKind {
        static let backgroundDecoration = "SectionBackGroundDecoration"
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { sectionIndex, enviorenment in
            guard let sectionKind = TvSeriesViewController.SectionKind(rawValue: sectionIndex) else {
                fatalError("Undefiend section for value: \(sectionIndex)")
            }
            switch sectionKind {
            case .onAir:
                return createOnAirSection()
            case .popular:
                return createPopularSection()
            case .topRated:
                return createTopRatedSection()
            }
        })
        
        layout.register(SectionBackGroundDecoration.self, forDecorationViewOfKind: DecorationKind.backgroundDecoration)
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration
        return layout
        
    }
    
    private func createOnAirSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //tem.contentInsets = .init(top: 0, leading: -20, bottom: 0, trailing: 0)
       
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(250))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //group.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [createSectionHeaderItem()]
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: DecorationKind.backgroundDecoration)
        ]
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment ) in
            items.filter { $0.representedElementCategory == .cell }.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.3)
                let minScale: CGFloat = 0.85
                let maxScale: CGFloat = 1.0
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return section

    }
    
    private func createPopularSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(120), heightDimension: .absolute(350)), subitem: item, count: 2)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(130), heightDimension: .absolute(350)), subitems: [verticalGroup])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [createSectionHeaderItem()]
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: DecorationKind.backgroundDecoration)
        ]
        return section
    }
    
    private func createTopRatedSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
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
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: TvSeriesViewController.SupplementaryElementKind.sectionHeader, alignment: .top)
        return headerSupplementary
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
