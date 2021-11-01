//
//  CurrencyEntity+CoreDataProperties.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/20/21.
//
//

import Foundation
import CoreData


extension CurrencyEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencyEntity> {
        return NSFetchRequest<CurrencyEntity>(entityName: "Currency")
    }

    @NSManaged public var code: String?
    @NSManaged public var id: UUID?
    @NSManaged public var details: DetailsEntity?

}

extension CurrencyEntity : Identifiable {

}
