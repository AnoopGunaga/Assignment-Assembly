//
//  BaseViewController.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop Gunaga on 01/10/21.
//

import UIKit
import ProgressHUD

class BaseViewController: UIViewController {
    static var type: String {
        return String(describing: Self.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureNavigationBar(
        shouldHide: Bool,
        tintColor: UIColor = .redditThemeColor,
        titleTextColor: UIColor = .white) {
            navigationController?.navigationBar.isHidden = shouldHide
            navigationController?.navigationBar.tintColor = tintColor
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : tintColor]
        }
    
    func clearNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
    
    func showProgressIndicator() {
        ProgressHUD.show()
    }
    
    func hideProgressIndicator() {
        ProgressHUD.dismiss()
    }
    
    func handleError(
        errorType: ErrorType,
        error: Error?) {

        switch errorType {
        case .noNetworkError: ProgressHUD.showError(Constants.internetConnectivityErrorMessage)
        case .responseError: ProgressHUD.showError(Constants.responseErrorMessage)
        case .apiRequestError: ProgressHUD.showError(error?.localizedDescription)
        }
    }
}
