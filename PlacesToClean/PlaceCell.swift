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
        self.contentView.backgroundColor = UIColor(named: "colorMain2")

        //Thumbnail Border
        self.placeImageView.layer.borderWidth = 2
        self.placeImageView.layer.cornerRadius = 5.0
        self.placeImageView.contentMode = UIView.ContentMode.scaleToFill
        /*
        if super.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            self.placeImageView.layer.borderColor = UIColor.white.cgColor
        } else {
            // User Interface is Light
            self.placeImageView.layer.borderColor = UIColor.black.cgColor
        }*/
        
        self.placeImageView.layer.borderColor = UIColor(named: "colorGrey")?.cgColor

        //Text Color
        self.placeTitleLabel.textColor = UIColor(named: "colorText1")
        self.placeSubtitleLabel.textColor = UIColor(named: "colorText2")

        //onTap Color
        let view = UIView()
        view.backgroundColor = UIColor(named: "colorMain3")
        self.selectedBackgroundView? = view
    }
}
