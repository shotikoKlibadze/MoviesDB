//
//  TvSeriesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import UIKit
import Core
import Combine

public class TvSeriesViewController: DBViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tvSeries = [TvSeriesEntity]() {
        didSet {
            print("here")
        }
    }
    private var subscriptions = Set<AnyCancellable>()
    
    var viewModel: TvSeriesViewModel!

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchOnAirTvSeries()
        bind()
        title = "TV Series"
        
    }
    
    private func bind() {
        viewModel.$onAirTvSeries
            .sink { _ in
                print("Completed")
            } receiveValue: { [weak self] tvSeries in
                self?.tvSeries = tvSeries
            }
            .store(in: &subscriptions)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        guard let tabBar = tabBarController as? MainTabBarController else { return }
        tabBar.menuButton.isHidden = false
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard (navigationController?.viewControllers.count)! > 1 else { return }
        guard let tabBar = tabBarController as? MainTabBarController else { return }
        tabBar.menuButton.isHidden = true
    }

}
