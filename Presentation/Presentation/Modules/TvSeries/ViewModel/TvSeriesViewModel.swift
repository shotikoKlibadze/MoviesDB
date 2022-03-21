//
//  TvSeriesViewModel.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import Foundation
import Core

public class TvSeriesViewModel {
    
    
    var dataSource : TvSeriesDataSourceInterface
    
    public init(dataSource: TvSeriesDataSourceInterface) {
        self.dataSource = dataSource
        
    }
    
    
    
}
