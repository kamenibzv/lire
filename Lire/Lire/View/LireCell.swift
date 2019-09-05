//
//  LireCell.swift
//  Lire
//
//  Created by Kameni Ngahdeu on 9/4/19.
//  Copyright © 2019 kaydabi. All rights reserved.
//

import UIKit
import SwipeCellKit

class LireCell: SwipeTableViewCell {
    // The cell for table views
    
    private lazy var cellImage: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 20, y: 10, width: 77, height: 120))
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "img_nocover")
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 107, y: 45, width: ScreenSize.width - 150, height: 25))
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "This is a tittle"
        return label
    }()
    
    private lazy var authorLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 107, y: 70, width: ScreenSize.width - 150, height: 22))
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Kwabena Dardby"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(book: Books?) {
        cellImage.setImageFrom(book)
        titleLabel.text = book?.title ?? "No Tittle"
        authorLabel.text = book?.authorName.joined(separator: " ,") ?? "No Author"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        addSubview(cellImage)
        addSubview(titleLabel)
        addSubview(authorLabel)
    }
    
    override func prepareForReuse() {
        cellImage.image = UIImage(named: "img_nocover")
    }

}
