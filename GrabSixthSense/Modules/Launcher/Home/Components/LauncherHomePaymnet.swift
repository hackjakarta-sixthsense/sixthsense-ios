//
//  LauncherHomePaymnet.swift
//  GrabClone
//
//  Created by Ardyan Atmojo on 23/07/24.
//

import UIKit
import SkeletonView

class LauncherHomePaymnet: UICollectionView,
    UICollectionViewDelegateFlowLayout,
    SkeletonCollectionViewDataSource {
    
    private let flowLayout = UICollectionViewFlowLayout()
    
    var contentSources: Launcher.Home.PaymentResponse?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        
        delegate = self
        dataSource = self
        backgroundColor = .clear
        register(ContentCell.self,
            forCellWithReuseIdentifier: ContentCell.id)
        
        flowLayout.minimumLineSpacing = .apply(insets: .xSmall)
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
        return contentSources?.payment?.listPayment?.count ?? 0
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.id, for: indexPath) as! ContentCell
        
        if let data = contentSources?.payment?.listPayment, indexPath.item < data.count {
            cell.configure(data: data[indexPath.item])
        }
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - .apply(insets: .medium) * 2
        return .init(width: width / 2 - .apply(insets: .xSmall), height: collectionView.bounds.height)
    }
    
    internal func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ContentCell.id
    }
    
    private class ContentCell: UICollectionViewCell {
        
        private let labelVSV = UIStackView()
        private let captionLabel = UILabel()
        private let titleLabel = UILabel()
        private let contentIV = UIImageView()
        
        static let id = String(describing: ContentCell.self)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            clipsToBounds = true
            layer.cornerRadius = 6
            layer.masksToBounds = true
            isSkeletonable = true
            
            [labelVSV, contentIV].forEach { [weak self] view in
                self?.contentView.addSubview(view)
            }
            
            labelVSV.axis = .vertical
            labelVSV.spacing = .apply(insets: .xSmall)
            labelVSV.constraints(
                leading: leadingAnchor, trailing: contentIV.leadingAnchor,
                centerY: (centerYAnchor, 0), padding: .init(
                    top: 0, left: .apply(insets: .body),
                    bottom: 0, right: .apply(insets: .small)))
            
            [captionLabel, titleLabel].forEach { [weak self] view in
                self?.labelVSV.addArrangedSubview(view)
            }
            
            captionLabel.font = .apply(.regular, size: .subhead)
            
            titleLabel.font = .apply(.medium, size: .subhead)
            
            contentIV.contentMode = .scaleAspectFit
            contentIV.constraints(
                bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(
                    top: 0, left: 0, bottom: .apply(insets: .small), right: .apply(insets: .small)),
                width: .apply(iconSize: .body), height: .apply(iconSize: .body))
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        func configure(data: Launcher.Home.PaymentResponse.Payload?) {
            if let data = data {
                [labelVSV, contentIV].forEach {
                    $0.alpha = 1
                }
                
                captionLabel.text = data.caption
                titleLabel.text = data.content
                
                if let url = data.icon {
                    contentIV.apply(loadFrom: url)
                }
                
                backgroundColor = .grayBG
            } else {
                [labelVSV, contentIV].forEach {
                    $0.alpha = 0
                }
                
                backgroundColor = .clear
            }
        }
    }
}
