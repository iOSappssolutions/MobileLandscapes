//
//  ServerQueries.swift
//  MobileLandscapes
//
//  Created by Miroslav Djukic on 19/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import Foundation

struct PhotoSearchRequest {
    

    private let url = "https://www.flickr.com/services/rest/"
    private let methodParam = "method"
    private let searchMethod = "flickr.photos.search"
    private let apiKeyParam = "api_key"
    private let hasGeoParam = "has_geo"
    private let geoContextParam = "has_geo"
    private let latParam = "lat"
    private let lonParam = "lon"
    private let radiusParam = "radius"
    private let formatParam = "format"
    private let nojsoncallbackParam = "nojsoncallback"
    private let apiKey = "84453decbd5c7dee48a296959de4c24d"
    private let hasGeo = "1"
    private let geoContext = "2"
    private let format = "json"
    private let nojsoncallback = "1"
    private let radius = "0.05"

    typealias CompletionHandler = (_ photoUrl:String?, _ error: Error?) -> Void
    
    func searchPhotos(lat: String, lon: String, completion: @escaping CompletionHandler) {
        
        guard var urlComponents = URLComponents(string: url) else { completion(nil, nil); return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: methodParam, value: searchMethod),
            URLQueryItem(name: apiKeyParam, value: apiKey),
            URLQueryItem(name: hasGeoParam, value: hasGeo),
            URLQueryItem(name: geoContextParam, value: hasGeo),
            URLQueryItem(name: latParam, value: lat),
            URLQueryItem(name: lonParam, value: lon),
            URLQueryItem(name: radiusParam, value: radius),
            URLQueryItem(name: formatParam, value: format),
            URLQueryItem(name: nojsoncallbackParam, value: nojsoncallback)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if((error) != nil){
                completion(nil, error)
            } else {
                if let data = data {
                    let decoder = JSONDecoder()
                    if let photoSearchResponse = try? decoder.decode(PhotoSearchResponse.self, from: data), let photos = photoSearchResponse.photos.photo, photos.count > 0 {
                        let photo = photos[0]
                        let urlString = photo.generatePhotoURL()
                        NSLog("photo found, url = %@", urlString)
                        completion(urlString, nil)
                    } else {
                        NSLog("no photos found, error = %@", error.debugDescription)
                        completion(nil, error)
                    }
                } else {
                    NSLog("no data returned, error = %@", error.debugDescription)
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
}
