//
//  TableViewCell.swift
//  MobileLandscapes
//
//  Created by Miroslav Djukic on 18/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import UIKit

class LandscapeCell: UITableViewCell {
  
    private let landscapePhoto = UIImageView()
    private let container = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        addConstraints()
        seutp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        contentView.addSubview(container)
        container.addSubview(landscapePhoto)
    }
    
    private func addConstraints() {
        container.translatesAutoresizingMaskIntoConstraints = false
        container.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        container.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        landscapePhoto.translatesAutoresizingMaskIntoConstraints = false
        landscapePhoto.topAnchor.constraint(equalTo: container.topAnchor, constant: 16).isActive = true
        landscapePhoto.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        landscapePhoto.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 16).isActive = true
        landscapePhoto.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -16).isActive = true
        landscapePhoto.centerXAnchor.constraint(lessThanOrEqualTo: container.centerXAnchor).isActive = true
    }
    
    private func seutp() {
        landscapePhoto.clipsToBounds = true
        landscapePhoto.contentMode = .scaleAspectFit
    }
    
    func setCell(imageUrl: String, row: Int) {
        self.landscapePhoto.tag = row
        self.landscapePhoto.getAsyncImage(imageUrl, row: row)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
