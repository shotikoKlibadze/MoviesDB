//
//  TvSeriesContextProvider.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 06.06.22.
//

import Foundation
import Core

protocol TvSeriesContextProvider {
    var viewModel : TvSeriesViewModel! { get set }
    func provideContext()
    func provideMoreContext()
    func resetContext()
}
