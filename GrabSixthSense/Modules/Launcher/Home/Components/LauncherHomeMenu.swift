//
//  LauncherHomeMenu.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 23/07/24.
//

import UIKit
import SkeletonView

class LauncherHomeMenu: UICollectionView,
    UICollectionViewDelegateFlowLayout,
    SkeletonCollectionViewDataSource {
    
    private let flowLayout = UICollectionViewFlowLayout()
    
    var contentSources: Launcher.Home.MenuResponse?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        delegate = self
        dataSource = self
        backgroundColor = .clear
        register(MenuCell.self,
            forCellWithReuseIdentifier: MenuCell.id)
        
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.minimumLineSpacing = .zero
        flowLayout.sectionInset = .init(
            top: 0, left: .apply(insets: .medium),
            bottom: 0, right: .apply(insets: .medium))
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func assignState(with state: ApiState) {
        switch state {
        case .loading:
            isSkeletonable = true
            showAnimatedGradientSkeleton()
        case .success: hideSkeleton()
        default: break
        }
        
        reloadData()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentSources?.payload?.count ?? 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuCell.id, for: indexPath) as! MenuCell
        
        if let data = contentSources?.payload, indexPath.item < data.count {
            cell.configure(data: data[indexPath.item])
        }
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - .apply(insets: .medium) * 2
        let height: CGFloat = .apply(contentSize: .largeRectHeight) + .apply(insets: .body)
        
        return .init(width: width / 4, height: height)
    }
    
    internal func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MenuCell.id
    }
    
    internal func collectionSkeletonView(_ skeletonView: UICollectionView, prepareCellForSkeleton cell: UICollectionViewCell, at indexPath: IndexPath) {
        (cell as? MenuCell)?.configure(data: nil)
    }
    
    internal func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    private class MenuCell: UICollectionViewCell {
        
        private let contentVSV = UIStackView()
        private let contentIV = UIImageView()
        private let titleLabel = UILabel()
        
        static let id = String(describing: MenuCell.self)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            isSkeletonable = true
            
            contentView.addSubview(contentVSV)
            
            contentVSV.axis = .vertical
            contentVSV.spacing = .apply(insets: .xSmall)
            contentVSV.alignment = .center
            contentVSV.isSkeletonable = true
            contentVSV.constraints(
                centerX: (centerXAnchor, 0),
                centerY: (centerYAnchor, 0))
            
            [contentIV, titleLabel]
                .forEach { [weak self] view in
                    self?.contentVSV.addArrangedSubview(view)
                }
            
            contentIV.image = .apply(assets: .iconHomeFood)
            contentIV.contentMode = .scaleAspectFill
            contentIV.isSkeletonable = true
            contentIV.skeletonCornerRadius = 12
            contentIV.constraints(width: 50, height: 50)
            
            titleLabel.textAlignment = .center
            titleLabel.font = .apply(.regular, size: .subhead)
            titleLabel.isSkeletonable = true
            titleLabel.skeletonTextLineHeight = .relativeToConstraints
            titleLabel.linesCornerRadius = 4
            titleLabel.lastLineFillPercent = 100
            titleLabel.skeletonPaddingInsets = .init(
                top: 0, left: .apply(insets: .xSmall),
                bottom: 0, right: .apply(insets: .xSmall))
            titleLabel.constraints(width: bounds.width, height: 17)
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func configure(data: Launcher.Home.MenuResponse.Payload?) {
            if let data = data {
                contentIV.image = .apply(
                    assets: (Assets(rawValue: data.icon!) ?? .none)!)
                titleLabel.text = data.name
            } else {
                contentIV.image = nil
                titleLabel.text = nil
            }
        }
    }
}
