//
//  CountryDetailsViewController+View.swift
//  Kontry_UIKit
//
//  Created by Ahmed Shendy on 10/31/21.
//

import Foundation
import UIKit

//MARK: - SubViews Configurations

extension CountryDetailsViewController {
    
    func configureLoadingView() {
        
        // Constraint Configuration
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 50.0),
            loadingView.heightAnchor.constraint(equalTo: loadingView.heightAnchor)
        ])
    }
    
    func configureRetryErrorView() {
        retryErrorView.delegate = self
        
        // Constraint Configuration
        
        retryErrorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            retryErrorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            retryErrorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            retryErrorView.topAnchor.constraint(equalTo: view.topAnchor),
            retryErrorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureNavigationBarView() {
        navigationBarView.delegate = self
        navigationBarView.titleLabel.text = country?.name ?? "?????"
        
        // Constraint Configuration
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            navigationBarView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            navigationBarView.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    func configureMapView() {
        
        // Constraints Configuration
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    func configureFlagImageView() {
        flagImageView.country = country
        
        // Constraints Configuration
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25.0),
            flagImageView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -25.0),
            flagImageView.widthAnchor.constraint(equalToConstant: 125.0),
        ])
    }
    
    func configureDetailStack() {
        detailStackview.axis = .vertical
        detailStackview.alignment = .fill
        detailStackview.distribution = .fillEqually
        detailStackview.spacing = 15
        
        capitalDetailView.iconImage.image = Asset.Icon.capital
        capitalDetailView.titleLabel.text = "CAPITAL"
        regionDetailView.iconImage.image = Asset.Icon.region
        regionDetailView.titleLabel.text = "REGION"
        populationDetailView.iconImage.image = Asset.Icon.population
        populationDetailView.titleLabel.text = "POPULATION"
        currencyDetailView.iconImage.image = Asset.Icon.currency
        currencyDetailView.titleLabel.text = "CURRENCY"
        languageDetailView.iconImage.image = Asset.Icon.language
        languageDetailView.titleLabel.text = "LANGUAGE"
        
        // Constraints Configuration
        detailStackview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailStackview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            detailStackview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

// MARK: - Dynamic Constraints Configurations

extension CountryDetailsViewController {
    // Here I set - for first time whether in Regular or Compact height - the other left constraints required for all views,
    // which later they would need to change for screen rotation
    func configureDynamicConstraints() {
        var constraints = view.constraints
        NSLayoutConstraint.deactivate(constraints)
        
        if traitCollection.isRegularHeight {
            let navigationBarViewTop = navigationBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.windows.first!.safeAreaInsets.top)
            navigationBarViewTop.identifier = Constant.ConstraintIdentifier.navigationBarViewTop
            
            let mapViewLeading = mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            mapViewLeading.identifier = Constant.ConstraintIdentifier.mapViewLeading
            
            let mapViewHeight = mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.6)
            mapViewHeight.identifier = Constant.ConstraintIdentifier.mapViewHeight
            
            let detailStackTrailing = detailStackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            detailStackTrailing.identifier = Constant.ConstraintIdentifier.detailStackTrailing
            
            let detailStackTop = detailStackview.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20)
            detailStackTop.identifier = Constant.ConstraintIdentifier.detailStackTop
            
            let detailStackWidth = detailStackview.widthAnchor.constraint(lessThanOrEqualToConstant: 480)
            detailStackWidth.identifier = Constant.ConstraintIdentifier.detailStackWidth
            
            constraints += [
                navigationBarViewTop, mapViewLeading, mapViewHeight,
                detailStackTrailing, detailStackTop, detailStackWidth
            ]
            
        } else { // isCompactHeight
            let navigationBarViewTop = navigationBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
            navigationBarViewTop.identifier = Constant.ConstraintIdentifier.navigationBarViewTop
            
            let mapViewBottom = mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            mapViewBottom.identifier = Constant.ConstraintIdentifier.mapViewBottom
            
            let mapViewWidth = mapView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.50)
            mapViewWidth.identifier = Constant.ConstraintIdentifier.mapViewWidth
            
            let detailStackTrailing = detailStackview.trailingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: -20)
            detailStackTrailing.identifier = Constant.ConstraintIdentifier.detailStackTrailing
            
            let detailStackTop = detailStackview.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: 20)
            detailStackTop.identifier = Constant.ConstraintIdentifier.detailStackTop
            
            constraints += [
                navigationBarViewTop, mapViewBottom, mapViewWidth,
                detailStackTrailing, detailStackTop
            ]
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func reConfigureDynamicConstraints() {
        var constraints = view.constraints
        NSLayoutConstraint.deactivate(constraints)
        
        // It means screen rotated from Compact to Regular height
        // Clean all Compact-specific constraints, then reassign Regular constraints
        if traitCollection.isRegularHeight {
            constraints.remove(at: constraints.firstIndex { $0.identifier == Constant.ConstraintIdentifier.mapViewBottom }!)
            
            mapView.constraints.first(where: { $0.identifier == Constant.ConstraintIdentifier.mapViewWidth})?.isActive = false
            
            let navigationBarViewTopIndex = constraints.firstIndex { $0.identifier == Constant.ConstraintIdentifier.navigationBarViewTop }
            constraints[navigationBarViewTopIndex!] = navigationBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.windows.first!.safeAreaInsets.top)
            constraints[navigationBarViewTopIndex!].identifier = Constant.ConstraintIdentifier.navigationBarViewTop
            
            let mapViewLeading = mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
            mapViewLeading.identifier = Constant.ConstraintIdentifier.mapViewLeading
            constraints.append(mapViewLeading)
            
            let mapViewHeight = mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.6)
            mapViewHeight.identifier = Constant.ConstraintIdentifier.mapViewHeight
            constraints.append(mapViewHeight)
            
            let detailStackTrailingIndex = constraints.firstIndex { $0.identifier == Constant.ConstraintIdentifier.detailStackTrailing }
            constraints[detailStackTrailingIndex!] = detailStackview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            constraints[detailStackTrailingIndex!].identifier = Constant.ConstraintIdentifier.detailStackTrailing
            
            let detailStackTopIndex = constraints.firstIndex { $0.identifier == Constant.ConstraintIdentifier.detailStackTop }
            constraints[detailStackTopIndex!] = detailStackview.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 20)
            constraints[detailStackTopIndex!].identifier = Constant.ConstraintIdentifier.detailStackTop
            
            let detailStackWidth = detailStackview.widthAnchor.constraint(lessThanOrEqualToConstant: 480)
            detailStackWidth.identifier = Constant.ConstraintIdentifier.detailStackWidth
            constraints.append(detailStackWidth)
            
            // It means screen rotated from Regular to Compact height
            // Clean all Regular-specific constraints, then reassign Compact constraints
        } else { // isCompactHeight
            constraints.remove(at: constraints.firstIndex { $0.identifier == Constant.ConstraintIdentifier.mapViewLeading }!)
            
            detailStackview.constraints.first(where: { $0.identifier == Constant.ConstraintIdentifier.detailStackWidth})?.isActive = false
            mapView.constraints.first(where: { $0.identifier == Constant.ConstraintIdentifier.mapViewHeight })?.isActive = false
            
            let navigationBarViewTopIndex = constraints.firstIndex { $0.identifier == Constant.ConstraintIdentifier.navigationBarViewTop }
            constraints[navigationBarViewTopIndex!] = navigationBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)
            constraints[navigationBarViewTopIndex!].identifier = Constant.ConstraintIdentifier.navigationBarViewTop
            
            let mapViewBottom = mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            mapViewBottom.identifier = Constant.ConstraintIdentifier.mapViewBottom
            constraints.append(mapViewBottom)
            
            let mapViewWidth = mapView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.5)
            mapViewWidth.identifier = Constant.ConstraintIdentifier.mapViewWidth
            constraints.append(mapViewWidth)
            
            let detailStackTrailingIndex = constraints.firstIndex { $0.identifier == Constant.ConstraintIdentifier.detailStackTrailing }
            constraints[detailStackTrailingIndex!] = detailStackview.trailingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: -20)
            constraints[detailStackTrailingIndex!].identifier = Constant.ConstraintIdentifier.detailStackTrailing
            
            let detailStackTopIndex = constraints.firstIndex { $0.identifier == Constant.ConstraintIdentifier.detailStackTop }
            constraints[detailStackTopIndex!] = detailStackview.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: 20)
            constraints[detailStackTopIndex!].identifier = Constant.ConstraintIdentifier.detailStackTop
        }
        
        NSLayoutConstraint.activate(constraints)
    }
}
