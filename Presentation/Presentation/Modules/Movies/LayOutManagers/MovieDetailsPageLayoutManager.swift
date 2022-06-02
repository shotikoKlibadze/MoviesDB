//
//  MovieDetailsPageLayoutManager.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 11.05.22.
//

import Foundation
import UIKit

struct MovieDetailsPageLayoutManager {
    
    enum DecorationKind {
        static let backgroundDecoration = "SectionBackGroundDecoration"
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layOut = UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let sectionKind = MovieDetailsViewController.Section(rawValue: sectionIndex) else {
                fatalError("No such section")
            }
            switch sectionKind {
            case .cast:
                return createSectionForCast()
            case .similarMovies:
                return createSectionForSimilarMovies()
            }
        }
        layOut.register(SectionBackGroundDecoration.self, forDecorationViewOfKind: DecorationKind.backgroundDecoration)
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layOut.configuration = configuration
        return layOut
    }
    
    
    func createSectionForCast() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 5, leading: 0, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.28), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [createSectionHeaderItem()]
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: DecorationKind.backgroundDecoration)
        ]
        return section
    }
    
    func createSectionForSimilarMovies()  -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 20, bottom: 0, trailing: 0)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [createSectionHeaderItem()]
        section.decorationItems = [NSCollectionLayoutDecorationItem.background(elementKind: DecorationKind.backgroundDecoration)
        ]
        section.contentInsets = .init(top: 0, leading: 0, bottom: 20, trailing: 0)
        return section
    }
    
    func createSectionHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: MovieDetailsViewController.SupplementaryElementKind.sectionHeader, alignment: .top)
        return headerSupplementary
        
    }
    
    
    
    
    
    
    
}
