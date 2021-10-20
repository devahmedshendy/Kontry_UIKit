//
//  CoreDataService.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/9/21.
//

import Foundation
import CoreData
import Combine

final class CoreDataService {
    
    //MARK: - Properties
    
    private lazy var coreDataStack = CoreDataStack.shared
    
    //MARK: - CRUD Operations
    
    func findFlagEntity(for alpha2Code: String) -> AnyPublisher<FlagEntity?, CoreDataError> {
        let fetchRequest: NSFetchRequest<FlagEntity> = FlagEntity.fetchRequest()
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K =[c] %@", #keyPath(FlagEntity.alpha2_code), alpha2Code)
        
        return coreDataStack.fetchSingleItem(fetchRequest)
    }
    
    func createFlagEntity(for alpha2Code: String, _ image: Data) {
        let newFlagEntity = FlagEntity(context: coreDataStack.managedContext)
        
        newFlagEntity.alpha2_code = alpha2Code
        newFlagEntity.image = image
        
        coreDataStack.saveContext()
    }
    
    func findDetailsEntity(for alpha2Code: String) -> AnyPublisher<DetailsEntity?, CoreDataError> {
        let fetchRequest: NSFetchRequest<DetailsEntity> = DetailsEntity.fetchRequest()
        
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "%K =[c] %@", #keyPath(DetailsEntity.alpha2_code), alpha2Code)
        
        return coreDataStack.fetchSingleItem(fetchRequest)
    }
    
    func createDetailsEntity(from countryDetails: CountryDetails) {
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
        
        coreDataStack.saveContext()
    }
}
