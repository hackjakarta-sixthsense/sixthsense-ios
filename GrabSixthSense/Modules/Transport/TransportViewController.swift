//
//  TransportViewController.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit
import GoogleMaps
import AVFoundation

class TransportViewController: ViewController {
    
    private let viewModel: TransportViewModel
    
    private let navbar = DesignatedNavbar()
    private let mapView = GMSMapView()
    private let micView = MicView()
    private let bottomView = BottomView()
    
    private var currentLocationCoordinate: String?
    private let locationManager = CLLocationManager()
    private var currentLocationDegrees: [CLLocationDegrees]?
    
    init(viewModel: TransportViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubviews([mapView, bottomView, micView, navbar])
        
        navbar.backAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true) }
        navbar.constraints(
            top: view.topAnchor, leading: view.leadingAnchor,
            trailing: view.trailingAnchor, height: .apply(currentDevice: .statusBarHeight) +
                .apply(contentSize: .rectHeight))
        micView.micAction = { [weak self] in
            let destinationPoint = String(self?.viewModel.destinationSuggestionList?.results?[0].geometry?.location?.lat ?? 0.0) + "," + String(self?.viewModel.destinationSuggestionList?.results?[0].geometry?.location?.lng ?? 0.0)
            self?.viewModel.fetch(originPoint: self?.currentLocationCoordinate ?? "0.0,0.0", destinationPoint: destinationPoint)
        }
        micView.constraints(
            leading: view.leadingAnchor, bottom: bottomView.topAnchor,
            trailing: view.trailingAnchor, height: .apply(contentSize: .rectHeight))
        
        bottomView.viewModel = viewModel
        bottomView.constraints(
            leading: view.leadingAnchor, bottom: view.bottomAnchor,
            trailing: view.trailingAnchor, height: viewModel.bottomViewHeight)
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: -6.194528, longitude: 106.8232249, zoom: 15.0)
        mapView.constraints(
            top: view.topAnchor, leading: view.leadingAnchor,
            bottom: bottomView.topAnchor, trailing: view.trailingAnchor)
    }
    
    internal override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupLocationManager()
    }
    //
    //    private func setupBackgroundView() {
    //        view.addSubview(backgroundView)
    //        backgroundView.backgroundColor = .white
    //        backgroundView.constraints(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    //        backgroundView.addSubviews([bottomView, mapView, backButton])
    //        setupBackgroundSubview()
    //    }
    
    //    private func setupBackgroundSubview() {
    //        setupBottomView()
    //        setupMapsView()
    //        setupBackButton()
    //    }
    //
    //    private func setupBottomView() {
    //        bottomView.constraints(leading: backgroundView.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: backgroundView.trailingAnchor, height: .apply(contentSize: .actionBottomViewHeight))
    //        bottomView.addSubviews([calendarButton, bookButton, labelOption])
    //        setupBottomSubview()
    //    }
    //
    //    private func setupMapsView() {
    //        mapView.constraints(top: backgroundView.topAnchor, leading: backgroundView.leadingAnchor, bottom: bottomView.topAnchor, trailing: backgroundView.trailingAnchor)
            
    //    }
    //
    //    private func setupBackButton() {
    //        backButton.translatesAutoresizingMaskIntoConstraints = false
    //        backButton.constraints(top: backgroundView.safeAreaLayoutGuide.topAnchor, leading: backgroundView.leadingAnchor, padding: .init(top: 0, left: .apply(insets: .medium), bottom: 0, right: 0), width: .apply(iconSize: .large), height: .apply(iconSize: .large))
    //        backButton.backgroundColor = .white
    //        backButton.tintColor = .black
    //        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
    //    }
    //
    //    private func setupBottomSubview() {
    //        setupCalendarButton()
    //        setupBookButton()
    //        setupLabelOption()
    //    }
    //
    //    private func setupBookButton() {
    //        bookButtonWidthAnchor = bookButton.widthAnchor.constraint(greaterThanOrEqualToConstant: .apply(contentSize: .buttonHeight))
    //        bookButton.translatesAutoresizingMaskIntoConstraints = false
    //        bookButton.constraints(
    //            leading: calendarButton.trailingAnchor,
    //            bottom: view.safeAreaLayoutGuide.bottomAnchor,
    //            trailing: bottomView.trailingAnchor,
    //            padding: .init(top: 0, left: .apply(insets: .xSmall), bottom: 0, right: .apply(insets: .medium)),
    //            height: .apply(contentSize: .tabbarHeight),
    //            customAnchors: [bookButtonWidthAnchor!])
    //
    //        let attributes: [NSAttributedString.Key: Any] = [
    //            .font: UIFont.apply(.medium, size: .body),
    //            .foregroundColor: UIColor.white
    //        ]
    //        let attributedTitle = NSAttributedString(string: "Book GrabCar", attributes: attributes)
    //        bookButton.setAttributedTitle(attributedTitle, for: .normal)
    //        bookButton.tintColor = .white
    //        bookButton.backgroundColor = .systemGreen
    //    }
    
    //    private func setupCalendarButton() {
    //        calendarButton.translatesAutoresizingMaskIntoConstraints = false
    //        calendarButton.constraints(leading: bottomView.leadingAnchor, centerY: (bookButton.centerYAnchor, 0), padding: .init(top: 0, left: .apply(insets: .medium), bottom: 0, right: 0), width: .apply(iconSize: .xLarge), height: .apply(iconSize: .xLarge))
    //        calendarButton.tintColor = .darkGray
    //        calendarButton.backgroundColor = .systemGray2
    //        calendarButton.setImage(UIImage(systemName: "calendar"), for: .normal)
    //        calendarButton.addTarget(self, action: #selector(handleCalendarButton), for: .touchUpInside)
    //    }
    //
    //    private func setupLabelOption() {
    //        labelOption.constraints(top: bottomView.topAnchor, leading: bottomView.leadingAnchor, bottom: bookButton.topAnchor, trailing: bottomView.trailingAnchor, padding: .init(top: .apply(insets: .medium), left: .apply(insets: .medium), bottom: .apply(insets: .medium), right: .apply(insets: .medium)))
    //        labelOption.text = "Data result"
    //        labelOption.textColor = .black
    //    }
}

