//
//  PlaceCell.swift
//  PlacesToClean
//
//  Created by AGUS ROMERO on 17/11/22.
//

import UIKit

class PlaceCell: UITableViewCell {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeTitleLabel: UILabel!
    @IBOutlet weak var placeSubtitleLabel: UILabel!
    
    func applyTheme() {
        //Cell background color
        self.contentView.backgroundColor = UIColor(named: "primaryColor")

        //Thumbnail Border
        self.placeImageView.layer.borderWidth = 2
        self.placeImageView.layer.cornerRadius = 5.0

        if super.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            self.placeImageView.layer.borderColor = UIColor.white.cgColor

        } else {
            // User Interface is Light
            self.placeImageView.layer.borderColor = UIColor.black.cgColor
        }

        
        //Text Color
        self.placeTitleLabel.textColor = UIColor(named: "greyPrimary")
        self.placeSubtitleLabel.textColor = UIColor(named: "greySecondary")

        //onTap Color
        let view = UIView()
        view.backgroundColor = UIColor(named: "primaryBackground")
        self.selectedBackgroundView? = view
    }
}
