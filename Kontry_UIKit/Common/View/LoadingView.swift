//
//  ContentLoadingView.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/23/21.
//

import UIKit

class LoadingView: UIView {
    
    //MARK: - Views
    
    private(set) var stackView: UIStackView!
    private(set) var imageView: UIImageView!
    private(set) var label: UILabel!
    
    //MARK: - init Methods
    
    override init(frame: CGRect) { // For using LoadingView in code
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) { // For using LoadingView in IB
        super.init(coder: coder)
    
        initView()
    }
    
    private func initView() {
        // Create The SubViews
        imageView = UIImageView(image: Asset.Image.loading)
        label = UILabel()
        stackView = UIStackView(arrangedSubviews: [imageView, label])
        
        // Add The SubViews
        addSubview(stackView)
        
        configureStackView()
        configureImageView()
        configureLabel()
    }
}

//MARK: - Views Configuraion

extension LoadingView {
    private func configureStackView() {
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        
        // Constraint Configuration
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        // Constraint Configuration
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 50.0),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    private  func configureLabel() {
        label.text = Constant.Text.loading.uppercased()
        label.textAlignment = .natural
        label.textColor = Asset.Color.text
        label.font = UIFont(name: "Helvetica Neue", size: 14.0)
        label.numberOfLines = 1
    }
}
