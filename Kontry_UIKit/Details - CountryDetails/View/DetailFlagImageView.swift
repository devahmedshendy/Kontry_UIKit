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
    
    private var vm: FlagViewModel!
    private var subscription: AnyCancellable?
    
    var country: CountryDto? {
        didSet {
            vm.alpha2Code = country!.alpha2Code
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
        
        configureViewModel()
    }
    
    //MARK: - ViewModel & DataBinding Methods
    
    private func configureViewModel() {
        vm = FlagViewModel(
            size: .w160,
            flagsRepository: TheFlagsRepository(
                jsonDecoder: JSONDecoder(),
                remoteFlagsSource: FlagPediaSource(),
                localPersistenceSource: CoreDataSource()
            )
        )
        
        bindToData()
        
        vm.loadFlag()
    }
    
    private func bindToData() {
        subscription = vm.dataPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] image in
                guard let self = self else { return }
                
                guard let image = image else {
                    self.image = Asset.Placeholder.w200FlagError
                    return
                }
                
                self.image = UIImage(data: image)
            })
    }
    
    //MARK: - Helper Methods
    
    func loadFlag() {
        vm.loadFlag()
    }
}
