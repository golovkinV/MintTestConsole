//
//  FeatureService.swift
//  
//
//  Created by Vladimir Golovkin on 17.12.2021.
//

import Foundation
import Combine

public protocol FeatureService {
    func fetchFeatures() -> AnyPublisher<[Feature], Never>
    func changeFeatureState(_ model: Feature) -> AnyPublisher<Void, Never>
}

public final class DefaultFeatureService: FeatureService {
    
    private let featuerRepository: FeatureRepository = DefaultFeatureRepository()
    
    public func fetchFeatures() -> AnyPublisher<[Feature], Never> {
        Deferred {
            Future<[Feature], Never> { [weak self] promise in
                guard let self = self else { return }
                let items = self.featuerRepository.fetchFeatures()
                promise(.success(items))
            }
        }.eraseToAnyPublisher()
    }
    
    public func changeFeatureState(_ model: Feature) -> AnyPublisher<Void, Never> {
        Deferred {
            Future<Void, Never> { [weak self] promise in
                self?.featuerRepository.changeFeatureState(model)
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
}
