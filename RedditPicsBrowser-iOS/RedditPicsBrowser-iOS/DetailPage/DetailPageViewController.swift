//
//  DetailPageViewController.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop on 02/10/21.
//

import UIKit
import RxSwift

class DetailPageViewController: BaseViewController {
    @IBOutlet private weak var photoView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var timeStampLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var addToFavoriteButton: UIButton!
    
    private let favoriteImage = UIImage(named: "favorite")
    private let unFavoriteImage = UIImage(named: "unfavorite")
    
    private let pageTitle = "PhotoView"
    
    private let disposeBag = DisposeBag()
    private var viewModel: DetailPageViewModel!
    static func create(selectedImage: RedditPics,
                       isFavorite: Bool) -> DetailPageViewController? {
        guard let detailPage = UIStoryboard.controller(
                ofTpe: DetailPageViewController.type,
                storyboard: .detail) as? DetailPageViewController else { return nil }
        detailPage.viewModel = DetailPageViewModel(
            image: selectedImage,
            isFavorite: false)

        return detailPage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        bind()
        configureNavigationBar(
            shouldHide: false,
            tintColor: .white,
            titleTextColor: .white)
        self.title = pageTitle
        addToFavoriteButton.setTitle("", for: .normal)
        
        let favoriteButtonImage = (viewModel.isFavorite) ? favoriteImage : unFavoriteImage
        addToFavoriteButton.setImage(
            favoriteButtonImage,
            for: .normal)
        populateImageInfo()
    }
    
    private func bind() {
        addToFavoriteButton
            .rx
            .tap
            .asDriver().drive(onNext: { [weak self] in
                if (self?.viewModel.isFavorite ?? false) {
                    self?.viewModel.removeFromFavorites()
                    self?.addToFavoriteButton.setImage(
                        self?.unFavoriteImage,
                        for: .normal)
                } else {
                    self?.viewModel.addToFavorite()
                    self?.addToFavoriteButton.setImage(
                        self?.favoriteImage,
                        for: .normal)
                }
            }).disposed(by: disposeBag)
    }
    
    private func populateImageInfo() {
        photoView.setImage(
            from: viewModel.photoUrl,
            shouldShowProgressView: true)
        titleLabel.text = viewModel.title
        categoryLabel.text = viewModel.contentCategory
        timeStampLabel.text = viewModel.timeStamp
    }
}
