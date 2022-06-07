//
//  TopRatedTvSeriesProvider.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 06.06.22.
//

import Foundation

import Core
import Combine

class TopRatedTvSeriesProvider : TvSeriesContextProvider {
    
    @Published public var topRatedTvSeries = [MovieEntity]()
    var viewModel: TvSeriesViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    init(){}
    
    func provideContext() {
        viewModel.dataSource.getTopRatedTvSeries(page: 1)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.topRatedTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    func provideMoreContext() {
        viewModel.getMoreTopRatedTvSeries()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .map { [weak self] newData -> [MovieEntity] in
                guard let self = self else { return [] }
                return self.topRatedTvSeries + newData
            }
            .assign(to: \.topRatedTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    func resetContext() {
        viewModel.resetPage()
    }
}
