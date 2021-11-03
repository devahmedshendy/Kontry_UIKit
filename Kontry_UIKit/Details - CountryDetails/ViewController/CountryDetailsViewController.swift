//
//  CountryDetailsViewController.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/23/21.
//

import UIKit
import MapKit
import Combine

// Responsibility:
// This screen displays more details about specific country.
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
        
        configureViewModel()
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
    
    //MARK: - ViewModel & DataBinding Methods
    
    private func configureViewModel() {
        vm = CountryDetailsViewModel(
            alpha2Code: country!.alpha2Code,
            countriesRepository: TheCountriesRepository(
                jsonDecoder: JSONDecoder(),
                remoteCountriesSource: RestCountriesSource(),
                localPersistenceSource: CoreDataSource()
            ),
            loadingViewModel: TheVisibilityViewModel(),
            retryErrorViewModel: TheVisibilityViewModel()
        )
        
        bindToDetailsPublisher()
        bindToLoadingPublisher()
        bindToRetryErrorPublisher()
        
        vm.loadDetails()
    }
    
    private func bindToDetailsPublisher() {
        vm.detailsPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] details in
                let mapRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: details.coordinate.latitude,
                                                   longitude: details.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25)
                )
                
                self?.mapView.setRegion(mapRegion, animated: false)
                
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
                    self?.hideRetryErrorView()
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

//MARK: - Delegates

//MARK: RetryDelegate
extension CountryDetailsViewController: RetryDelegate {
    func didPressRetry() {
        vm.retryLoadDetails()
        flagImageView.loadFlag()
    }
}

//MARK: NavigateBackDelegate
extension CountryDetailsViewController: NavigateBackDelegate {
    func didPressBack() {
        navigationController?.popViewController(animated: true)
    }
}
