//
//  TabBarItemView.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 07.04.22.
//


import UIKit
import SnapKit


final class TabBarItemView: UIView {
    
    private let nameLabel = UILabel()
    private let iconImageView = UIImageView()
    private let underlineView = UIView()
    private let containerView = UIView()
    let index: Int
    
    var isSelected = false {
        didSet {
            animateItems()
        }
    }
    
    private let item: TabBarItem
    
    init(with item: TabBarItem, index: Int) {
        self.item = item
        self.index = index
        
        containerView.backgroundColor = .brown
        
        super.init(frame: .zero)
        
        backgroundColor = .brown
      //  iconImageView.backgroundColor = .red
        
        setupHierarchy()
        setupLayout()
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(containerView)
        containerView.addSubviews(nameLabel, iconImageView, underlineView)
    }
    
    private func setupLayout() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor ),
            iconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.widthAnchor.constraint(equalToConstant: 40)
        ])
        
        
        
//        iconImageView.snp.makeConstraints {
//            $0.height.width.equalTo(40)
//            $0.top.equalToSuperview()
//            $0.bottom.equalToSuperview()
//            $0.centerX.equalToSuperview()
//        }

//        nameLabel.snp.makeConstraints {
//            $0.bottom.leading.trailing.equalToSuperview()
//            $0.height.equalTo(16)
//        }

//        underlineView.snp.makeConstraints {
//            $0.width.equalTo(40)
//            $0.height.equalTo(4)
//            $0.centerX.equalToSuperview()
//            $0.centerY.equalTo(nameLabel.snp.centerY)
//        }
    }
    
    private func setupProperties() {
        nameLabel.configureWith(item.name,
                                color: .white.withAlphaComponent(0.4),
                                alignment: .center,
                                size: 11,
                                weight: .semibold)
        underlineView.backgroundColor = .white
        underlineView.setupCornerRadius(2)
        iconImageView.image = isSelected ? item.selectedIcon : item.icon
    }
    
    private func animateItems() {
        UIView.animate(withDuration: 0.4) { [unowned self] in
            self.nameLabel.alpha = self.isSelected ? 0.0 : 1.0
            self.underlineView.alpha = self.isSelected ? 1.0 : 0.0
        }
        UIView.transition(with: iconImageView,
                          duration: 0.4,
                          options: .transitionCrossDissolve) { [unowned self] in
            self.iconImageView.image = self.isSelected ? self.item.selectedIcon : self.item.icon
        }
    }
}
