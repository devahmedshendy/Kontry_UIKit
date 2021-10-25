//
//  CountryCell.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/26/21.
//

import UIKit
import Combine

class CountryCell: UICollectionViewCell {
    
    //MARK: - Static Properties
    
    static let reuseIdentifier = String(describing: CountryCell.self)
    
    //MARK: - Views
    
    private(set) var cellBackgroundView: UIView!
    private(set) var nameLabel: UILabel!
    private(set) var flagImageView: UIImageView!
    
    //MARK: - Properties
    
    private let vm = FlagViewModel()
    private var subscription: AnyCancellable?
    
    var country: CountryDto? {
        didSet {
            loadFlag()
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
    }
    
    //MARK: - Life Cycle Methods
    
    override func prepareForReuse() {
        flagImageView.image = Asset.Placeholder.w25Flag
        subscription?.cancel()
        subscription = nil
    }
    
    //MARK: - Helper Methods
    
    private func loadFlag() {
        nameLabel.text = country!.name
        
        subscription = vm
            .get40WidthFlag(alpha2Code: country!.alpha2Code)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print(error)
                    }
                },
                receiveValue: { [weak self] image in
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
            flagImageView.widthAnchor.constraint(equalToConstant: 30.0)
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
