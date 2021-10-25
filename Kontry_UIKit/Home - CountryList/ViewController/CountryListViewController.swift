//
//  CountryListViewController.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 7/28/21.
//

import UIKit
import Combine

class CountryListViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    var loadingView: LoadingView!
    var retryErrorView: RetryErrorView!
    
    //MARK: - Stored Properties
    
    private var vm: CountryListViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, CountryDto>!
        
    //MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // Create some custom views, and show/add them later when needed
        loadingView = LoadingView()
        retryErrorView = RetryErrorView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureCollectionView()
        
        vm = CountryListViewModel(
            countriesRepository: CountriesRepository(
                countriesApiService: RestCountriesService(),
                persistenceService: CoreDataService()
            ),
            loadingViewModel: VisibilityViewModel(),
            retryErrorViewModel: VisibilityViewModel()
        )
        
        bindToCountriesPublisher()
        bindToLoadingPublisher()
        bindToRetryErrorPublisher()

        vm.loadCountries()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    //MARK: - RotateScreen Handler
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        configureCollectionViewLayout()
    }

    //MARK: - UI Methods

    private func configureNavigationBar() {
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //MARK: - Helper Methods
    
    private func bindToCountriesPublisher() {
        vm.countriesPublisher
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] list in
                self?.refreshCollectionViewDataSource(with: list, animatingDifferences: true)
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
                } else {
                    self?.hideRetryErrorView()
                }
            })
            .store(in: &subscriptions)
    }
    
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
}

//MARK: - LoadingView Configuration

extension CountryListViewController {
    
    private func configureLoadingView() {
        configureLoadingViewConstraints()
    }
    
    private func configureLoadingViewConstraints() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // loadingView.centerY = superview.centerY
        constraints += [
            NSLayoutConstraint.init(
                item: loadingView!, attribute: .centerY,
                relatedBy: .equal,
                toItem: view, attribute: .centerY,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // loadingView.centerX = superview.centerX
        constraints += [
            NSLayoutConstraint.init(
                item: loadingView!, attribute: .centerX,
                relatedBy: .equal,
                toItem: view, attribute: .centerX,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // loadingView.width = 50
        constraints += [
            NSLayoutConstraint.init(
                item: loadingView!, attribute: .width,
                relatedBy: .equal,
                toItem: nil, attribute: .notAnAttribute,
                multiplier: 1.0, constant: 50.0
            )
        ]
        
        // loadingView.width = loadingView.height
        constraints += [
            NSLayoutConstraint.init(
                item: loadingView!, attribute: .width,
                relatedBy: .equal,
                toItem: loadingView!, attribute: .height,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}

//MARK: - RetryErrorView Configuration

extension CountryListViewController {
    
    private func configureRetryErrorView() {
        retryErrorView.delegate = self
        
        configureRetryErrorViewConstraints()
    }
    
    private func configureRetryErrorViewConstraints() {
        retryErrorView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // retryErrorView.top = superview.top
        constraints += [
            NSLayoutConstraint.init(
                item: retryErrorView!, attribute: .top,
                relatedBy: .equal,
                toItem: view, attribute: .top,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // retryErrorView.bottom = superview.bottom
        constraints += [
            NSLayoutConstraint.init(
                item: retryErrorView!, attribute: .bottom,
                relatedBy: .equal,
                toItem: view, attribute: .bottom,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // retryErrorView.leading = superview.leading
        constraints += [
            NSLayoutConstraint.init(
                item: retryErrorView!, attribute: .leading,
                relatedBy: .equal,
                toItem: view, attribute: .leading,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // retryErrorView.trailing = superview.trailing
        constraints += [
            NSLayoutConstraint.init(
                item: retryErrorView!, attribute: .trailing,
                relatedBy: .equal,
                toItem: view, attribute: .trailing,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: - RetryErrorViewDelegate
extension CountryListViewController: RetryErrorViewDelegate {
    func didPressRetry() {
        vm.retryLoadCountries()
    }
}


//MARK: - CollectionView Configuration

extension CountryListViewController {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        
        collectionView.register(
            CountryCell.self,
            forCellWithReuseIdentifier: CountryCell.reuseIdentifier
        )
        
        configureCollectionViewConstraints()
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
    }
    
    private func configureCollectionViewLayout() {
        
        let itemWidthDimension: NSCollectionLayoutDimension = .fractionalWidth(1.0)
        let itemHeightDimension: NSCollectionLayoutDimension = .fractionalHeight(1.0)
        let itemLayout = NSCollectionLayoutSize(widthDimension: itemWidthDimension, heightDimension: itemHeightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemLayout)
        
        
        let groupWidthDimension: NSCollectionLayoutDimension = .fractionalWidth(1.0)
        let groupHeightDimension: NSCollectionLayoutDimension = .fractionalHeight(traitCollection.isRegularHeight ? 0.07 : 0.15)
        let groupItemCount = traitCollection.isCompactHeight ? 2 : 1
        let groupLayout = NSCollectionLayoutSize(widthDimension: groupWidthDimension, heightDimension: groupHeightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayout, subitem: item, count: groupItemCount)
        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0)
        
        let collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
        
        collectionView.setCollectionViewLayout(collectionViewLayout, animated: true)
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, CountryDto>(collectionView: collectionView) {
            (collectionView, indexPath, country) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCell.reuseIdentifier, for: indexPath) as? CountryCell else {
                fatalError("Cannot create country cell!")
            }
            
            cell.country = country
            return cell
        }
                
        refreshCollectionViewDataSource(with: [])
    }
    
    private func refreshCollectionViewDataSource(with list: [CountryDto], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CountryDto>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func configureCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // collectionView.top = view.safeAreaLayoutGuide.top
        constraints += [
            NSLayoutConstraint.init(
                item: collectionView!, attribute: .top,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide, attribute: .top,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // collectionView.bottom = view.safeAreaLayoutGuide.bottom
        constraints += [
            NSLayoutConstraint.init(
                item: collectionView!, attribute: .bottom,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide, attribute: .bottom,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // collectionView.leading = view.safeAreaLayoutGuide.leading + 20
        constraints += [
            NSLayoutConstraint.init(
                item: collectionView!, attribute: .leading,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide, attribute: .leading,
                multiplier: 1.0, constant: 20.0
            )
        ]
        
        // collectionView.trailing = view.safeAreaLayoutGuide.trailing - 20
        constraints += [
            NSLayoutConstraint.init(
                item: collectionView!, attribute: .trailing,
                relatedBy: .equal,
                toItem: view.safeAreaLayoutGuide, attribute: .trailing,
                multiplier: 1.0, constant: -20.0
            )
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}

//MARK: - Collection View Delegate

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
