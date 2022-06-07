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
    
    @Published var onAirTvSeries = [MovieEntity]()
    @Published var popularTvSeries = [MovieEntity]()
    @Published var topRatedTvSeries = [MovieEntity]()
    @Published var similarTvSeries = [MovieEntity]()
    @Published var castMembers = [ActorEntity]()
    
    private var subscriptions = Set<AnyCancellable>()
    
    let maxPage = 10
    var currentPage = 1
    
    let dataSource : TvSeriesDataRepositoryInterface
    
    public init(dataSource: TvSeriesDataRepositoryInterface) {
        self.dataSource = dataSource
        
    }
    
    func getData() {
        getTvSeriesOnAir()
        getPopularTvSeries()
        getTopRatedTvSeries()
    }
    
    func getTvSeriesOnAir() {
        dataSource.getTvSeriesOnAir()
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.onAirTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    func getPopularTvSeries()  {
        dataSource.getPopularTvSeries(page: currentPage)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.popularTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    func getMorePopularTvSeries() -> AnyPublisher<[MovieEntity], Error> {
        guard currentPage <= maxPage else { return Empty().eraseToAnyPublisher() }
        currentPage += 1
        return dataSource.getPopularTvSeries(page: currentPage).eraseToAnyPublisher()
    }
    
    func getTopRatedTvSeries() {
        dataSource.getTopRatedTvSeries(page: currentPage)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.topRatedTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    func getMoreTopRatedTvSeries() -> AnyPublisher<[MovieEntity], Error> {
        guard currentPage <= maxPage else { return Empty().eraseToAnyPublisher() }
        currentPage += 1
        return dataSource.getTopRatedTvSeries(page: currentPage).eraseToAnyPublisher()
    }
    
    func getSimilarTvSeries(tvSeriesID: Int) {
        dataSource.getSimilarTvSeries(tvSeriesID: tvSeriesID)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.similarTvSeries, on: self)
            .store(in: &subscriptions)
    }
    
    func getCastMembers(tvSeriesID: Int) {
        dataSource.getCastMembers(tvSeriesID: tvSeriesID)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .assign(to: \.castMembers, on: self)
            .store(in: &subscriptions)
    }
    
    func resetPage() {
        currentPage = 1
    }
    
    
    
    
}
