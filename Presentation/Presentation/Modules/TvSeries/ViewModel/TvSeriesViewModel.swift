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
    
    private var subscriptions = Set<AnyCancellable>()
    
    private let dataSource : TvSeriesDataRepositoryInterface
    
    public init(dataSource: TvSeriesDataRepositoryInterface) {
        self.dataSource = dataSource
        
    }
    
    func fetchOnAirTvSeries() {
        dataSource.getTvSeriesOnAir()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.onAirTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    
    
    
}
