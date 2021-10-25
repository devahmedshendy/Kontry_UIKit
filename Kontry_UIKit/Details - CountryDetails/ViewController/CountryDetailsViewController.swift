//
//  CountryDetailsViewController.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/23/21.
//

import UIKit
import MapKit
import Combine

class CountryDetailsViewController: UIViewController {
    
    //MARK: - Views
    
    var navigationBarView: NavigationBarView!
    var mapView: MKMapView!
    var flagImageView: DetailFlagImageView!
    var detailStackview: UIStackView!
    var capitalDetailView: DetailView!
    var regionDetailView: DetailView!
    var populationDetailView: DetailView!
    var currencyDetailView: DetailView!
    var languageDetailView: DetailView!
    var loadingView: LoadingView!
    var retryErrorView: RetryErrorView!
    
    //MARK: - Properties
    
    private var vm: CountryDetailsViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    var country: CountryDto?
    
    //MARK: - LifeCycle Methods
    
    override func loadView() {
        super.loadView()
        
        navigationBarView = NavigationBarView()
        mapView = MKMapView()
        flagImageView = DetailFlagImageView()
        
        capitalDetailView = DetailView()
        regionDetailView = DetailView()
        populationDetailView = DetailView()
        currencyDetailView = DetailView()
        languageDetailView = DetailView()
        detailStackview = UIStackView(arrangedSubviews: [
            capitalDetailView, regionDetailView, populationDetailView,
            currencyDetailView, languageDetailView
        ])
        
        loadingView = LoadingView()
        retryErrorView = RetryErrorView()
        
        view.addSubview(mapView)
        view.addSubview(flagImageView)
        view.addSubview(detailStackview)
        view.addSubview(navigationBarView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBarView()
        configureMapView()
        configureFlagImageView()
        configureDetailStack()
        configureDynamicConstraints()
        
        vm = CountryDetailsViewModel(
            alpha2Code: country!.alpha2Code,
            countriesRepository: CountriesRepository(
                countriesApiService: RestCountriesService(),
                persistenceService: CoreDataService()
            ),
            loadingViewModel: VisibilityViewModel(),
            retryErrorViewModel: VisibilityViewModel()
        )
        
        bindToDetailsPublisher()
        bindToLoadingPublisher()
        bindToRetryErrorPublisher()
        
        vm.loadDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    //MARK: - RotateScreen Handler
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard let previousTraitCollection = previousTraitCollection else { return }
        
        if !(traitCollection.isRegularHeight && previousTraitCollection.isRegularHeight) {
            reConfigureDynamicConstraints()
        }
    }
    
    //MARK: - DataBinding Methods
    
    private func bindToDetailsPublisher() {
        vm.detailsPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] details in
                self?.mapView.setRegion(details.mapRegion, animated: false)
                
                self?.capitalDetailView.valueLabel.text = details.capital
                self?.regionDetailView.valueLabel.text = details.region
                self?.populationDetailView.valueLabel.text = details.population
                self?.currencyDetailView.valueLabel.text = details.currencies
                self?.languageDetailView.valueLabel.text = details.languages
                
                self?.showAllViews()
            })
            .store(in: &subscriptions)
    }
    
    private func bindToLoadingPublisher() {
        vm.loading
            .getPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] show in
                if show {
                    self?.hideAllViews()
                    self?.showLoadingView()
                } else {
                    self?.hideLoadingView()
                }
            })
            .store(in: &subscriptions)
    }
    
    private func bindToRetryErrorPublisher() {
        vm.retryError
            .getPublisher()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] show in
                if show {
                    self?.hideAllViews()
                    self?.showRetryErrorView()
                } else {
                    self?.hideRetryErrorView()
                }
            })
            .store(in: &subscriptions)
    }
    
    //MARK: - Helper Methods
    
    private func showLoadingView() {
        view.addSubview(loadingView)
        configureLoadingView()
    }
    
    private func hideLoadingView() {
        loadingView.removeFromSuperview()
    }
    
    private func showRetryErrorView() {
        view.addSubview(retryErrorView)
        configureRetryErrorView()
    }
    
    private func hideRetryErrorView() {
        retryErrorView.removeFromSuperview()
    }
    
    private func showAllViews   () {
        mapView.isHidden = false
        flagImageView.isHidden = false
        detailStackview.isHidden = false
    }
    
    private func hideAllViews() {
        mapView.isHidden = true
        flagImageView.isHidden = true
        detailStackview.isHidden = true
    }
}

//MARK: - Views Configurations

extension CountryDetailsViewController {
    
    private func configureLoadingView() {
        
        // Constraint Configuration
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 50.0),
            loadingView.heightAnchor.constraint(equalTo: loadingView.heightAnchor)
        ])
    }
    
    private func configureRetryErrorView() {
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
    
    private func configureNavigationBarView() {
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
    
    private func configureMapView() {
        
        // Constraints Configuration
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func configureFlagImageView() {
        flagImageView.country = country
        
        // Constraints Configuration
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -25.0),
            flagImageView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -25.0),
            flagImageView.widthAnchor.constraint(equalToConstant: 125.0),
        ])
    }
   
    private func configureDetailStack() {
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
    
    // Here I set - for first time whether in Regular or Compact height - the other left constraints required for all views,
    // which later they would need to change for screen rotation
    private func configureDynamicConstraints() {
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
    
    private func reConfigureDynamicConstraints() {
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

//MARK: - Delegates

//MARK: RetryErrorViewDelegate
extension CountryDetailsViewController: RetryErrorViewDelegate {
    func didPressRetry() {
        vm.retryLoadCountries()
        flagImageView.loadFlag()
    }
}

//MARK: BackActionDelegate
extension CountryDetailsViewController: BackActionDelegate {
    func didPressBack() {
        navigationController?.popViewController(animated: true)
    }
}
