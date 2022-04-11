//
//  AllMoviesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 10.04.22.
//

import UIKit
import ProgressHUD
import Core

class AllMoviesViewController: MDBViewController {
    
    
    var contextProvider : ContextProvider!
    private var movies = [Movie]()
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        getMovies()
    }
    
    private func setupCollectionView() {
        
    }
    
//    private func createLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300))
//        let group = NSCollectionLayoutGroup
//        
//    }
    
    private func getMovies() {
        ProgressHUD.show()
        Task {
            do {
                movies = try await contextProvider.provideContext()
                print(movies.count)
                ProgressHUD.dismiss()
            } catch (let error) {
                print(error.localizedDescription)
            }
        }
    }
    
}
