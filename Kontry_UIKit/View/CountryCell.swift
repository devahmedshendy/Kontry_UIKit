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
    
    private let vm = CountryCellViewModel()
    private var subscription: AnyCancellable?
    
    var country: Country? {
        didSet {
            nameLabel.text = country!.name
            
            subscription = vm
                .get24PixelFlag(countryCode: country!.code)
                .receive(on: RunLoop.main)
                .sink(
                    receiveCompletion: { [weak self] completion in
                        switch completion {
                        case .finished:
                            break
                            
                        case .failure(.flagNotFound):
                            self?.flagImageView.image = UIImage(named: "flag_error_placeholder")
                            break
                            
                        case .failure(.network(let error)),
                             .failure(.unknown(let error)):
                            print(error)
                            break
                        }
                    },
                    receiveValue: { [weak self] imageData in
                        self?.flagImageView.image = UIImage(data: imageData)
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
        flagImageView.image = UIImage(named: "flag_placeholder")
        subscription?.cancel()
        subscription = nil
    }
}

//MARK: - Cell UI Methods

extension CountryCell {
    private func configureCellUI() {
        flagImageView.image = UIImage(named: "flag_placeholder")
        
        cellBackgroundView.layer.borderWidth = CGFloat(1)
        cellBackgroundView.layer.borderColor = UIColor(named: "list-border-color")?.cgColor
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