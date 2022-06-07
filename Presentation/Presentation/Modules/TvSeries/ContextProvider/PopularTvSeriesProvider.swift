//
//  PopularTvSeriesProvider.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 06.06.22.
//

import Foundation
import Core
import Combine

class PopularTvSeriesProvider : TvSeriesContextProvider {
    
    @Published var popularTvSeries = [MovieEntity]()
    var viewModel: TvSeriesViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    init(){}
    
    func provideContext() {
        viewModel.dataSource.getPopularTvSeries(page: 1)
            .print("here2")
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.popularTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    func provideMoreContext() {
        viewModel.getMorePopularTvSeries()
            .print("here")
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .map { [weak self] newData -> [MovieEntity] in
                guard let self = self else { return [] }
                return self.popularTvSeries + newData
            }
            .assign(to: \.popularTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    func resetContext() {
        viewModel.resetPage()
    }
    
    
}
