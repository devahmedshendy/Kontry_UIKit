//
//  LoadingViewModel.swift
//  Kontry_UIKit
//
//  Created by  Ahmed Shendy on 10/23/21.
//

import Foundation
import Combine

protocol VisibilityViewModelProtocol {
    func getPublisher() -> PassthroughSubject<Bool, Never>
    func show()
    func hide()
}

final class VisibilityViewModel: VisibilityViewModelProtocol {
    
    //MARK: - Publishers
    
    private let publisher = PassthroughSubject<Bool, Never>()
    
    //MARK: - Send Events Methods
    
    func getPublisher() -> PassthroughSubject<Bool, Never> {
        return publisher
    }
    
    func show() {
        publisher.send(true)
    }
    
    func hide() {
        publisher.send(false)
    }
}