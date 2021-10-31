//
//  CountryListViewController+View.swift
//  Kontry_UIKit
//
//  Created by Ahmed Shendy on 10/31/21.
//

import Foundation
import UIKit

// MARK: - SubViews Configuration

extension CountryListViewController {
    
    func configureNavigationBar() {
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        searchController.searchBar.delegate = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.placeholder = Constant.Placeholder.searchByName
        searchController.searchBar.keyboardType = .alphabet
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        definesPresentationContext = true
    }
    
    func configureLoadingView() {
        // Constraint Configuration
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
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
    
}

//MARK: - CollectionView Configuration

extension CountryListViewController {
    
    func configureCollectionView() {
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        
        collectionView.register(
            CountryCell.self,
            forCellWithReuseIdentifier: CountryCell.reuseIdentifier
        )
        
        // Constraint Configuration
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20.0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20.0),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        configureCollectionViewLayout()
        configureCollectionViewDataSource()
    }
    
    func configureCollectionViewLayout() {
        
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
    
    func configureCollectionViewDataSource() {
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
    
    func refreshCollectionViewDataSource(with list: [CountryDto], animatingDifferences: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CountryDto>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(list, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}
