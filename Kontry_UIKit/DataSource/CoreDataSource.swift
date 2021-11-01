//
//  CoreDataSource.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/9/21.
//

import Foundation
import CoreData
import Combine

// Responsibility:
// It handle tasks that require storing data for offline use.
// It does it using CoreData.
final class CoreDataSource: LocalPersistenceSource {
    
    //MARK: - Properties
    
    private lazy var coreDataStack = CoreDataStack.shared
    
    //MARK: - CRUD Operations
    
    func findFlagEntity(for alpha2Code: String) -> AnyPublisher<FlagEntity?, PersistenceError> {
        let fetchRequest: NSFetchRequest<FlagEntity> = FlagEntity.fetchRequest()
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K =[c] %@", #keyPath(FlagEntity.alpha2_code), alpha2Code)
        
        return fetchSingleItem(fetchRequest)
    }
    
    func createFlagEntity(for alpha2Code: String, _ image: Data) {
        let newFlagEntity = FlagEntity(context: coreDataStack.managedContext)
        
        newFlagEntity.alpha2_code = alpha2Code
        newFlagEntity.image = image
        
        saveContext()
    }
    
    func findDetailsEntity(for alpha2Code: String) -> AnyPublisher<DetailsEntity?, PersistenceError> {
        let fetchRequest: NSFetchRequest<DetailsEntity> = DetailsEntity.fetchRequest()
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K =[c] %@", #keyPath(DetailsEntity.alpha2_code), alpha2Code)
        
        return fetchSingleItem(fetchRequest)
    }
    
    func createDetailsEntity(from countryDetails: CountryDetailsModel) {
        let newDetailsEntity = DetailsEntity(context: coreDataStack.managedContext)
        
        newDetailsEntity.name = countryDetails.name
        newDetailsEntity.alpha2_code = countryDetails.alpha2Code
        newDetailsEntity.capital = countryDetails.capital
        newDetailsEntity.region = countryDetails.region
        newDetailsEntity.population = Int64(countryDetails.population)
        newDetailsEntity.latitude = countryDetails.latlng[0]
        newDetailsEntity.longitude = countryDetails.latlng[1]
        newDetailsEntity.demonym = countryDetails.demonym
        
        newDetailsEntity.addToCurrencies(
            NSSet(
                array: countryDetails.currencies
                    .map { currency -> CurrencyEntity in
                        let entity = CurrencyEntity(context: coreDataStack.managedContext)
                        entity.code = currency.code
                        entity.details = newDetailsEntity
                        
                        return entity
                    }
            )
        )
        
        newDetailsEntity.addToLanguages(
            NSSet(
                array: countryDetails.languages
                    .map { language -> LanguageEntity in
                        let entity = LanguageEntity(context: coreDataStack.managedContext)
                        entity.name = language.name
                        
                        return entity
                    }
            )
        )
        
        saveContext()
    }
    
    //MARK: - Helper Methods
    
    private func saveContext() {
        guard coreDataStack.managedContext.hasChanges else { return }
        
        do {
            try coreDataStack.managedContext.save()
            
        } catch let error as NSError {
            print("LOCAL_PERSISTENCE_ERROR: \(error.userInfo)")
        }
    }
    
    private func fetchSingleItem<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<T?, PersistenceError> {
        return Future<T?, Error> {
            [weak self] promise in
            guard let self = self else { return }
            
            do {
                let result = try self.coreDataStack.managedContext.fetch(fetchRequest)
                promise(.success(result.first))
                
            } catch let error as NSError {
                promise(.failure(PersistenceError(error: error)))
            }
        }
        .mapError { $0 as! PersistenceError }
        .eraseToAnyPublisher()
    }
}
