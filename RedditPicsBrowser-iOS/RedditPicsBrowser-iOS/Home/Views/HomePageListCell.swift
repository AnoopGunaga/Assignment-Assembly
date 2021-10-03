//
//  HomePageListCell.swift
//  RedditPicsBrowser-iOS
//
//  Created by Anoop on 02/10/21.
//

import UIKit

class HomePageListCell: UITableViewCell {

    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timestampLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(
        thumbnail: String? = "",
        title: String? = "",
        timestamp: String? = "") {
            titleLabel.text = title
            timestampLabel.text = timestamp
            thumbnailImageView.setImage(from: thumbnail ?? "")
    }
}
