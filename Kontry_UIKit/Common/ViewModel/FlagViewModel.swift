//
//  CountryCellvm.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 9/14/21.
//

import Foundation
import Combine

// Responsibility:
// A viewmodel that handles data/state required by any view displaying a country flag (ex: DetailsFlagImageView).
final class FlagViewModel {
    
    //MARK: - Properties
    
    let dataPublisher = PassthroughSubject<Data?, Never>()
    private var subscription: AnyCancellable?
    
    private let size: FlagSize
    private let flagsRepository: FlagsRepositoryProtocol
    
    var alpha2Code: String = "" {
        didSet {
            loadFlag()
        }
    }
    
    //MARK: - init Methods
    
    init(
        size: FlagSize,
        flagsRepository: FlagsRepositoryProtocol
    ) {
        self.size = size
        self.flagsRepository = flagsRepository
    }
    
    //MARK: - Send Events Methods
    
    private func send(data: Data?) {
        dataPublisher.send(data)
    }
    
    //MARK: - Actions
    
    func loadFlag() {
        clearPreviousSubscription()
        
        subscription = getAction()
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.send(data: nil)
                        print(error)
                    }
                },
                receiveValue: { [weak self] imageData in
                    self?.send(data: imageData)
                })
    }
    
    private func getAction() -> AnyPublisher<Data?, KontryError> {
        if size == .w40 {
            return flagsRepository
                .get40pxWidthFlag(for: alpha2Code)
        } else {
            return flagsRepository
                .get160pxWidthFlag(for: alpha2Code)
        }
    }
    
    private func clearPreviousSubscription() {
        subscription?.cancel()
        subscription = nil
    }
    
    func get40WidthFlag(alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        return flagsRepository
            .get40pxWidthFlag(for: alpha2Code)
    }
    
    func get160WidthFlag(alpha2Code: String) -> AnyPublisher<Data?, KontryError> {
        return flagsRepository
            .get160pxWidthFlag(for: alpha2Code)
    }
}
