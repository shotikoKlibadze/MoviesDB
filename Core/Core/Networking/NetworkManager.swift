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
    
    func sendRequest(path: String, completion: @escaping (Result<Model?, DBError>) -> Void) {
        guard let url = URL(string: path) else {
            print("Problem with url")
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let data = data else { return }
            do {
                let data = try JSONDecoder().decode(Model.self, from: data)
                completion(.success(data))
            } catch {
                let error = DBError(errorMessage: "Error Parsing Data", endPoint: path)
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    func sendAsyncRequest(path: String) async throws -> Model {
        guard let url = URL(string: path) else {
            throw DBError(errorMessage: "Bad URL", endPoint: path)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw DBError(errorMessage: "Server Responded With Error", endPoint: path)
        }
        
        guard let data = try? JSONDecoder().decode(Model.self, from: data) else {
            throw DBError(errorMessage: "Error Parsing Data", endPoint: path)
        }
        
        return data
    }
    
}
