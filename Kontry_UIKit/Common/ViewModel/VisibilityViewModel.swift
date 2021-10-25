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
    
    //MARK: - Properties
    
    private let publisher = PassthroughSubject<Bool, Never>()
    
    func getPublisher() -> PassthroughSubject<Bool, Never> {
        return publisher
    }
    
    //MARK: - Send Events Methods
    
    func show() {
        publisher.send(true)
    }
    
    func hide() {
        publisher.send(false)
    }
}