extension TransportViewController {
    
    private class DesignatedNavbar: UIView {
        
        private let navView = UIView()
        private let backButton = UIButton()
        
        var backAction: (() -> ())?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(navView)
            
            navView.constraints(
                top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor,
                trailing: trailingAnchor, padding: .init(
                    top: .apply(currentDevice: .statusBarHeight),
                    left: 0, bottom: 0, right: 0))
            
            navView.addSubview(backButton)
            
            backButton.backgroundColor = .white
            backButton.layer.cornerRadius = 18
            backButton.icon(source: .init(systemName: "arrow.left"))
            backButton.addTarget(self, action: #selector(handleBack(_:)), for: .touchUpInside)
            backButton.constraints(
                leading: navView.leadingAnchor, centerY: (navView.centerYAnchor, 0),
                padding: .init(top: 0, left: .apply(insets: .medium), bottom: 0, right: 0),
                width: 36, height: 36)
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        @objc private func handleBack(_ sender: UIButton) {
            backAction?()
        }
    }
    
    private class MicView: UIView {
        
        private let micButton = UIButton()
        
        var micAction: (() -> ())?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(micButton)
            
            micButton.icon(source: .init(systemName: "mic"))
            micButton.backgroundColor = .white
            micButton.layer.cornerRadius = 18
            micButton.tintColor = .accent
            micButton.addTarget(self, action: #selector(handleMic(_:)), for: .touchUpInside)
            micButton.constraints(
                trailing: trailingAnchor, centerY: (centerYAnchor, 0), padding: .init(
                    top: 0, left: 0, bottom: 0, right: .apply(insets: .medium)
                ), width: 36, height: 36)
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        @objc private func handleMic(_ sender: UIButton) {
            micAction?()
        }
    }
    
    private class BottomView: UIView,
                              UICollectionViewDelegate,
                              UICollectionViewDelegateFlowLayout,
                              UICollectionViewDataSource {
        
        private let flowLayout = UICollectionViewFlowLayout()
        private lazy var collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: flowLayout)
        private let priorityLabel = UILabel()
        private let footerView = UIView()
        private let calendarButton = UIButton()
        private let bookButton = UIButton()
        
