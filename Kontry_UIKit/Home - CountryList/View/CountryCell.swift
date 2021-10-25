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
    static let nibName = String(describing: CountryCell.self)
    
    //MARK: - Outlets
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    
    //MARK: - Properties
    
    private let vm = FlagViewModel()
    private var subscription: AnyCancellable?
    
    var country: CountryDto? {
        didSet {
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
    
    //MARK: - Life Cycle Methods
    
    // The outlets have been hooked up and ready for use
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCellUI()
        configureCellConstraints()
    }
    
    override func prepareForReuse() {
        flagImageView.image = Asset.Placeholder.w25Flag
        subscription?.cancel()
        subscription = nil
    }
}

//MARK: - Cell UI Methods

extension CountryCell {
    private func configureCellUI() {
        flagImageView.image = Asset.Placeholder.w25Flag
        
        cellBackgroundView.layer.borderWidth = CGFloat(1)
        cellBackgroundView.layer.borderColor = Asset.Color.countryCellBorder.cgColor
        cellBackgroundView.layer.cornerRadius = CGFloat(10)
    }
}

//MARK: - Cell Constraints Methods

extension CountryCell {
    
    private func configureCellConstraints() {
        configureCellBackgroundViewConstraints()
        configureFlagImageViewConstraints()
        configureNameLabelConstraints()
    }
    
    private func configureCellBackgroundViewConstraints() {
        cellBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // cellBackgroundView.top = contentView.top
        constraints += [
            NSLayoutConstraint.init(
                item: cellBackgroundView!, attribute: .top,
                relatedBy: .equal,
                toItem: contentView, attribute: .top,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // cellBackgroundView.bottom = contentView.bottom
        constraints += [
            NSLayoutConstraint.init(
                item: cellBackgroundView!, attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView, attribute: .bottom,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // cellBackgroundView.leading = contentView.leading
        constraints += [
            NSLayoutConstraint.init(
                item: cellBackgroundView!, attribute: .leading,
                relatedBy: .equal,
                toItem: contentView, attribute: .leading,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // cellBackgroundView.trailing = contentView.trailing
        constraints += [
            NSLayoutConstraint.init(
                item: cellBackgroundView!, attribute: .trailing,
                relatedBy: .equal,
                toItem: contentView, attribute: .trailing,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureFlagImageViewConstraints() {
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // flagImageView.top = contentView.top
        constraints += [
            NSLayoutConstraint.init(
                item: flagImageView!, attribute: .top,
                relatedBy: .equal,
                toItem: contentView, attribute: .top,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // flagImageView.bottom = contentView.bottom
        constraints += [
            NSLayoutConstraint.init(
                item: flagImageView!, attribute: .bottom,
                relatedBy: .equal,
                toItem: contentView, attribute: .bottom,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // flagImageView.leading = contentView.leading + 10
        constraints += [
            NSLayoutConstraint.init(
                item: flagImageView!, attribute: .leading,
                relatedBy: .equal,
                toItem: contentView, attribute: .leading,
                multiplier: 1.0, constant: 15.0
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func configureNameLabelConstraints() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // countryNameLabel.centerY = flagImageView.centerY
        constraints += [
            NSLayoutConstraint.init(
                item: nameLabel!, attribute: .centerY,
                relatedBy: .equal,
                toItem: flagImageView, attribute: .centerY,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // countryNameLabel.leading = flagImageView.trailing + 10
        constraints += [
            NSLayoutConstraint.init(
                item: nameLabel!, attribute: .leading,
                relatedBy: .equal,
                toItem: flagImageView, attribute: .trailing,
                multiplier: 1.0, constant: 10.0
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}
