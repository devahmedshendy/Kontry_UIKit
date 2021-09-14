//
//  ViewModel.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 8/10/21.
//

import Foundation

final class Store {
    
    //MARK: - Properties
    
    private let defaultSession: URLSession = {
        let defaultConfig = URLSessionConfiguration.default
        
        return URLSession(configuration: defaultConfig)
    }()
    
    //MARK: - RestCountries API Methods
    
    func fetchAllCountries(completion: @escaping (Result<[CountryDetail], Error>) -> Void) {
        let url = RestCountriesAPI.allURL
        let request = URLRequest(url: url)
        
        let task = defaultSession.dataTask(with: request) {
            (data, response, error) in
            
            let result = self.processAllCountriesRequest(data: data, error: error)
            
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        task.resume()
    }
    
    func processAllCountriesRequest(data: Data?, error: Error?) -> Result<[CountryDetail], Error> {
        guard let data = data else {
            return .failure(error!)
        }
        
        do {
            let result = try JSONDecoder().decode([CountryDetail].self, from: data)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
