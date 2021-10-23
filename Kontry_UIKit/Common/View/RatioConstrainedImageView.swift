//
//  RatioConstrainedImageView.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/29/21.
//

import UIKit

class RatioConstrainedImageView: UIImageView {
    
    //MARK: - Properties
    
    private var currentRatioConstraint: NSLayoutConstraint?
    
    override var image: UIImage? {
        didSet {
            updateRatioConstraint()
        }
    }
    
    //MARK: - Init Methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        initView()
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
        
        initView()
    }
    
    private func initView() {
        self.contentMode = .scaleAspectFit
        self.updateRatioConstraint()
    }
    
    private func updateRatioConstraint() {
        if let currentConstraint = currentRatioConstraint {
            self.removeConstraint(currentConstraint)
        }
        
        currentRatioConstraint = nil
        
        if let image = image {
            let aspectRatio = image.size.width / image.size.height
                        
            currentRatioConstraint = self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: aspectRatio)
            
            NSLayoutConstraint.activate([currentRatioConstraint!])
        }
    }
}
