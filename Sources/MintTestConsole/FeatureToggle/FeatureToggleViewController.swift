//
//  FeatureToggleViewController.swift
//  
//
//  Created by Vladimir Golovkin on 17.12.2021.
//

import UIKit
import SnapKit

public final class FeatureToggleViewController: UIViewController {
    
    private var bag = CancelBag()
    
    let viewModel: FeatureToggleViewModel = .init()
    
    private(set) var items: [Feature] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private(set) lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout().apply {
            $0.itemSize = .init(width: UIScreen.main.bounds.width, height: 48)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).apply {
            $0.backgroundColor = .white
            $0.dataSource = self
            $0.delegate = self
            $0.register(of: FeatureSwitchCell.self)
            $0.register(of: ContextCell.self)
        }
        return collectionView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setUpBindings()
        viewModel.input.didLoad.send(())
    }
    
    // MARK: - SetUp Bindings
    
    private func setupViews() {
        title = "Testing"
        view.backgroundColor = .white
        view.addSubview(collectionView)
        layoutConstraints()
    }
    
    private func layoutConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setUpBindings() {
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    func bindViewToViewModel() {}
    
    func bindViewModelToView() {
        viewModel.output.$items
            .sink(receiveValue: { [weak self] in
                self?.items = $0
            })
            .store(in: &bag)
    }
}

extension FeatureToggleViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = items[indexPath.item]
        switch item.type {
        case .switch:
            let cell = collectionView.dequeueReusableCell(of: FeatureSwitchCell.self, at: indexPath)
            return cell.setDelegate(self).configure(item)
        case .contextMenu:
            let cell = collectionView.dequeueReusableCell(of: ContextCell.self, at: indexPath)
            return cell.configure(item)
        }
    }
}

extension FeatureToggleViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        let item = items[indexPath.item]
//        guard item.type == .contextMenu else { return nil }
//        return configureContextMenu(index: indexPath.row)
//    }
//
//    private func configureContextMenu(index: Int) -> UIContextMenuConfiguration {
//        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
//            let currentBaseUrl = FeatureProvider.shared.baseUrlType ?? Configuration.buildUrlType
//            let prod = UIAction(title: "Production", state: currentBaseUrl == .production ? .on: .off) { [weak self] _ in
//                self?.viewModel.changeBaseUrl(.production)
//            }
//            let stage = UIAction(title: "Staging", state: currentBaseUrl == .staging ? .on: .off) { [weak self] _ in
//                self?.viewModel.changeBaseUrl(.staging)
//            }
//            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [prod, stage])
//        }
//    }
}

extension FeatureToggleViewController: FeatureDelegate {
    public func changeState(_ model: Feature?) {
        guard let model = model else { return }
//        viewModel.changeFeatureState(model)
    }
}
