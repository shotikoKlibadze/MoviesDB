//
//  TabBarItemView.swift
//  Presentation
//
//  Created by Shotiko Klibadze on 07.04.22.
//


import UIKit
import SnapKit

final class TabBarItemView: UIView {
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue", size: 11)
        label.textColor = .systemGray2
        return label
    }()
    
    private let iconImageView = UIImageView()
    
    let underlineView : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
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
        super.init(frame: .zero)
        setupHierarchy()
        setupProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHierarchy() {
        addSubview(iconImageView)
        addSubview(nameLabel)
        addSubview(underlineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
    
    private func setupLayout() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -10).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.heightAnchor.constraint(equalToConstant: 16).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: iconImageView.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor).isActive = true
        
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true
        underlineView.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        underlineView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 4).isActive = true
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
