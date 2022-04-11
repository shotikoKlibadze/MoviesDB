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
    
    private lazy var customItemViews: [TabBarItemView] = [profileItem, searchItem]
    
    private let profileItem = TabBarItemView(with: .movies, index: 0)
    private let searchItem = TabBarItemView(with: .tvSeries, index: 1)
    
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
       
       //  someView.backgroundColor = .green
      //  addArrangedSubviews([profileItem, searchItem,UIView() ])
    }
    
    private func setupProperties() {
        distribution = .fillEqually
        alignment = .center
        spacing = 10
        backgroundColor = .green
        setupCornerRadius(30)
        
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
        profileItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.profileItem.animateClick {
                    self.selectItem(index: self.profileItem.index)
                }
            }
            .disposed(by: disposeBag)
        
        searchItem.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let self = self else { return }
                self.searchItem.animateClick {
                    self.selectItem(index: self.searchItem.index)
                }
            }
            .disposed(by: disposeBag)
        
    }
}
