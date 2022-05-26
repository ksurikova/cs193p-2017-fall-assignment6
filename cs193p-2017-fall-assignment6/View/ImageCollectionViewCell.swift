//
//  ImageCollectionViewCell.swift
//  cs193p-2017-fall-assignment6
//
//  Created by Ksenia Surikova on 17.08.2021.
//
import UIKit

let cache = URLCache.shared

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var imageURL : URL? {
        didSet {
            fetchImage()
        }
    }
    
    var indicateWhatImageIsWrong: (() -> Void)?
    
    private(set) var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            loadingIndicator?.stopAnimating()
        }
    }
    
    private func showImage(from data: Data, with url: URL){
        if url == self.imageURL {
            self.image = UIImage(data: data)
        }
    }
    
    private func showErrorImage(with url: URL){
        if url == self.imageURL {
            self.image = Utilities.imageNotFetchedEmoji.emojiToImage(size: Utilities.imageElementWidth)
            if let notify = self.indicateWhatImageIsWrong {
                notify()
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            loadingIndicator?.startAnimating()
            image = nil

            let request = URLRequest(url: url)
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                // get image from cache or load it (and memory in cache)
                if let response = cache.cachedResponse(for: request) {
                    DispatchQueue.main.async {
                        self.showImage(from: response.data, with: url)
                    }
                }
                else {
                    URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                        if let data = data, let response = response, error == nil {
                            let cachedData = CachedURLResponse(response: response, data: data)
                            cache.storeCachedResponse(cachedData, for: request)
                            DispatchQueue.main.async {
                                self.showImage(from: data, with: url)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                self.showErrorImage(with: url)
                            }
                        }
                    }).resume()
                    
                }
            }
        }

    }
}
