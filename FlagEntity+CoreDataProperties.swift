//
//  FlagEntity+CoreDataProperties.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/20/21.
//
//

import Foundation
import CoreData


extension FlagEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlagEntity> {
        return NSFetchRequest<FlagEntity>(entityName: "Flag")
    }

    @NSManaged public var alpha2_code: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?

}

extension FlagEntity : Identifiable {

}
