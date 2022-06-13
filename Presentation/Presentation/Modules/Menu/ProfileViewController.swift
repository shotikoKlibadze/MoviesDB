//
//  ProfileTableViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 02.05.22.
//

import UIKit

class ProfileViewController: UITableViewController {
    
    let favorites = ["Favorite Movies", "Favorite TvSeries"]
    
    var tabBar : MainTabBarController?
    var parrentVC : BaseLayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray5
        tableView.separatorStyle = .none

    }
    
    override func didMove(toParent parent: UIViewController?) {
        guard let parent = parent as? BaseLayerViewController else {
            return
        }
        parrentVC = parent
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favorites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuTableViewCell(style: .default, reuseIdentifier: "FavoritesCell")
        cell.backgroundColor = .systemGray5
        cell.tittleLable.text = favorites[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let tabBar = tabBar else {
            return
        }
        
        if indexPath.row == 0 {
            let vc = FavoriteMoviesViewController()
            vc.moviesViewModel = Controller.moviesViewModel()
            tabBar.controller?.pushViewController(vc, animated: true)
        } else {
            let vc = FavoriteMoviesViewController()
            vc.tvSeriesViewModel = Controller.tvSeriesViewModel()
            tabBar.controller?.pushViewController(vc, animated: true)
        }
        parrentVC?.closeMenu()
    }
    


}
