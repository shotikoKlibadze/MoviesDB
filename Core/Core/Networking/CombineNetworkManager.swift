//
//  CombineNetworkManager.swift
//  Core
//
//  Created by Shotiko Klibadze on 01.06.22.
//

import Foundation
import Combine
import SwiftUI

public class CombineNetworkManager<Model:Codable> {
    
    private let decoder = JSONDecoder()
    private let networkQueue = DispatchQueue(label: "Network", qos: .default, attributes: .concurrent)
    
    public static var shared : CombineNetworkManager<Model> {
        return CombineNetworkManager<Model>()
    }
    
    private init() { }
    
    public func sendRequest(path: String) -> AnyPublisher<Model,Error> {
        
        guard let url = URL(string: path) else {
           let error =  DBError(errorMessage: "Server Error", debugMessage: "Bad URL", endPoint: path)
            ErrorHandler.shared.handleError(error: error)
            return Empty().eraseToAnyPublisher()
        }

       return URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: networkQueue)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse, response.statusCode == 200 else {
                    let error = DBError(errorMessage: "Server Error", debugMessage: "HTTP Response Error", endPoint: path)
                    ErrorHandler.shared.handleError(error: error)
                    throw error
                }
                return element.data
            }
            .decode(type: Model.self, decoder: decoder)
            .mapError { error -> Error in
                switch error {
                case is URLError :
                    let error = DBError(errorMessage: "Server Error", debugMessage: "URL Error", endPoint: path)
                    ErrorHandler.shared.handleError(error: error)
                    return error
                case is Swift.DecodingError :
                    let error = DBError(errorMessage: "Server Error", debugMessage: "Parsing Error", endPoint: path)
                    ErrorHandler.shared.handleError(error: error)
                    return error
                default :
                    let error = DBError(errorMessage: "Server Error", debugMessage: "Unknown Error", endPoint: path)
                    ErrorHandler.shared.handleError(error: error)
                    return error
                }
            }
            .map({ data -> Model in
                let model = data
                return model
            })
            .eraseToAnyPublisher()
    }
}
