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
    var upcomingMovies = [Movie]() {
        didSet {
            print(upcomingMovies.count)
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        bind()
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
    



}
