//
//  Photos.swift
//  MobileLandscapes
//
//  Created by Miroslav Djukic on 19/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import Foundation

struct Photos: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: String
    let photo: [Photo]?
}

struct PhotoSearchResponse: Decodable {
    let photos: Photos
}
