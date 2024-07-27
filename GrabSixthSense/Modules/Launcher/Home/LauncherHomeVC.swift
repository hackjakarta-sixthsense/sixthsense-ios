//
//  LauncherHomeVC.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

class LauncherHomeVC: ViewController {
    
    private let viewModel: LauncherHomeVM
    
    private let backgroundView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchBar = SearchTextField()
    
    init(viewModel: LauncherHomeVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        [backgroundView, scrollView].forEach { [weak self] view in
            self?.view.addSubview(view)
        }
        
        backgroundView.backgroundColor = .accent
        backgroundView.constraints(
            top: view.topAnchor, leading: view.leadingAnchor,
            trailing: view.trailingAnchor, height: viewModel.bgHeight)
        
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = .init(
            top: -CGFloat.apply(currentDevice: .statusBarHeight),
            left: 0, bottom: 0, right: 0)
        scrollView.constraints(
            top: view.topAnchor, leading: view.leadingAnchor,
            bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
        scrollView.addSubview(contentView)
        
        contentView.constraints(
            top: scrollView.topAnchor, leading: scrollView.leadingAnchor,
            bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor,
            width: .apply(currentDevice: .screenWidth), height: 1000
        )
        
        [searchBar].forEach { [weak self] view in
            self?.contentView.addSubview(view)
        }
        
        searchBar.micAction = {  }
        searchBar.constraints(
            top: contentView.topAnchor, leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor, padding: .init(
                top: .apply(currentDevice: .statusBarHeight) + .apply(insets: .medium),
                left: .apply(insets: .medium), bottom: 0, right: .apply(insets: .medium)),
            height: .apply(contentSize: .rectHeight))
    }
}

extension LauncherHomeVC: UIScrollViewDelegate {
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY < 0 {
            backgroundView.transform = .init(scaleX: 1, y: 1 - offsetY / (viewModel.bgHeight / 2))
        } else if offsetY > 0 {
            backgroundView.transform = .init(translationX: 0, y: -offsetY)
        } else {
            backgroundView.transform = .identity
        }
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            if offsetY > (self?.viewModel.bgHeight ?? 0) -
                .apply(contentSize: .rectHeight) / 2 {
                UIApplication.shared.statusBarView?
                    .backgroundColor = .white
            } else {
                UIApplication.shared.statusBarView?
                    .backgroundColor = .clear
            }
        }
        
        view.endEditing(true)
    }
    
    private class SearchTextField: UITextField {
        
        private let padding = UIEdgeInsets(
            top: 0, left: .apply(contentSize: .rectHeight),
            bottom: 0, right: .apply(contentSize: .rectHeight) * 2 +
                .apply(insets: .body)
        )
        
        private let searchIV = UIImageView()
        private let micIconView = UIImageView()
        private let vLineSeparator = UIView()
        private let scanQRIV = UIImageView()
        
        var micAction: (() -> ())?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .white
            tintColor = .darkGray
            layer.cornerRadius = 10
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.02
            layer.shadowOffset = CGSize(width: 0, height: 5)
            layer.shadowRadius = 4
            font = .apply(.regular, size: .body)
            placeholder = "Typing something here.."
            
            [searchIV, micIconView, vLineSeparator, scanQRIV].forEach { [weak self] view in
                self?.addSubview(view)
            }
            
            searchIV.image = .init(systemName: "magnifyingglass")?
                .withRenderingMode(.alwaysTemplate)
            searchIV.constraints(
                leading: leadingAnchor, centerY: (centerYAnchor, 0), padding: .init(
                    top: 0, left: 18, bottom: 0, right: 0), width: .apply(iconSize: .small),
                height: .apply(iconSize: .small))
            
            micIconView.image = .init(systemName: "mic")?
                .withRenderingMode(.alwaysTemplate)
            micIconView.tintColor = .accent
            micIconView.isUserInteractionEnabled = true
            micIconView.addGestureRecognizer(UITapGestureRecognizer(
                target: self, action: #selector(handleMic(_:))))
            micIconView.constraints(
                trailing: vLineSeparator.leadingAnchor, centerY: (centerYAnchor, 0),
                padding: .init(top: 0, left: 0, bottom: 0, right: 18),
                height: .apply(iconSize: .small))
            
            vLineSeparator.backgroundColor = .darkGray
                .withAlphaComponent(0.25)
            vLineSeparator.constraints(
                top: topAnchor, bottom: bottomAnchor,
                trailing: scanQRIV.leadingAnchor, padding: .init(
                    top: 0, left: 0, bottom: 0, right: 18
                ), width: 0.75)
            
            scanQRIV.image = .init(systemName: "qrcode.viewfinder")?
                .withRenderingMode(.alwaysTemplate)
            scanQRIV.constraints(
                trailing: trailingAnchor, centerY: (centerYAnchor, 0), padding: .init(
                    top: 0, left: 0, bottom: 0, right: 18), width: .apply(iconSize: .small),
                height: .apply(iconSize: .small))
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        @objc private func handleMic(_ sender: UITapGestureRecognizer) {
            micAction?()
        }
        
        // Override textRect to adjust the position of the text
        internal override func textRect(forBounds bounds: CGRect) -> CGRect {
            let insetRect = bounds.inset(by: padding)
            return super.textRect(forBounds: insetRect)
        }
        
        // Override editingRect to adjust the position of the text while editing
        internal override func editingRect(forBounds bounds: CGRect) -> CGRect {
            let insetRect = bounds.inset(by: padding)
            return super.editingRect(forBounds: insetRect)
        }
    }
}
