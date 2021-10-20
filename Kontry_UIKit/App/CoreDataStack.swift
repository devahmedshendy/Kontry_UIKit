//
//  CoreDataStack.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/9/21.
//

import Foundation
import CoreData
import Combine

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
    
    //MARK: - Helper Methods
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("COREDATA_ERROR: \(error.userInfo)")
        }
    }
    
    func fetchSingleItem<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<T?, CoreDataError> {
        return Future<T?, CoreDataError> {
            [weak self] promise in
            guard let self = self else { return }
            
            do {
                let result = try self.managedContext.fetch(fetchRequest)
                promise(.success(result.first))
                
            } catch let error as NSError {
                promise(.failure(CoreDataError(error: error)))
            }
        }
        .eraseToAnyPublisher()
    }
}
