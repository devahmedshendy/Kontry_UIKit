//
//  CountryCell.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/26/21.
//

import UIKit
import Combine

class CountryCell: UICollectionViewCell {
    
    //MARK: - Views
    
    private(set) var cellBackgroundView: UIView!
    private(set) var nameLabel: UILabel!
    private(set) var flagImageView: UIImageView!
    
    //MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: CountryCell.self)
    
    //MARK: - Properties
    
    private var vm: FlagViewModel!
    private var subscription: AnyCancellable?
    
    var country: CountryDto? {
        didSet {
            nameLabel.text = country!.name
            vm.alpha2Code = country!.alpha2Code
        }
    }
    
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
        cellBackgroundView = UIView()
        nameLabel = UILabel()
        flagImageView = UIImageView(image: Asset.Placeholder.w25Flag)
        
        // Add The SubViews
        addSubview(cellBackgroundView)
        addSubview(flagImageView)
        addSubview(nameLabel)
        
        configureBackgroundView()
        configureFlagImageView()
        configureNameLabel()
        
        configureViewModel()
    }
    
    //MARK: - LifeCycle Methods
    
    override func prepareForReuse() {
        flagImageView.image = Asset.Placeholder.w25Flag
    }
    
    //MARK: - ViewModel & DataBinding Methods
    
    private func configureViewModel() {
        vm = FlagViewModel(
            size: .w40,
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
                    self.flagImageView.image = Asset.Placeholder.w25FlagError
                    return
                }
                
                self.flagImageView.image = UIImage(data: image)
            })
    }
}

//MARK: - Views Configuration

extension CountryCell {
    private func configureBackgroundView() {
        cellBackgroundView.layer.borderWidth = CGFloat(1)
        cellBackgroundView.layer.borderColor = Asset.Color.countryCellBorder.cgColor
        cellBackgroundView.layer.cornerRadius = CGFloat(10)
        
        // Constraint Configuration
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            cellBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellBackgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureFlagImageView() {
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.clipsToBounds = true
        
        // Constraint Configuration
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0),
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            flagImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 32.0)
        ])
    }
    
    private func configureNameLabel() {
        nameLabel.font = UIFont(name: "Helvetica Neue", size: 16.0)
        nameLabel.numberOfLines = 1
        nameLabel.textColor = Asset.Color.text
        
        // Constraint Configuration
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: flagImageView.trailingAnchor, constant: 10.0),
            nameLabel.centerYAnchor.constraint(equalTo: flagImageView.centerYAnchor)
        ])
    }
}