        weak var viewModel: TransportViewModel?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            backgroundColor = .white
            
            addSubviews([collectionView, priorityLabel, footerView])
            
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.backgroundColor = .clear
            collectionView.register(TransportCell.self,
                                    forCellWithReuseIdentifier: TransportCell.id)
            collectionView.constraints(
                top: topAnchor, leading: leadingAnchor,
                bottom: priorityLabel.topAnchor, trailing: trailingAnchor)
            
            flowLayout.minimumLineSpacing = .zero
            
            priorityLabel.text = "Priority Booking \u{2022} Rp10.000"
            priorityLabel.font = .apply(.light, size: .subhead)
            priorityLabel.constraints(
                leading: leadingAnchor, bottom: footerView.topAnchor,
                trailing: trailingAnchor, padding: .init(
                    top: 0, left: .apply(insets: .medium),
                    bottom: 0, right: .apply(insets: .medium)),
                height: .apply(contentSize: .smallRectHeight))
            
            footerView.constraints(
                leading: leadingAnchor, bottom: safeAreaLayoutGuide.bottomAnchor,
                trailing: trailingAnchor, padding: .init(
                    top: 0, left: 0, bottom: viewModel?.bottomPadding ?? 0, right: 0
                ), height: .apply(contentSize: .buttonHeight))
            
            footerView.addSubviews([calendarButton, bookButton])
            
            calendarButton.icon(source: .init(systemName: "calendar"))
            calendarButton.backgroundColor = .grayBG
            calendarButton.layer.cornerRadius = .apply(contentSize: .buttonHeight) / 2
            calendarButton.constraints(
                leading: footerView.leadingAnchor, centerY: (footerView.centerYAnchor, 0),
                padding: .init(top: 0, left: .apply(insets: .medium), bottom: 0, right: 0),
                width: .apply(contentSize: .buttonHeight), height: .apply(contentSize: .buttonHeight))
            
            bookButton.setTitle("Book Now", for: .normal)
            bookButton.setTitleColor(.white, for: .normal)
            bookButton.setTitleFont(.apply(.medium, size: .subhead))
            bookButton.backgroundColor = .accent
            bookButton.layer.cornerRadius = .apply(contentSize: .buttonHeight) / 2
            bookButton.constraints(
                leading: calendarButton.trailingAnchor, trailing: trailingAnchor,
                centerY: (footerView.centerYAnchor, 0), padding: .init(
                    top: 0, left: .apply(insets: .body), bottom: 0,
                    right: .apply(insets: .medium)),
                height: .apply(contentSize: .buttonHeight))
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        func assignState(with state: ApiState) {
            collectionView.reloadData()
        }
        
        internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel?.typeResponse?.listType?.count ?? 0
        }
        
        internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TransportCell.id, for: indexPath) as! TransportCell
            
            if let data = viewModel?.typeResponse?.listType, indexPath.item < data.count {
                cell.configure(data: data[indexPath.item])
            }
            
