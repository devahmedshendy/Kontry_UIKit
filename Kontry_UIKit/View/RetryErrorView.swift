//
//  RetryErrorView.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/23/21.
//

import UIKit

class RetryErrorView: UIView {
    
    //MARK: - Static Properties
    
    static let nibName = String(describing: RetryErrorView.self)
    
    //MARK: - Outlets
    
    @IBOutlet weak var stackview: UIStackView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var retryIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    
    var delegate: RetryErrorViewDelegate?
    
    //MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initRetryErrorView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initRetryErrorView()
    }

    private func initRetryErrorView() {
        loadNib()
        enlargeRetryIndicator()
        configureConstraints()
    }
    
    private func loadNib() {
        guard let nib = Bundle.main.loadNibNamed(RetryErrorView.nibName, owner: self, options: nil),
              let nibView = nib.first as? UIView
        else {
            fatalError("Couldn't load RetryErrorView from nib!")
        }
        
        nibView.frame = self.bounds
        
        addSubview(nibView)
    }
    
    private func enlargeRetryIndicator() {
        retryIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    //MARK: - Outlet Actions
    
    @IBAction func doRetry(_ sender: UIButton) {
        delegate?.didPressRetry()
    }
}

//MARK: - Constraints Configuration

extension RetryErrorView {
    
    func configureConstraints() {
        configureStackViewConstraints()
        configureRetryButtonConstraints()
        configureRetryIndicatorConstraints()
    }
    
    private func configureStackViewConstraints() {
        stackview.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // stackview.centerX = self.centerX
        constraints += [
            NSLayoutConstraint.init(
                item: stackview!, attribute: .centerX,
                relatedBy: .equal,
                toItem: self, attribute: .centerX,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // stackview.centerY = self.centerY
        constraints += [
            NSLayoutConstraint.init(
                item: stackview!, attribute: .centerY,
                relatedBy: .equal,
                toItem: self, attribute: .centerY,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureRetryButtonConstraints() {
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // retryButton.top = stackview.bottom
        constraints += [
            NSLayoutConstraint.init(
                item: retryButton!, attribute: .top,
                relatedBy: .equal,
                toItem: stackview!, attribute: .bottom,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // retryButton.bottom = self.bottom
        constraints += [
            NSLayoutConstraint.init(
                item: retryButton!, attribute: .bottom,
                relatedBy: .equal,
                toItem: self, attribute: .bottom,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // retryButton.leading = stackview.leading
        constraints += [
            NSLayoutConstraint.init(
                item: retryButton!, attribute: .leading,
                relatedBy: .equal,
                toItem: stackview!, attribute: .leading,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // retryButton.trailing = stackview.trailing
        constraints += [
            NSLayoutConstraint.init(
                item: retryButton!, attribute: .trailing,
                relatedBy: .equal,
                toItem: stackview!, attribute: .trailing,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
//        // retryButton.width = intrinsicWidth
//        constraints += [
//            NSLayoutConstraint.init(
//                item: retryButton!, attribute: .width,
//                relatedBy: .equal,
//                toItem: nil, attribute: .notAnAttribute,
//                multiplier: 1.0, constant: retryButton.intrinsicContentSize.width
//            )
//        ]
//
//        // retryButton.height = intrinsicHeight
//        constraints += [
//            NSLayoutConstraint.init(
//                item: retryButton!, attribute: .height,
//                relatedBy: .equal,
//                toItem: nil, attribute: .notAnAttribute,
//                multiplier: 1.0, constant: retryButton.intrinsicContentSize.height
//            )
//        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureRetryIndicatorConstraints() {
        retryIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // retryIndicator.centerX = retryButton.centerX
        constraints += [
            NSLayoutConstraint.init(
                item: retryIndicator!, attribute: .centerX,
                relatedBy: .equal,
                toItem: retryButton!, attribute: .centerX,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // retryIndicator.centerY = retryButton.centerY
        constraints += [
            NSLayoutConstraint.init(
                item: retryIndicator!, attribute: .centerY,
                relatedBy: .equal,
                toItem: retryButton!, attribute: .centerY,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
