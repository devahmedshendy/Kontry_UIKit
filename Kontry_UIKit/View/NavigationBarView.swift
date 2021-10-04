//
//  NavigationBarView.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/26/21.
//

import UIKit

class NavigationBarView: UIView {

    //MARK: - Static Properties
    
    static let nibName = String(describing: NavigationBarView.self)
    
    //MARK: - Outlets
    
    var titleLabel: UILabel!
    var backButton: UIImageView!
    
    //MARK: - Properties
    
    var delegate: BackActionDelegate!
    
    //MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
    }

    private func initView() {
        titleLabel = UILabel()
        addSubview(titleLabel)
        
        backButton = UIImageView()
        addSubview(backButton)
        
        configureSelf()
        configureTitleLabel()
        configureBackButton()
    }
}

//MARK: - Outlets/Views Configuration

extension NavigationBarView {
    
    private func configureSelf() {
        self.clipsToBounds = true
        self.isOpaque = false
        self.layer.cornerRadius = CGFloat(25.0)
        self.layer.borderColor = Asset.Color.navigationBarShadow.cgColor
        self.layer.borderWidth = 0.2
        self.backgroundColor = Asset.Color.screenBackground
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title2)
        titleLabel.textColor = Asset.Color.text
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        
        // Constraint Configuration
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureBackButton() {
        backButton.image = UIImage(
            systemName: "chevron.backward.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                font: UIFont.systemFont(ofSize: 20),
                scale: UIImage.SymbolScale.large
            )
        )
        backButton.contentMode = .scaleAspectFit
        backButton.tintColor = Asset.Color.text
        backButton.isUserInteractionEnabled = true
        
        let goBackGesture = UITapGestureRecognizer(target: self, action: #selector(goBack))
        backButton.addGestureRecognizer(goBackGesture)
        
        // Constraint Configuration
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            backButton.topAnchor.constraint(equalTo: self.topAnchor),
            backButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc private func goBack(_ sender: UITapGestureRecognizer) {
        delegate.didPressBack()
    }
}