//
//  NetworkManager.swift
//  Core
//
//  Created by Shotiko Klibadze on 18.03.22.
//

import Foundation


public class NetworkManager<Model:Codable> {
    
    public static var shared : NetworkManager<Model> {
        return NetworkManager<Model>()
    }
    
    private init() { }
    
//    func sendRequest(path: String, completion: @escaping (Result<Model?, DBError>) -> Void) {
//        guard let url = URL(string: path) else {
//            print("Problem with url")
//            return
//        }
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }
//            guard let data = data else { return }
//            do {
//                let data = try JSONDecoder().decode(Model.self, from: data)
//                completion(.success(data))
//            } catch {
//                let error = DBError(errorMessage: "Error Parsing Data", debugMessage: path)
//                print(error)
//                completion(.failure(error))
//            }
//        }.resume()
//    }
    
    func sendRequest(path: String) async -> Model? {
        guard let url = URL(string: path) else {
           let error =  DBError(errorMessage: "Unkown Error", debugMessage: "Bad URL", endPoint: path)
            ErrorHandler.shared.handleError(error: error)
            return nil
        }
        
        var model : Model?
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                let error = DBError(errorMessage: "Server Error", debugMessage: "HTTP Response Error", endPoint: path)
                ErrorHandler.shared.handleError(error: error)
                return nil
            }
            let modelToreturn = try JSONDecoder().decode(Model.self, from: data)
            model = modelToreturn
    
        } catch _ as URLError {
            let error = DBError(errorMessage: "Server Error", debugMessage: "URL Error", endPoint: path)
            ErrorHandler.shared.handleError(error: error)
        } catch _ as Swift.DecodingError {
           
            let error = DBError(errorMessage: "Unknown Error", debugMessage: "Error Parsing Data", endPoint: path)
            ErrorHandler.shared.handleError(error: error)
        } catch {
            let err = DBError(errorMessage: "Unkown Error", debugMessage: "Unknown Error", endPoint: path)
            ErrorHandler.shared.handleError(error: err)
        }
        
        return model
    }
    
}
