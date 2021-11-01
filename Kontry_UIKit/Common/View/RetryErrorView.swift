//
//  RetryErrorView.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/23/21.
//

import UIKit

/*
 Clean this class from retryIndicator
 */
class RetryErrorView: UIView {
    
    //MARK: - Views
    
    private(set) var stackview: UIStackView!
    private(set) var imageView: UIImageView!
    private(set) var label: UILabel!
    private(set) var button: UIButton!
    
    //MARK: - Properties
    
    var delegate: RetryDelegate?
    
    //MARK: - init Methods
    
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
        imageView = UIImageView(image: Asset.Image.retryError)
        label = UILabel()
        button = UIButton()
        stackview = UIStackView(arrangedSubviews: [imageView, label])
        
        // Add The SubViews
        addSubview(stackview)
        addSubview(button)
        
        configureStackView()
        configureImageView()
        configureLabel()
        configureButton()
    }
}

//MARK: - Views Configuration

extension RetryErrorView {
    private func configureStackView() {
        stackview.axis = .vertical
        stackview.alignment = .fill
        stackview.distribution = .fill
        stackview.spacing = 0
        
        // Constraint Configuration
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackview.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackview.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }
    
    private func configureLabel() {
        label.text = Constant.Text.failedToFetchContent.uppercased()
        label.textColor = Asset.Color.text
        label.textAlignment = .natural
        label.font = UIFont(name: "Helvetica Neue", size: 14.0)
        label.numberOfLines = 1
    }
    
    private func configureButton() {
        button.setTitle(Constant.Text.retry.uppercased(), for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.textAlignment = .natural
        button.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 18.0)
        button.titleLabel?.numberOfLines = 1

        button.addTarget(self, action: #selector(doRetry(_:)), for: .touchUpInside)
        
        // Constraint Configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: stackview.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: stackview.trailingAnchor),
            button.topAnchor.constraint(equalTo: stackview.bottomAnchor),
            button.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc func doRetry(_ sender: UIButton) {
        delegate?.didPressRetry()
    }
}
