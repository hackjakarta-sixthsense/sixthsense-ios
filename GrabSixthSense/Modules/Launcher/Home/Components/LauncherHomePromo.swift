//
//  LauncherHomePromo.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 23/07/24.
//

import UIKit
import SkeletonView

class LauncherHomePromo: UIView,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    SkeletonCollectionViewDataSource {
    
    private let titleLabel = UILabel()
    private let flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(
        frame: .zero, collectionViewLayout: flowLayout)
    
    var contentSources: Launcher.Home.PromoResponse?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [titleLabel, collectionView].forEach { [weak self] view in
            self?.addSubview(view)
        }
        
        titleLabel.font = .apply(.medium, size: .body)
        titleLabel.linesCornerRadius = 6
        titleLabel.skeletonTextLineHeight = .relativeToConstraints
        titleLabel.constraints(
            top: topAnchor, leading: leadingAnchor,
            trailing: trailingAnchor, padding: .init(
                top: 0, left: .apply(insets: .medium),
                bottom: 0, right: .apply(insets: .medium)),
            height: 22
        )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(PromoCell.self,
            forCellWithReuseIdentifier: PromoCell.id)
        collectionView.constraints(
            top: titleLabel.bottomAnchor, leading: leadingAnchor,
            bottom: bottomAnchor, trailing: trailingAnchor)
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = .apply(insets: .small)
        flowLayout.sectionInset = .init(
            top: .apply(insets: .body), left: .apply(insets: .medium),
            bottom: 0, right: .apply(insets: .medium))
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func assignState(with state: ApiState) {
        switch state {
        case .loading:
            titleLabel.isSkeletonable = true
            titleLabel.showAnimatedGradientSkeleton()
            collectionView.prepareSkeleton { [weak self] _ in
                self?.collectionView.visibleCells.forEach {
                    $0.contentView.showAnimatedGradientSkeleton()
                }
            }
        case .success:
            [titleLabel, collectionView].forEach {
                $0.hideSkeleton()
            }
        default: break
        }
        
        titleLabel.text = contentSources?.title
        collectionView.reloadData()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentSources?.payload?.count ?? 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromoCell.id, for: indexPath) as! PromoCell
        
        if let data = contentSources?.payload, indexPath.item < data.count {
            cell.configure(data: data[indexPath.item])
        }
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 169, height: collectionView.bounds.height - .apply(insets: .body))
    }
    
    internal func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return PromoCell.id
    }
    
    internal func collectionSkeletonView(_ skeletonView: UICollectionView, prepareCellForSkeleton cell: UICollectionViewCell, at indexPath: IndexPath) {
        (cell as? PromoCell)?.configure(data: nil)
    }
    
    private class PromoCell: UICollectionViewCell {
        
        private let contentIV = UIImageView()
        private let titleLabel = UILabel()
        private let calendarHSV = UIStackView()
        private let dateIV = UIImageView()
        private let dateLabel = UILabel()
        
        static let id = String(describing: PromoCell.self)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            isSkeletonable = true
            contentView.isSkeletonable = true
            
            [contentIV, titleLabel, calendarHSV].forEach { [weak self] view in
                self?.contentView.addSubview(view)
            }
            
            contentIV.contentMode = .scaleAspectFill
            contentIV.clipsToBounds = true
            contentIV.layer.cornerRadius = 6
            contentIV.layer.masksToBounds = true
            contentIV.isSkeletonable = true
            contentIV.constraints(
                top: topAnchor, leading: leadingAnchor,
                trailing: trailingAnchor, height: 170)
            
            titleLabel.font = .apply(.regular, size: .subhead)
            titleLabel.numberOfLines = 2
            titleLabel.isSkeletonable = true
            titleLabel.skeletonTextLineHeight = .fixed(18)
            titleLabel.linesCornerRadius = 6
            titleLabel.constraints(
                top: contentIV.bottomAnchor, leading: leadingAnchor,
                trailing: trailingAnchor, padding: .init(
                    top: .apply(insets: .xSmall), left: 0, bottom: 0, right: 0
                ), height: 36)
            
            calendarHSV.axis = .horizontal
            calendarHSV.spacing = .apply(insets: .xSmall)
            calendarHSV.constraints(
                top: titleLabel.bottomAnchor, leading: leadingAnchor,
                trailing: trailingAnchor, padding: .init(
                    top: .apply(insets: .smallest), left: 0, bottom: 0, right: 0
                ), height: .apply(iconSize: .smallest))
            
            [dateIV, dateLabel].forEach { [weak self] view in
                self?.calendarHSV.addArrangedSubview(view)
            }
            
            dateIV.image = .init(systemName: "calendar")?
                .withRenderingMode(.alwaysTemplate)
            dateIV.tintColor = .black
            dateIV.constraints(
                width: .apply(iconSize: .smallest),
                height: .apply(iconSize: .smallest))
            
            dateLabel.font = .apply(.regular, size: .caption)
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        func configure(data: Launcher.Home.PromoResponse.Payload?) {
            if let data = data {
                calendarHSV.alpha = 1
                contentIV.image = .apply(
                    assets: (Assets(rawValue: data.image!) ?? .none)!)
                titleLabel.text = data.title
                dateLabel.text = "Until \(data.validUntil ?? "")"
            } else {
                calendarHSV.alpha = 0
                contentIV.image = nil
                titleLabel.text = nil
                dateLabel.text = nil
            }
        }
    }

}
