//
//  CountryListViewController.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 7/28/21.
//

import UIKit
import Combine

// Responsibility:
// It is the main screen.
// It displays list of all countries, and provide the option to search for countries by name.
class CountryListViewController: UIViewController {
    
    //MARK: - Views
    
    var collectionView: UICollectionView!
    var searchController: UISearchController!
    var loadingView: LoadingView!
    var retryErrorView: RetryErrorView!
    
    //MARK: - Properties
    
    var dataSource: UICollectionViewDiffableDataSource<Section, CountryDto>!
    
    private var vm: CountryListViewModel!
    private var subscriptions = Set<AnyCancellable>()
        
    //MARK: - Lifecycle Methods
    
    override func loadView() {
        super.loadView()
        
        // Create some custom views, and show/add them later when needed
        loadingView = LoadingView()
        retryErrorView = RetryErrorView()
        
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        searchController = UISearchController(searchResultsController: nil)
        
        view.addSubview(collectionView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSearchController()
        configureCollectionView()
        configureViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        bindToCountriesPublisher()
        bindToLoadingPublisher()
        bindToRetryErrorPublisher()
    }
    
    //MARK: - RotateScreen Handler
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureCollectionViewLayout()
    }
    
    //MARK: - ViewModel & DataBinding Methods
    
    private func configureViewModel() {
        vm = CountryListViewModel(
            countriesRepository: TheCountriesRepository(
                jsonDecoder: JSONDecoder(),
                remoteCountriesSource: RestCountriesSource(),
                localPersistenceSource: CoreDataSource()
            ),
            loadingViewModel: TheVisibilityViewModel(),
            retryErrorViewModel: TheVisibilityViewModel()
        )
        
        

        vm.loadCountries()
    }
    
    private func bindToCountriesPublisher() {
        vm.countriesPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] list in
                self?.refreshCollectionViewDataSource(with: list, animatingDifferences: true)
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
                    self?.showLoadingView()
                    self?.hideAllViews()
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
                    self?.showRetryErrorView()
                    self?.hideAllViews()
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
        collectionView.isHidden = false
    }
    
    private func hideAllViews() {
        collectionView.isHidden = true
    }
}

//MARK: - Delegates
//MARK: UICollectionViewDelegate
extension CountryListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CountryCell,
              let selectedCountry = cell.country
        else {
            return
        }
        
        performSegue(withIdentifier: "showCountryDetailSegue", sender: selectedCountry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CountryDetailsViewController,
           let selectedCountry = sender as? CountryDto {
            vc.country = selectedCountry
        }
    }
}

//MARK: - UISearchResultsUpdating
extension CountryListViewController: UISearchResultsUpdating {
    private var searchBarIsEmpty: Bool {
        return searchController.searchBar.text?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty ?? true
    }
    private var searchBarIsNotEmpty: Bool {
        return !searchBarIsEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchBarIsEmpty {
            vm.searchText = ""
            vm.clearCountryList()
            
        } else {
            let searchText = searchController.searchBar.text!
            if vm.searchText != searchText {
                vm.searchText = searchText
                vm.loadCountries()
            }
        }
        
        
    }
}

//MARK: UISearchBarDelegate
extension CountryListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        vm.searchText = ""
        vm.loadCountries()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBarIsEmpty {
            vm.clearCountryList()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBarIsEmpty {
            vm.searchText = ""
            vm.loadCountries()
        }
    }
}

//MARK: RetryDelegate
extension CountryListViewController: RetryDelegate {
    func didPressRetry() {
        vm.retryLoadCountries()
    }
}
