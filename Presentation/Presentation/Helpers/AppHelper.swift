//
//  Utils.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 18.03.22.
//

import Foundation
import UIKit

public class AppHelper {
    
    static let imagePathPrefix = "https://image.tmdb.org/t/p/w500"
    
    static func showAllert(viewController: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let allertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            allertController.addAction(okAction)
            viewController.present(allertController, animated: true)
        }
    }
    
    static let genres = [28: "Action",
                         12: "Adventure",
                         16: "Animation",
                         35: "Comedy",
                         80: "Crime",
                         99: "Documentary",
                         18: "Drama",
                         10751: "Family",
                         14: "Fantasy",
                         36: "History",
                         27: "Horror",
                         10402: "Music",
                         9648: "Mystery",
                         10749: "Romance",
                         878: "Science Fiction",
                         10770: "TV Movie",
                         53: "Thriller",
                         10752: "War",
                         37: "Western"]
    
}
