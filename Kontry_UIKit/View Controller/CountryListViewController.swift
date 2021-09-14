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
    @IBOutlet weak var loadingView: UIStackView!
    
    //MARK: - Stored Properties
    
    private lazy var vm = CountryListViewModel()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Country>!
    
    private var collectionViewCancellables = Dictionary<Int, AnyCancellable?>()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Computed Properties
    
    private var collectionViewLayout: UICollectionViewCompositionalLayout {
        let itemLayout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemLayout)
        
        let groupLayout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupLayout, subitems: [item])
//        group.interItemSpacing = .fixed(15)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vm
            .$countryList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] list in
                self?.refreshCollectionViewDataSource(with: list, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cancellables.removeAll()
    }

    //MARK: - Helper Methods
    
    private func configureNavigationBar() {
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = UIColor.clear
        
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.register(
            UINib(nibName: CountryCell.nibName, bundle: nil),
            forCellWithReuseIdentifier: CountryCell.reuseIdentifier
        )
                
        configureCollectionViewDataSource()
    }
    
    private func configureCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Country>(collectionView: collectionView) {
            (collectionView, indexPath, country) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CountryCell.reuseIdentifier, for: indexPath) as? CountryCell else {
                fatalError("Cannot create country cell!")
            }
            
            cell.updateCell(with: country)
            return cell
        }
                
        refreshCollectionViewDataSource(with: [])
    }
    
    private func refreshCollectionViewDataSource(with list: [Country], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Country>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

//MARK: - Constraints Activation Methods

extension CountryListViewController {
    private func configureConstraints() {
        configureCollectionViewConstraints()
        configureLoadingViewConstraints()
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
    
    private func configureLoadingViewConstraints() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        // loadingView.centerY = view.centerY
        constraints += [
            NSLayoutConstraint.init(
                item: loadingView!, attribute: .centerY,
                relatedBy: .equal,
                toItem: view, attribute: .centerY,
                multiplier: 1.0, constant: 0.0
            )
        ]
        
        // loadingView.centerX = view.centerX
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
