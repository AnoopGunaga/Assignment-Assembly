//
//  ViewController.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop Gunaga on 01/10/21.
//

import UIKit
import RxSwift
import RxCocoa
import ProgressHUD

class HomeViewController: BaseViewController, UIGestureRecognizerDelegate {
    private let disposeBag = DisposeBag()
    private var isSearchInProgress = false
    private let pageTitle = "Pics Browser"

    var viewModel: HomeViewModel!
    
    @IBOutlet private weak var noItemsErroLabel: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var homepageTableView: UITableView!
    
    static func create() -> HomeViewController? {
        guard let homeVC = UIStoryboard.controller(
                ofTpe: HomeViewController.type,
                storyboard: .main) as? HomeViewController else { return nil }
        homeVC.viewModel = HomeViewModel(delegate: homeVC)
        return homeVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.title = pageTitle

        configureGesture()
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.redditThemeColor],
            for: .normal)
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white],
            for: .selected)
        bind()
        viewModel.fetchRedditImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(
            shouldHide: false,
            tintColor: .white,
            titleTextColor: .white)
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)

        tapGesture
            .rx
            .event
            .bind(onNext: { [weak self] recognizer in
                guard let self = self else { return }
                if self.isSearchInProgress {
                    self.endEditing()
                }
        }).disposed(by: disposeBag)

    }
    
    private func bind() {
        viewModel.redditImagesAPIStatus
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .loading:
                    self?.showProgressIndicator()
                case .success:
                    self?.hideProgressIndicator()
                    self?.homepageTableView.reloadData()
                case .failure(let errorType, let error):
                    self?.hideProgressIndicator()
                    self?.handleError(errorType: errorType, error: error)
                case .none: break
                }
            }).disposed(by: disposeBag)
        
        segmentedControl
            .rx
            .selectedSegmentIndex
            .changed
            .subscribe(onNext: { [weak self] segment in
                self?.viewModel.homeSegmentRelay.accept(HomeSegment(rawValue: segment) ?? .none)
            }).disposed(by: disposeBag)
    }
    
    private func handleErrorUI () {
        homepageTableView.isHidden = (viewModel.numberOfItems > 0) ? false : true
        noItemsErroLabel.isEnabled = !homepageTableView.isHidden        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if !isSearchInProgress {
            return false
        }
        return true
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        handleErrorUI()
        return viewModel.numberOfItems
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155.0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomePageListCell") as? HomePageListCell else { return UITableViewCell() }
        
        guard let item = viewModel.item(atindex: indexPath.row).imageInfo else { return UITableViewCell() }
        cell.configure(
            thumbnail: item.thumbnail ?? "",
            title: item.title ?? "",
            timestamp: item.timestamp)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedImage = viewModel.item(atindex: indexPath.row)
        guard let detailPageController = DetailPageViewController.create(
            selectedImage: selectedImage,
            isFavorite: false) else { return }
        
        navigationController?.pushViewController(
            detailPageController,
            animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate, FilterResultProtocol {
    func refreshFilteredFeed() {
        homepageTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterText.accept(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchInProgress = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchInProgress = false
    }
}