            return cell
        }
        
        internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return .init(width: collectionView.bounds.width, height: .apply(contentSize: .largeRectHeight))
        }
    }
    
    private class TransportCell: UICollectionViewCell {
        
        private let colorLayer: CALayer = {
            let layer = CALayer()
            layer.backgroundColor = UIColor.accent
                .withAlphaComponent(0.1).cgColor
            return layer
        }()
        
        private let contentIV = UIImageView()
        private let titleVSV = UIStackView()
        private let titleLabel = UILabel()
        private let estimateLabel = UILabel()
        private let priceLabel = UILabel()
        
        static let id = String(describing: TransportCell.self)
        
        override var isSelected: Bool { didSet {
            UIView.animate(withDuration: 0.25) { [weak self] in
                self?.animateSelection()
            }
        }}
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            contentView.addSubviews([contentIV, titleVSV, priceLabel])
            
            contentIV.image = .apply(assets: .iconTransportBike)
            contentIV.contentMode = .scaleAspectFit
            contentIV.constraints(
                leading: leadingAnchor, centerY: (centerYAnchor, 0), padding: .init(
                    top: 0, left: .apply(insets: .medium), bottom: 0, right: 0
                ), width: 36, height: 36)
            
            titleVSV.axis = .vertical
            titleVSV.spacing = .apply(insets: .xSmall)
            titleVSV.constraints(
                leading: contentIV.trailingAnchor, trailing: priceLabel.leadingAnchor,
                centerY: (centerYAnchor, 0), padding: .init(
                    top: 0, left: .apply(insets: .body),
                    bottom: 0, right: .apply(insets: .body)
                )
            )
            
            titleVSV.addArrangedSubviews([titleLabel, estimateLabel])
            
            titleLabel.font = .apply(.medium, size: .subhead)
            
            estimateLabel.font = .apply(.regular, size: .caption)
            estimateLabel.textColor = .black.withAlphaComponent(0.38)
            
            priceLabel.textAlignment = .right
            priceLabel.font = .apply(.medium, size: .body)
            priceLabel.constraints(
                trailing: trailingAnchor, centerY: (centerYAnchor, 0), padding: .init(
                    top: 0, left: 0, bottom: 0, right: .apply(insets: .medium)
                ), width: 100)
            
            contentView.layer.addSublayer(colorLayer)
            colorLayer.removeFromSuperlayer()
            colorLayer.frame = bounds
        }
        
        required init?(coder: NSCoder) { fatalError() }
        
        func configure(data: Transport.TypeResponse.Payload?) {
            titleLabel.text = data?.title
            estimateLabel.text = "\(data?.estimateTime ?? "") min"
            priceLabel.text = data?.price
        }
        
        private func animateSelection() {
            if isSelected {
                contentView.layer.insertSublayer(colorLayer, at: 0)
            } else {
                colorLayer.removeFromSuperlayer()
            }
        }
    }
}

extension TransportViewController {
    
    func assignState(state: ApiState) {
        bottomView.assignState(with: state)
        
        switch state {
        case .success: updateMaps()
        case .failure: viewModel.fetchDestinationSuggestion()
        default: break
        }
    }
}

extension TransportViewController {
    
    func updateMaps() {
        addMapMarker(originPoint: viewModel.originDegree ?? [CLLocationDegrees](), destinationPoint: viewModel.destinationDegree ?? [CLLocationDegrees]())
        mapsBoundSetter()
        updateMapsView(mapsPath: viewModel.mapsBounds ?? GMSPath())
    }
    
    private func addMapMarker(originPoint: [CLLocationDegrees], destinationPoint: [CLLocationDegrees]) {
        let sourceMarker = GMSMarker()
        sourceMarker.position = CLLocationCoordinate2D(latitude: originPoint[0], longitude: originPoint[1])
        sourceMarker.title = "Source"
        sourceMarker.map = mapView
        
        let destinationMarker = GMSMarker()
        destinationMarker.position = CLLocationCoordinate2D(latitude: destinationPoint[0], longitude: destinationPoint[1])
        destinationMarker.title = "Destination"
        destinationMarker.map = mapView
    }
    
    private func mapsBoundSetter() {
        let bounds = GMSCoordinateBounds(path: viewModel.mapsBounds ?? GMSPath())
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70.0))
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 70.0))
        }
    }
    
    func updateMapsView(mapsPath pathArray: GMSPath) {
        let currentPath = GMSMutablePath()
        let polyline = GMSPolyline(path: currentPath)
        polyline.strokeWidth = 8
        polyline.strokeColor = .systemGreen
        polyline.map = mapView
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if index < pathArray.count() {
                currentPath.add(pathArray.coordinate(at: UInt(index)))
                polyline.path = currentPath
                index += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

extension TransportViewController: CLLocationManagerDelegate {
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let currentLocation = location.coordinate
            currentLocationDegrees = [currentLocation.latitude, currentLocation.longitude]
            let point = String(currentLocation.latitude) + "," + String(currentLocation.longitude)
            currentLocationCoordinate = point
            viewModel.fetch(originPoint: point, destinationPoint: viewModel.destinationData?.valueRegex ?? "")
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {}
}
