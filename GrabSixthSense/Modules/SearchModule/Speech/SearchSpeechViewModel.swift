//
//  SearchSpeechViewModel.swift
//  GrabSixthSense
//
//  Created by Ardyan Atmojo on 27/07/24.
//

import UIKit

class SearchSpeechViewModel: ViewModel {
    
    var coordinator: MainCoordinator?
    weak var view: SearchSpeechModal?
    
    var searchResponseData: SearchResponse?
    var onSearchResponseReceived: ((SearchResponse) -> ())?
    
    override init() {
        super.init()
        
        $apiState.sink { [weak self] state in
            self?.view?.assignState(state: state)
        }.store(in: &cancleableBag)
    }
    
    func fetch(prompt: String) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        SearchSpeechService.fetchSearchResult(requestPrompt: prompt) { [weak self] response in
            guard let self = self, let response = response else { return }
            self.searchResponseData = response
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            apiState = .success
        }
    }
    
    func dismissWithData() {
        guard let searchResponseDataSafe = searchResponseData else { return }
        print("search data: \(searchResponseDataSafe)")
        view?.dismiss(animated: true, completion: nil)
        self.onSearchResponseReceived?(searchResponseDataSafe)
    }
}
