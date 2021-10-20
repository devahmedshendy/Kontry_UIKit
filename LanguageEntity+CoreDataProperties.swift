//
//  LanguageEntity+CoreDataProperties.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/20/21.
//
//

import Foundation
import CoreData


extension LanguageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LanguageEntity> {
        return NSFetchRequest<LanguageEntity>(entityName: "Language")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var details: DetailsEntity?

}

extension LanguageEntity : Identifiable {

}
