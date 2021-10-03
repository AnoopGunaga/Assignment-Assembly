//
//  UIImage+Utilities.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop on 02/10/21.
//

import Foundation
import UIKit
import ProgressHUD
import Reachability

extension UIImageView {
    func setImage(
        from url: String,
        shouldShowProgressView: Bool = false) {
            self.backgroundColor = UIColor.redditThemeColor.withAlphaComponent(0.5)
            guard let imageUrl = URL(string: url) else {
                setPlaceholder()
                return
            }
            
            if !Utilities.isInternetConnectivityAvailable {
                setPlaceholder()
                return
            }
            
            if shouldShowProgressView {
                ProgressHUD.show()
            }
            
            URLSession.shared.dataTask(with: imageUrl) { [weak self] data, response, error in
                if error != nil {
                    DispatchQueue.main.async {
                        if shouldShowProgressView {
                            ProgressHUD.dismiss()
                        }
                        self?.setPlaceholder()
                    }
                }
                guard let imageData = data else {
                    self?.setPlaceholder()
                    return
                }
                
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    if shouldShowProgressView {
                        ProgressHUD.dismiss()
                    }
                    self?.image = image
                    self?.contentMode = .scaleAspectFit
                }
            }.resume()
        }
    
    private func setPlaceholder() {
        DispatchQueue.main.async {
            self.image = UIImage(named: Constants.placeholderImageName)
        }
    }
    
}
