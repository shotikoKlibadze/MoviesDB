//
//  FavoriteMoviesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 15.05.22.
//

import UIKit
import Core
import ProgressHUD

class FavoriteMoviesViewController: DBViewController {
    
    var tableView: UITableView = {
        let table = UITableView()
        table.register(FavoriteMovieTableViewCell.self, forCellReuseIdentifier: FavoriteMovieTableViewCell.identifier)
        table.separatorStyle = .none
        return table
    }()
    
    var moviesViewModel : MoviesViewModel?
    var tvSeriesViewModel : TvSeriesViewModel?
    
    var movies = [MovieEntity]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.fillSuperview()
    }
    
    private func fetchMovies() {
       // ProgressHUD.show()
        Task {
            guard let tvSeriesViewModel = tvSeriesViewModel else {
                if let moviesViewModel = moviesViewModel {
                    let movies = await moviesViewModel.getFavoriteMovies()
                    self.movies = movies
                }
                return
            }
            
            let movies = await tvSeriesViewModel.getFavoriteTvSeries()
            self.movies = movies
        }
    }
}

extension FavoriteMoviesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteMovieTableViewCell.identifier, for: indexPath) as? FavoriteMovieTableViewCell else {
            fatalError()
        }
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (action, view, completion) in
            self?.deleteCell(at: [indexPath])
            completion(true)
        }
        deleteAction.image = UIImage(named: "Delete", in: .presentationBundle, with: nil)
        deleteAction.backgroundColor = .systemBackground
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    
    private func deleteCell(at indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        let itemsToRemove = indexPaths.map({movies[$0.row]})
        movies.removeAll { movie in
            itemsToRemove.contains(where: {$0.id == movie.id})
        }
        tableView.deleteRows(at: indexPaths, with: .automatic)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = BrowseFavoriteMoviesViewController()
        vc.movies = movies
        vc.movie = movies[indexPath.row]
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

