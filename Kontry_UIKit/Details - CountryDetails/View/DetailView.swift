//
//  DetailView.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/30/21.
//

import UIKit

class DetailView: UIView {
    
    //MARK: - Views
    
    private(set) var iconImage: UIImageView!
    private(set) var titleLabel: UILabel!
    private(set) var valueLabel: UILabel!

    //MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
    }
    
    private func initView() {
        // Create The SubViews
        iconImage = UIImageView(image: UIImage(named: "Value"))
        titleLabel = UILabel()
        valueLabel = UILabel()
        
        // Add The SubViews
        addSubview(iconImage)
        addSubview(titleLabel)
        addSubview(valueLabel)
        
        configureBackgroundView()
        configureIconImage()
        configureTitleLabel()
        configureValueLabel()
    }
}

//MARK: - Views Configuration

extension DetailView {
    private func configureBackgroundView() {
        self.backgroundColor = Asset.Color.detailViewBackground
        self.layer.cornerRadius = CGFloat(10)
        self.clipsToBounds = true
    }
    
    private func configureIconImage() {
        iconImage.contentMode = .scaleAspectFit
        
        // Constraint Configuration
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            iconImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            iconImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            iconImage.widthAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func configureTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        titleLabel.textColor = Asset.Color.text
        
        // Constraint Configuration
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: iconImage.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: iconImage.bottomAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    private func configureValueLabel() {
        valueLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        valueLabel.textColor = Asset.Color.text
        
        // Constraint Configuration
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            valueLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -15),
            valueLabel.topAnchor.constraint(equalTo: iconImage.topAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: iconImage.bottomAnchor)
        ])
    }
}
