//
//  CoreDataStack.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/9/21.
//

import Foundation
import CoreData
import Combine

// Responsibility:
// It sets up coredata stack components like persistent container,
//   persistent store, managed object context, etc.
final class CoreDataStack {
    
    //MARK: - Static Properties
    
    private static var _shared: CoreDataStack!
    
    static var shared: CoreDataStack {
        if _shared == nil  {
            _shared = CoreDataStack()
        }
        
        return _shared
    }
    
    //MARK: - Properties
    
    private let name = "Kontry"
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: name)
        
        container.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private(set) lazy var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    //MARK: - init Mehtods
    
    private init() {
    }
}
