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
    
    var country: Country? {
        didSet {
            subscription = vm
                .get160WidthFlag(countryCode: country!.code)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .finished:
                            break
                            
                        case .failure(.notFound):
                            self?.image = Asset.Placeholder.w200FlagError
                            break
                            
                        case .failure(.network(let error)),
                             .failure(.unknown(let error)):
                            print(error)
                            break
                        }
                    },
                    receiveValue: { [weak self] imageData in
                        self?.image = UIImage(data: imageData)
                    })
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
}
