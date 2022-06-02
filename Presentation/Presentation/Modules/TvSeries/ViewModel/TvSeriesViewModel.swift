//
//  TvSeriesViewModel.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import Core
import Combine

public class TvSeriesViewModel {
    
    @Published var onAirTvSeries = [TvSeriesEntity]()
    @Published var popularTvSeries = [TvSeriesEntity]()
    @Published var topRatedTvSeries = [TvSeriesEntity]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let dataSource : TvSeriesDataRepositoryInterface
    
    public init(dataSource: TvSeriesDataRepositoryInterface) {
        self.dataSource = dataSource
        
    }
    
    func fetchData() {
        dataSource.getTvSeriesOnAir()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.onAirTvSeries, on: self)
            .store(in: &subscriptions)
        
        dataSource.getPopularTvSeries()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.popularTvSeries, on: self)
            .store(in: &subscriptions)
        
        dataSource.getTopRatedTvSeries()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.topRatedTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    
    
    
}
