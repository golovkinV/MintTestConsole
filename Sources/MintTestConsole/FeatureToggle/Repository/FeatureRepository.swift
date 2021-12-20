//
//  FeatureRepository.swift
//  
//
//  Created by Vladimir Golovkin on 17.12.2021.
//

import Foundation

public protocol FeatureRepository {
    func fetchFeatures() -> [Feature]
    func fetchFeatureState(_ model: Feature) -> Bool
    func changeFeatureState(_ model: Feature)
//    func changeBaseUrl(_ type: BaseUrl)
}

public final class DefaultFeatureRepository: FeatureRepository {
    
    public func fetchFeatures() -> [Feature] {
        FeatureToggleContainer.shared.provider.features.map { feature -> Feature in
            var feature = feature
            feature.isActive = fetchFeatureState(feature)
            return feature
        }
    }
    
    public func fetchFeatureState(_ model: Feature) -> Bool {
        UserDefaults.standard.bool(forKey: model.key)
    }
    
    public func changeFeatureState(_ model: Feature) {
        UserDefaults.standard.set(model.isActive, forKey: model.key)
    }
    
//    func changeBaseUrl(_ type: BaseUrl) {
//        UserDefaults.standard.set(type.rawValue, forKey: FeatureName.baseUrl.rawValue)
//    }
    
}
