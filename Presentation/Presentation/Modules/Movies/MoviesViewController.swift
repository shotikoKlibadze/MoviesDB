//
//  MoviesViewController.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 12.03.22.
//

import UIKit
import Core
import ProgressHUD
import RxSwift

public class MoviesViewController: MDBViewController {
    
    let bag = DisposeBag()
    var viewModel: MoviesViewModel!
    
    var upcomingMovies = [Movie]()
    
    var topRatedMovies = [Movie]()

    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        getMovies()
    }
    
    private func bind() {
        ProgressHUD.show()
        viewModel.getUpcomingMovies()
        viewModel.upcomingMoviesPR.subscribe(onNext: { [weak self] movies in
            ProgressHUD.dismiss()
            self?.upcomingMovies = movies
        }).disposed(by: bag)
        viewModel.moviesErrorPR.subscribe(onNext: { error in
            ProgressHUD.dismiss()
            Util.showAllert(viewController: self, title: "Unexpected Error", message: error.errorMessage)
        }).disposed(by: bag)
    }
    
    func getMovies(){
        ProgressHUD.show()
        Task {
            do {
                topRatedMovies = try await viewModel.getTopRatedMovies()
                ProgressHUD.dismiss()
            } catch (let error) {
                guard let error = error as? DBError else {return}
                print(error)
            }
        }
    }
    



}
