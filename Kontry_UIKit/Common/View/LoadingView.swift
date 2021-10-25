//
//  ContentLoadingView.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/23/21.
//

import UIKit

class LoadingView: UIView {

    //MARK: - Static Properties
    
    static let nibName = String(describing: LoadingView.self)
    
    //MARK: - Views
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    //MARK: - Inits
    
    override init(frame: CGRect) { // For using LoadingView in code
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) { // For using LoadingView in IB
        super.init(coder: coder)
    
        initView()
    }
    
    private func initView() {
        guard let nib = Bundle.main.loadNibNamed(LoadingView.nibName, owner: self, options: nil),
              let nibView = nib.first as? UIView
        else {
            fatalError("Couldn't load LoadingView from nib!")
        }
        
        nibView.frame = self.bounds
        
        addSubview(nibView)
    }
}

//MARK: - Views Configuraion

extension LoadingView {
    
}
