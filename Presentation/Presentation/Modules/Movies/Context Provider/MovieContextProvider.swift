//
//  ContextProvider.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 10.04.22.
//

import Foundation
import Core

protocol MovieContextProvider {
    var viewModel : MoviesViewModel! { get set }
    func provideContext() async -> [MovieEntity]
    func provideMoreContext() async -> [MovieEntity]
    func resetContext()
}
