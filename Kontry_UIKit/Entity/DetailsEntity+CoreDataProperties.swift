//
//  DetailsEntity+CoreDataProperties.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/20/21.
//
//

import Foundation
import CoreData


extension DetailsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailsEntity> {
        return NSFetchRequest<DetailsEntity>(entityName: "Details")
    }

    @NSManaged public var alpha2_code: String?
    @NSManaged public var capital: String?
    @NSManaged public var demonym: String?
    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var population: Int64
    @NSManaged public var region: String?
    @NSManaged public var currencies: NSSet?
    @NSManaged public var languages: NSSet?

}

// MARK: Generated accessors for currencies
extension DetailsEntity {

    @objc(addCurrenciesObject:)
    @NSManaged public func addToCurrencies(_ value: CurrencyEntity)

    @objc(removeCurrenciesObject:)
    @NSManaged public func removeFromCurrencies(_ value: CurrencyEntity)

    @objc(addCurrencies:)
    @NSManaged public func addToCurrencies(_ values: NSSet)

    @objc(removeCurrencies:)
    @NSManaged public func removeFromCurrencies(_ values: NSSet)

}

// MARK: Generated accessors for languages
extension DetailsEntity {

    @objc(addLanguagesObject:)
    @NSManaged public func addToLanguages(_ value: LanguageEntity)

    @objc(removeLanguagesObject:)
    @NSManaged public func removeFromLanguages(_ value: LanguageEntity)

    @objc(addLanguages:)
    @NSManaged public func addToLanguages(_ values: NSSet)

    @objc(removeLanguages:)
    @NSManaged public func removeFromLanguages(_ values: NSSet)

}

extension DetailsEntity : Identifiable {

}
