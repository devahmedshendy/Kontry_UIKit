//
//  DetailFlagImageView.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/29/21.
//

import UIKit
import Combine

final class DetailFlagImageView: RatioConstrainedImageView {
    
    //MARK: - Properties
    
    private let vm = FlagViewModel()
    private var subscription: AnyCancellable?
    
    var country: CountryDto? {
        didSet {
            loadFlag()
        }
    }
    
    //MARK: - Init Methods
    
    convenience init() {
        self.init(image: Asset.Placeholder.w200Flag)
    }
    
    override init(frame: CGRect) {
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
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(15)
        self.layer.shadowColor = Asset.Color.detailFlagShadow.cgColor
        self.layer.shadowOffset = CGSize(width: 2.0, height: 3.0)
        self.layer.shadowRadius = CGFloat(10)
    }
    
    //MARK: - Helper Methods
    
    func loadFlag() {
        subscription = vm
            .get160WidthFlag(alpha2Code: country!.alpha2Code)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print(error)
                    }
                },
                receiveValue: { [weak self] image in
                    guard let image = image else {
                        self?.image = Asset.Placeholder.w200FlagError
                        return
                    }
                    
                    self?.image = UIImage(data: image)
                })
    }
}
