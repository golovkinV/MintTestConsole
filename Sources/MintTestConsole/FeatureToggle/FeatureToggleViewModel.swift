//
//  FeatureToggleViewModel.swift
//  
//
//  Created by Vladimir Golovkin on 17.12.2021.
//

import Foundation

public final class FeatureToggleViewModel {
    
    private var bag = CancelBag()
    
    public let input: Input = .init()
    public let output: Output = .init()
    
    public init() {
        setUpBindings()
    }
    
    func changeFeatureState(_ model: Feature) {
        FeatureToggleContainer.shared.service.changeFeatureState(model)
            .sink(receiveValue: {})
            .store(in: &bag)
    }
    
    private func setUpBindings() {
        input.didLoad.publisher
            .sink { [weak self] _  in
                self?.output.items = FeatureToggleContainer.shared.provider.features
            }
            .store(in: &bag)
    }
}

public extension FeatureToggleViewModel {
    class Input {
        var didLoad = PublishedAction<Void>()
    }
    
    class Output {
        @PublishedProperty var items: [Feature] = []
    }
}
