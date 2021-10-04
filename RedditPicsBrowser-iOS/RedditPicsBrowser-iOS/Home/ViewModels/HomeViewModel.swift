//
//  HomeViewModel.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop Gunaga on 01/10/21.
//

import Foundation
import RxSwift
import RxRelay

protocol FilterResultProtocol: AnyObject {
    func refreshFilteredFeed()
}

enum RedditImagesAPIStatus {
    case none
    case loading
    case success
    case failure(ErrorType, Error?)
}

enum HomeSegment: Int {
    case feed = 0
    case favorite
    case none
}

class HomeViewModel {
    private let disposeBag = DisposeBag()
    
    private var redditImages: [RedditPicture] = []
    private var filteredReddtImages: [RedditPicture] = []
    
    weak var delegate: FilterResultProtocol?
    var filterText: PublishRelay<String> = PublishRelay<String>()
    var redditImagesAPIStatus: BehaviorRelay<RedditImagesAPIStatus> = BehaviorRelay(value: .none)
    var homeSegmentRelay: BehaviorRelay<HomeSegment> = BehaviorRelay<HomeSegment>(value: .none)
    
    init(delegate: FilterResultProtocol) {
        self.delegate = delegate
        bind()
    }
    
    func fetchRedditImages() {
        redditImagesAPIStatus.accept(.loading)
        APIRequest.request(
            type: .redditPics,
            contentType: .json,
            requestMethod: .get) { [weak self] responseObj in
                guard let response = responseObj as? RedditPicsModel,
                let children = response.payload?.pictures else {
                    self?.redditImagesAPIStatus.accept(.failure(.responseError, nil))
                    return
                }
                self?.redditImages = children
                self?.filteredReddtImages = children
                self?.redditImagesAPIStatus.accept(.success)
            } errorHandler: {  [weak self] (type, error) in
                self?.redditImagesAPIStatus.accept(.failure(type, error))
            }
    }
    
    
    func fetchFavorites() {
        filteredReddtImages = FavoriteManager.shared.getFavorites() ?? []
    }

    var numberOfItems: Int {
        return filteredReddtImages.count
    }
    
    func item(atindex index: Int) -> RedditPicture {
        let imagedata = filteredReddtImages[index]
        return imagedata
    }
    
    private func bind() {
        filterText
            .asObservable()
            .subscribe(onNext: { [weak self] searchString in
                self?.filterListBasedOnTitle(searchText: searchString)
            }).disposed(by: disposeBag)
        
        homeSegmentRelay
            .asObservable()
            .subscribe(onNext: { [weak self] segment in
                switch segment {
                case .favorite: self?.fetchFavorites()
                case .feed: self?.filteredReddtImages = self?.redditImages ?? []
                case .none: return
                }
                self?.delegate?.refreshFilteredFeed()
            }).disposed(by: disposeBag)
    }
    
    private func filterListBasedOnTitle(searchText: String) {
        if searchText.isEmpty {
            switch homeSegmentRelay.value {
            case .none, .feed: filteredReddtImages = redditImages
            case .favorite: fetchFavorites()
            }
        } else {
            filteredReddtImages = redditImages.filter {
                ($0.pictureInfo?.title?.contains(searchText)) ?? false
            }
        }
        delegate?.refreshFilteredFeed()
    }
}
