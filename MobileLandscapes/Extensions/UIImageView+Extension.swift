//
//  UIImageView+Extension.swift
//  MobileLandscapes
//
//  Created by Miroslav Djukic on 19/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func getAsyncImage(_ urlString: String, row: Int? = nil) {
        self.image = nil
        if let cachedImage = LandscapePhotos.getImage(by: urlString) {
            self.image = cachedImage
        } else {
            self.downloadImage(urlString, row: row)
        }
    }
  
    private func downloadImage(_ urlString: String, row: Int? = nil) {
        let sv = showSpinner()
        URLSession.shared.dataTask(with: URL(string: urlString)! as URL, completionHandler: { [weak self] (data, response, error) -> Void in
            self?.removeSpinner(sv)
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                if let r = row {
                    if(self?.tag == r) {
                        self?.image = image
                        if let image = image, let data = image.jpegData(compressionQuality: 1) {
                            LandscapePhotos.cacheImage(data, photoUrl: urlString)
                        }
                    }
                } else {
                    self?.image = image
                }
            })

        }).resume()
    }
  
    func showSpinner()->UIView {
      let ai = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.large)
        ai.startAnimating()
        ai.center = self.center
        ai.tintColor = .white
        
        DispatchQueue.main.async {
            self.addSubview(ai)
        }
        
        return ai
    }
    
    func removeSpinner(_ spinner: UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
