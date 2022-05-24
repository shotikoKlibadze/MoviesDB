//
//  TabBar.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 07.04.22.
//


import UIKit
import RxSwift
import RxCocoa
import RxGesture

final class TabBar: UIStackView {
    
    var itemTapped: Observable<Int> { itemTappedSubject.asObservable() }
    
    private lazy var customItemViews: [TabBarItemView] = [movieItem, tvItem]
    
    private let movieItem = TabBarItemView(with: .movies, index: 0)
    private let tvItem = TabBarItemView(with: .tvSeries, index: 1)
    
    private let itemTappedSubject = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        setupHierarchy()
        setupProperties()
        bind()
        setNeedsLayout()
        layoutIfNeeded()
        selectItem(index: 0)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        customItemViews.forEach({addArrangedSubview($0)})
    
//        addArrangedSubview(movieItem)
//        addArrangedSubview(tvItem)
    }
    
    private func setupProperties() {
        distribution = .fillEqually
       // alignment = .fill
        
       // spacing = 5
       
        backgroundColor = UIColor.DBGreen()
       // setupCornerRadius(30)
        layer.cornerRadius = 30
        layer.masksToBounds = true
        customItemViews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.clipsToBounds = true
        }
    }
    
    private func selectItem(index: Int) {
        customItemViews.forEach { $0.isSelected = $0.index == index }
        itemTappedSubject.onNext(index)
    }
    
    //MARK: - Bindings
    
    private func bind() {
        movieItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.movieItem.animateClick {
                    self.selectItem(index: self.movieItem.index)
                }
            }
            .disposed(by: disposeBag)
        
        tvItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.tvItem.animateClick {
                    self.selectItem(index: self.tvItem.index)
                }
            }
            .disposed(by: disposeBag)
    }
}
