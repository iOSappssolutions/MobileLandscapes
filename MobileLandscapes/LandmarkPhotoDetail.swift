//
//  LandmarkPhotoDetail.swift
//  MobileLandscapes
//
//  Created by Miroslav Djukic on 20/12/2019.
//  Copyright © 2019 Miroslav Djukic. All rights reserved.
//

import UIKit

class LandmarkPhotoDetail: UIViewController {
    
    let imageView = UIImageView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    init(imageUrl: String) {
        super.init(nibName: nil, bundle: nil)
        imageView.getAsyncImage(imageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        addConstraints()
        setup()
        view.backgroundColor = .systemBackground
    }
    
    private func setGestureActions() {
        let pinchGesture = UIPinchGestureRecognizer()
        scrollView.addGestureRecognizer(pinchGesture)
        
    }
    
    private func setup() {
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.view.setNeedsLayout()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
    }
    
    private func addConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
      
        if let image = imageView.image {
            let heightratio = ((image.size.height ) * image.scale) / ((image.size.width ) * image.scale)
            imageView.heightAnchor.constraint(equalToConstant: (view.frame.size.width - 32) * heightratio).isActive = true
        }
  }

}

extension LandmarkPhotoDetail: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
