//
//  Photo.swift
//  MobileLandscapes
//
//  Created by Miroslav Djukic on 19/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let owner: String?
    let secret: String
    let server: String
    let farm: Int
    let title: String?
    let ispublic: Int?
    let isfriend: Int?
    let isfamily: Int?
    
    func generatePhotoURL( )-> String {
        return "https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.id)_\(self.secret)_b.jpg"
    }
    
}
